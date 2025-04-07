import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:job/models/job_model.dart';
import 'package:job/models/state_model.dart';
import 'package:job/models/district_model.dart';
import 'package:job/models/category_model.dart';

class JobController extends GetxController {
  final String baseUrl = "https://quantapixel.in/jobportal_simple/api";

  var jobs = <JobModel>[].obs;
  var isLoading = false.obs;

  var states = <StateModel>[].obs; // Store all states
  var districts = <DistrictModel>[].obs; // Store all districts
  var categories = <CategoryModel>[].obs; // Store all categories

  var selectedStateId = 0.obs; // Track selected state ID
  var selectedDistrictId = 0.obs; // Track selected district ID
  var selectedCategoryId = 0.obs; // Track selected category ID

  @override
  void onInit() {
    fetchStates(); // Fetch states on initialization
    fetchCategories(); // Fetch categories on initialization
    fetchJobs(); // Fetch jobs on initialization
    fetchDistricts(); // Fetch districts on initialization
    super.onInit();
  }

  // Fetch all jobs
  Future<void> fetchJobs() async {
    try {
      isLoading(true);
      print("Fetching jobs from $baseUrl/getAllJobs");
      final response = await http.get(Uri.parse("$baseUrl/getAllJobs"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Jobs fetched successfully: ${data['status']}");
        if (data['status'] == 1) {
          jobs.value = List<JobModel>.from(
            data['data'].map((item) => JobModel.fromJson(item)),
          );
          print("Jobs loaded: ${jobs.length}");
        } else {
          Get.snackbar("Error", "Failed to fetch jobs: ${data['message']}");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch jobs: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      print("Error fetching jobs: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchStates() async {
    try {
      print("Fetching states from $baseUrl/allState");
      final response = await http.get(Uri.parse("$baseUrl/allState"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("States fetched successfully: ${data['status']}");
        if (data['status'] == 1) {
          states.value = List<StateModel>.from(
            data['data'].map((item) => StateModel.fromJson(item)),
          );
          if (states.isNotEmpty) {
            selectedStateId.value = states.first.id; // Default to first state
            print("Default selected state ID: ${selectedStateId.value}");
          }
        } else {
          Get.snackbar("Error", "Failed to load states: ${data['message']}");
        }
      } else {
        Get.snackbar("Error", "Failed to load states: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load states: $e");
      print("Error fetching states: $e");
    }
  }

  Future<void> fetchDistricts() async {
    try {
      isLoading(true);
      print("Fetching districts from $baseUrl/allDistrict");
      final response = await http.get(Uri.parse("$baseUrl/allDistrict"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Districts fetched successfully: ${data['status']}");
        if (data['status'] == 1) {
          districts.value = List<DistrictModel>.from(
            data['data'].map((item) => DistrictModel.fromJson(item)),
          );
          print("Districts loaded: ${districts.length}");
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
      print("Error fetching districts: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      print("Fetching categories from $baseUrl/category");
      final response = await http.get(Uri.parse("$baseUrl/category"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Categories fetched successfully: ${data['status']}");
        if (data['status'] == 1) {
          categories.value = List<CategoryModel>.from(
            data['data'].map((item) => CategoryModel.fromJson(item)),
          );
          if (categories.isNotEmpty) {
            selectedCategoryId.value =
                categories.first.id; // Default to first category
            print("Default selected category ID: ${selectedCategoryId.value}");
          }
        } else {
          Get.snackbar(
              "Error", "Failed to load categories: ${data['message']}");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories: $e");
      print("Error fetching categories: $e");
    }
  }

  List<DistrictModel> get filteredDistricts {
    if (selectedStateId.value != 0) {
      return districts
          .where((district) => district.stateId == selectedStateId.value)
          .toList();
    } else {
      return [];
    }
  }

  Future<void> addJob(
      JobModel job, File? imageFile, File? requiredImageFile) async {
    try {
      isLoading(true);
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/addJobs"))
        ..fields['job_title'] = job.jobTitle
        ..fields['state_id'] = job.stateId.toString()
        ..fields['district_id'] = job.districtId.toString()
        ..fields['category_id'] = job.categoryId.toString()
        ..fields['company_name'] = job.companyName
        ..fields['company_location'] = job.companyLocation
        ..fields['salary'] = job.salary
        ..fields['qualification'] = job.qualification
        ..fields['experience'] = job.experience
        ..fields['gender'] = job.gender
        ..fields['marital_status'] = job.maritalStatus
        ..fields['contact_number'] = job.contactNumber
        ..fields['email'] = job.email
        ..fields['skills'] = job.skills
        ..fields['job_locations'] = job.jobLocations
        ..fields['job_description'] = job.jobDescription
        ..fields['expiry_at'] = job.expiryAt
        ..fields['is_featured'] = job.isFeatured.toString();

      // Add the company logo if a new one is provided
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'company_logo',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // Add the required image if a new one is provided
      if (requiredImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          requiredImageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // Add additional images if they are not null
      if (job.additionalImage1 != null && job.additionalImage1!.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_image1',
          job.additionalImage1!,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      if (job.additionalImage2 != null && job.additionalImage2!.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_image2',
          job.additionalImage2!,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        final data = json.decode(responseData.body);
        print("Job added successfully: ${data['status']}");
        if (data['status'] == 1) {
          jobs.add(JobModel.fromJson(data['data']));
          jobs.refresh();
          Get.snackbar("Success", "Job added successfully");
        } else {
          Get.snackbar("Error", "Failed to add job");
        }
      } else {
        print("Error Response: ${responseData.body}");
        // Get.snackbar("Error", "Failed to add job: Incorrect salary format");
      }
    } catch (e) {
      print("Exception occurred: $e");
      Get.snackbar("Error", "An error occurred while adding the job.");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateJob(
      int id, JobModel job, File? imageFile, File? requiredImageFile) async {
    try {
      isLoading(true);
      print("Updating job with ID: $id");

      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/updateJobs"))
            ..fields['id'] = id.toString()
            ..fields['job_title'] = job.jobTitle
            ..fields['state_id'] = job.stateId.toString()
            ..fields['district_id'] = job.districtId.toString()
            ..fields['category_id'] = job.categoryId.toString()
            ..fields['company_name'] = job.companyName
            ..fields['company_location'] = job.companyLocation
            ..fields['salary'] = job.salary
            ..fields['qualification'] = job.qualification
            ..fields['experience'] = job.experience
            ..fields['gender'] = job.gender
            ..fields['marital_status'] = job.maritalStatus
            ..fields['contact_number'] = job.contactNumber
            ..fields['email'] = job.email
            ..fields['skills'] = job.skills
            ..fields['job_locations'] = job.jobLocations
            ..fields['job_description'] = job.jobDescription
            ..fields['expiry_at'] = job.expiryAt
            ..fields['is_featured'] = job.isFeatured.toString();

      // Add the company logo if a new one is provided
      if (imageFile != null) {
        print("Adding company logo from path: ${imageFile.path}");
        request.files.add(await http.MultipartFile.fromPath(
          'company_logo',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
        print("No new company logo provided, using existing.");
      }

      // Add the required image if a new one is provided
      if (requiredImageFile != null) {
        print("Adding required image from path: ${requiredImageFile.path}");
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          requiredImageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
        print("No new required image provided, using existing.");
      }

      // Add additional images if they are not null and are local files
      if (job.additionalImage1 != null && job.additionalImage1!.isNotEmpty) {
        if (Uri.tryParse(job.additionalImage1!)?.hasScheme == false) {
          print("Adding additional image 1 from path: ${job.additionalImage1}");
          request.files.add(await http.MultipartFile.fromPath(
            'additional_image1',
            job.additionalImage1!,
            contentType: MediaType('image', 'jpeg'),
          ));
        } else {
          print(
              "Skipping additional image 1 as it is a URL: ${job.additionalImage1}");
        }
      } else {
        print("No additional image 1 provided.");
      }

      if (job.additionalImage2 != null && job.additionalImage2!.isNotEmpty) {
        if (Uri.tryParse(job.additionalImage2!)?.hasScheme == false) {
          print("Adding additional image 2 from path: ${job.additionalImage2}");
          request.files.add(await http.MultipartFile.fromPath(
            'additional_image2',
            job.additionalImage2!,
            contentType: MediaType('image', 'jpeg'),
          ));
        } else {
          print(
              "Skipping additional image 2 as it is a URL: ${job.additionalImage2}");
        }
      } else {
        print("No additional image 2 provided.");
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        print("Job updated successfully: ${data['status']}");
        if (data['status'] == 1) {
          int index = jobs.indexWhere((jobItem) => jobItem.id == id);
          if (index != -1) {
            jobs[index] = JobModel.fromJson(data['data']);
            jobs.refresh();
          }
          Get.snackbar("Success", "Job updated successfully");
        } else {
          // Get.snackbar("Error", data['message'] ?? "Failed to update job");
          print("Update failed with message: ${data['message']}");
        }
      } else {
        print("Failed to update job: ${response.statusCode}");
        print("Response body: ${responseData.body}");
        // Get.snackbar("Error", "Failed to update job: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred while updating job: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

// Delete job listing
  Future<void> deleteJob(int id) async {
    try {
      isLoading(true);
      print("Deleting job with ID: $id");
      final response = await http.post(
        Uri.parse("$baseUrl/deleteJobs"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Job deleted successfully: ${data['status']}");
        if (data['status'] == 1) {
          jobs.removeWhere((jobItem) => jobItem.id == id);
          jobs.refresh();
          Get.snackbar("Success", "Job deleted successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to delete job");
        }
      } else {
        Get.snackbar("Error", "Failed to delete job");
        print("Failed to delete job: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      print("Error deleting job: $e");
    } finally {
      isLoading(false);
    }
  }
}
