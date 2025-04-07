import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  final String baseUrl = "https://quantapixel.in/jobportal_simple/api";

  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("$baseUrl/category"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          categories.value = List<CategoryModel>.from(
            data['data'].map((item) => CategoryModel.fromJson(item)),
          );
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
    } finally {
      isLoading(false);
    }
  }

  // Add category with image upload
  Future<void> addCategory(String categoryName, File imageFile) async {
    try {
      isLoading(true);
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/add-category"))
            ..fields['categorie'] =
                categoryName; // Use 'categorie' as per your JSON

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
          categories.add(CategoryModel.fromJson(data['data']));
          categories.refresh();
          Get.snackbar("Success", "Category added successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to add category");
        }
      } else {
        Get.snackbar("Error", "Failed to add category: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Update category with optional image
  Future<void> updateCategory(
      int id, String categoryName, File? imageFile) async {
    try {
      isLoading(true);
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/update-category"))
            ..fields['id'] = id.toString()
            ..fields['categorie'] =
                categoryName; // Use 'categorie' as per your JSON

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
          int index = categories.indexWhere((category) => category.id == id);
          if (index != -1) {
            categories[index] = CategoryModel.fromJson(data['data']);
            categories.refresh();
          }
          Get.snackbar("Success", "Category updated successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to update category");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to update category: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse("$baseUrl/delete-category"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          categories.removeWhere((category) => category.id == id);
          categories.refresh();
          Get.snackbar("Success", "Category deleted successfully");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to delete category");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to delete category: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }
}
