import 'dart:convert';
import 'dart:math'; // Import the math library for Random
import 'package:get/get.dart';
// import 'dart:convert';
import 'dart:io';
// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:job/models/job_model.dart';
import 'package:job/models/state_model.dart';
import '../models/district_model.dart';

class DistrictController extends GetxController {
  final String baseUrl = "https://quantapixel.in/jobportal_simple/api";

  var featuredJobs = <JobModel>[].obs; // Observable list for featured jobs
  var recommendedJobs = <JobModel>[].obs;
  var districts = <DistrictModel>[].obs;
  var isLoading = false.obs;

  var states = <StateModel>[].obs; // Store all states
  var selectedStateId = 0.obs; // Track selected state ID

  @override
  void onInit() {
    fetchStates(); // Fetch states on initialization
    fetchDistricts(); // Fetch all districts on initialization
    ever(selectedStateId, (id) {
      fetchDistrictsById(
          id); // Fetch districts whenever selectedStateId changes
    });
    super.onInit();
  }

  Future<void> fetchFeaturedJobs() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/getAllFeaturedJobs"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          featuredJobs.value = List<JobModel>.from(
            data['data'].map((item) => JobModel.fromJson(item)),
          );
          selectRandomJobs(); // Select random jobs after fetching
        } else {
          Get.snackbar(
              "Error", "Failed to load featured jobs: ${data['message']}");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to load featured jobs: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load featured jobs: $e");
    }
  }

  // Select 2 random jobs from the featured jobs
  void selectRandomJobs() {
    if (featuredJobs.isNotEmpty) {
      final random = Random(); // Create an instance of Random
      recommendedJobs.clear(); // Clear previous recommendations
      // Get 2 unique random indices
      final indices = Set<int>();
      while (indices.length < 1 && indices.length < featuredJobs.length) {
        indices.add(random.nextInt(featuredJobs.length));
      }
      for (var index in indices) {
        recommendedJobs.add(featuredJobs[index]);
      }
    }
  }

  Future<void> fetchStates() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/allState"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          states.value = List<StateModel>.from(
            data['data'].map((item) => StateModel.fromJson(item)),
          );
          if (states.isNotEmpty) {
            selectedStateId.value = states.first.id; // Default to first state
          }
          print("States fetched: ${states.length}"); // Debug print
        } else {
          Get.snackbar("Error", "Failed to load states: ${data['message']}");
        }
      } else {
        Get.snackbar("Error", "Failed to load states: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load states: $e");
    }
  }

// Fetch districts by state ID
  // Fetch districts by state ID
  Future<void> fetchDistrictsById(int stateId) async {
    print("Fetching districts for state ID: $stateId...");
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse("$baseUrl/getDistrictsByStateId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"state_id": stateId}),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          districts.value = List<DistrictModel>.from(
            (data['data'] ?? []).map((item) => DistrictModel.fromJson(item)),
          );
          print("Districts fetched: ${districts.length}");
        } else {
          print("Failed to fetch districts: ${data['message']}");
          Get.snackbar(
              "Error", "Failed to fetch districts: ${data['message']}");
        }
      } else {
        print("Failed to fetch districts: ${response.statusCode}");
        Get.snackbar(
            "Error", "Failed to fetch districts: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in fetchDistrictsById: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fetch all districts
  Future<void> fetchDistricts() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("$baseUrl/allDistrict"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          districts.value = List<DistrictModel>.from(
            data['data'].map((item) => DistrictModel.fromJson(item)),
          );
        } else {
          Get.snackbar(
              "Error", "Failed to fetch districts: ${data['message']}");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to fetch districts: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

// Add district with image upload
  Future<void> addDistrict(String districtName, File imageFile) async {
    try {
      isLoading(true);
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/addDistrict"))
            ..fields['district'] = districtName
            ..fields['state_id'] =
                selectedStateId.value.toString(); // Ensure it's a string
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        final data = json.decode(responseData.body);
        if (data['status'] == 1) {
          districts.add(DistrictModel.fromJson(data['data']));
          districts.refresh();
          Get.snackbar("Success", "District added successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to add district");
        }
      } else {
        Get.snackbar("Error", "Failed to add district");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

// Update district with optional image
  Future<void> updateDistrict(
      int id, String districtName, File? imageFile) async {
    try {
      isLoading(true);
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/updateDistrict"))
            ..fields['id'] = id.toString()
            ..fields['district'] = districtName
            ..fields['state_id'] =
                selectedStateId.value.toString(); // Ensure it's a string

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        if (data['status'] == 1) {
          int index = districts.indexWhere((district) => district.id == id);
          if (index != -1) {
            districts[index] = DistrictModel.fromJson(data['data']);
            districts.refresh();
          }
          Get.snackbar("Success", "District updated successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to update district");
        }
      } else {
        Get.snackbar("Error", "Failed to update district");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Delete district
  Future<void> deleteDistrict(int id) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse("$baseUrl/deleteDistrict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          districts.removeWhere((district) => district.id == id);
          districts.refresh();
          Get.snackbar("Success", "District deleted successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to delete district");
        }
      } else {
        Get.snackbar("Error", "Failed to delete district");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }
}
