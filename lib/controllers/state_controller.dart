import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/state_model.dart';

class StateController extends GetxController {
  final String baseUrl = "https://quantapixel.in/jobportal_simple/api";

  var states = <StateModel>[].obs;
  var isLoading = false.obs;
  var selectedStateId = 0.obs;
  @override
  void onInit() {
    fetchStates();
    super.onInit();
  }

  // Fetch all states
  Future<void> fetchStates() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("$baseUrl/allState"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          states.value = List<StateModel>.from(
            data['data'].map((item) => StateModel.fromJson(item)),
          );
        } else {
          Get.snackbar("Error", "Failed to load states: ${data['message']}");
        }
      } else {
        Get.snackbar("Error", "Failed to load states: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load states: $e");
    } finally {
      isLoading(false);
    }
  }

  // Add state with image upload
  Future<void> addState(String stateName, File imageFile) async {
    try {
      isLoading(true);
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/addState"))
            ..fields['state'] = stateName;

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
          states.add(StateModel.fromJson(data['data']));
          states.refresh();
          Get.snackbar("Success", "State added successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to add state");
        }
      } else {
        Get.snackbar("Error", "Failed to add state: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Update state with optional image
  Future<void> updateState(int id, String stateName, File? imageFile) async {
    try {
      isLoading(true);
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/updateState"))
            ..fields['id'] = id.toString()
            ..fields['state'] = stateName;

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
          int index = states.indexWhere((state) => state.id == id);
          if (index != -1) {
            states[index] = StateModel.fromJson(data['data']);
            states.refresh();
          }
          Get.snackbar("Success", "State updated successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to update state");
        }
      } else {
        Get.snackbar("Error", "Failed to update state: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Delete state
  Future<void> deleteState(int id) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse("$baseUrl/deleteState"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          states.removeWhere((state) => state.id == id);
          states.refresh();
          Get.snackbar("Success", "State deleted successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to delete state");
        }
      } else {
        Get.snackbar("Error", "Failed to delete state: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }
}
