import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryModel> categories = [];
  bool isLoading = true;
  late int districtId;

  @override
  void initState() {
    super.initState();
    print("Initializing CategoryPage...");
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final Map<String, dynamic> args = Get.arguments;
    districtId = args['districtId'];
    print("Fetching categories for district ID: $districtId");

    try {
      final response = await http.post(
        Uri.parse("https://quantapixel.in/jobportal_simple/api/getCategoriesByDistrictId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"district_id": districtId}),
      );

      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response data: $data");

        if (data['status'] == 1) {
          categories = List<CategoryModel>.from(
            data['data'].map((item) => CategoryModel.fromJson(item)),
          );
          print("Categories fetched successfully: ${categories.length}");
        } else {
          Get.snackbar("Error", "Failed to fetch categories: ${data['message']}");
          print("Error fetching categories: ${data['message']}");
        }
      } else {
        // Get.snackbar("Error", "Failed to fetch categories: ${response.statusCode}");
        print("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      print("Exception occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
      print("Loading state set to false.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final int stateId = args['stateId'];
    print("Building CategoryPage with state ID: $stateId");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: Colors.yellow,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Get.offAllNamed('/home');
              },
              child: const Icon(Icons.home),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
              ? const Center(child: Text('No categories available'))
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          print("Tapped on category: ${category.categoryName}");
                          Get.toNamed('/joblist', arguments: {
                            'categoryId': category.id,
                            'stateId': stateId,
                            'districtId': districtId,
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                category.image, // Fetch image from API
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                category.categoryName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${category.filterJobCount}+ jobs",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class CategoryModel {
  int id;
  String categoryName;
  String image;
  int filterJobCount;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.image,
    required this.filterJobCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      categoryName: json['category_name'],
      image: json['category_image'],
      filterJobCount: json['filtered_job_count'],
    );
  }
}