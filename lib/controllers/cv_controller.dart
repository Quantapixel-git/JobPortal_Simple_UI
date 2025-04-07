import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:job/models/cv_model.dart';

class ResumeController extends GetxController {
  final String baseUrl = "https://quantapixel.in/jobportal_simple/api";

  var resumes = <ResumeModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchResumes();
    super.onInit();
  }

  // Fetch all resumes
  Future<void> fetchResumes() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("$baseUrl/getAllProfiles"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          resumes.value = List<ResumeModel>.from(
            data['data'].map((item) => ResumeModel.fromJson(item)),
          );
        } else {
          Get.snackbar("Error", "Failed to fetch resumes: ${data['message']}");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to fetch resumes: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Add resume
  Future<void> addResume(ResumeModel resume, File? imageFile) async {
    try {
      isLoading(true);
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/addProfile"))
            ..fields['name'] = resume.name
            ..fields['dob'] = resume.dob
            ..fields['email'] = resume.email
            ..fields['mobile'] = resume.mobile
            ..fields['qualification'] = resume.qualification
            ..fields['experience'] = resume.experience
            ..fields['skills'] = resume.skills
            ..fields['address'] = resume.address
            ..fields['linkedin'] = resume.linkedin;

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'resume',
          imageFile.path,
          contentType: MediaType('application',
              'pdf'), // Change to 'pdf' if you're uploading a PDF
        ));
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      // Log the response body for debugging
      print("Response status: ${response.statusCode}");
      print("Response body: ${responseData.body}");

      if (response.statusCode == 201) {
        final data = json.decode(responseData.body);
        if (data['status'] == 1) {
          resumes.add(ResumeModel.fromJson(data['data']));
          resumes.refresh();
          Get.snackbar("Success", "Resume added successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to add resume");
        }
      } else {
        Get.snackbar("Error", "Failed to add resume: ${responseData.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Delete resume
  Future<void> deleteResume(int id) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse("$baseUrl/deleteProfile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          resumes.removeWhere((resume) => resume.id == id);
          resumes.refresh();
          Get.snackbar("Success", "Resume deleted successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to delete resume");
        }
      } else {
        Get.snackbar("Error", "Failed to delete resume");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }
}
