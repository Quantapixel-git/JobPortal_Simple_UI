import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:job/controllers/category_controller.dart'; // Import your CategoryController
import 'package:job/pages/admin/admin_drawer.dart';

class AdminCategories extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Categories")),
      drawer: const AdminDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await categoryController.fetchCategories();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pull down to refresh",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0), // Adds spacing around items
                      padding: const EdgeInsets.only(
                          left: 10.0), // Adds internal spacing
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Increases height
                        title: Text(
                          category.category,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        leading: category.image.isNotEmpty
                            ? ClipRRect(
                                child: Image.network(category.image,
                                    width: 80, height: 90, fit: BoxFit.cover),
                              )
                            : Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: Colors.blue, size: 28),
                              onPressed: () =>
                                  _editCategoryDialog(context, category),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red, size: 28),
                              onPressed: () =>
                                  _confirmDelete(context, category.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 8.0), // Increased vertical padding
        child: ElevatedButton(
          onPressed: () => _addCategoryDialog(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                vertical: 15.0), // Increased button height
          ),
          child: const Text('Add Category', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Future<File?> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  void _addCategoryDialog(BuildContext context) {
    TextEditingController categoryNameController = TextEditingController();
    File? selectedImage;

    Get.defaultDialog(
      title: "Add Category",
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryNameController,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
            SizedBox(height: 10),
            selectedImage != null
                ? Image.file(selectedImage!, width: 100, height: 100)
                : Container(
                    height: 100,
                    color: Colors.grey[300],
                    child: Center(child: Text("No Image Selected")),
                  ),
            ElevatedButton(
              onPressed: () async {
                File? image = await _pickImage();
                if (image != null) {
                  setState(() {
                    selectedImage = image; // Update selectedImage
                  });
                }
              },
              child: Text("Pick Image"),
            ),
          ],
        );
      }),
      textConfirm: "Add",
      textCancel: "Cancel",
      onConfirm: () {
        if (categoryNameController.text.isNotEmpty && selectedImage != null) {
          categoryController.addCategory(
              categoryNameController.text, selectedImage!);
          Get.back();
        }
      },
    );
  }

  void _editCategoryDialog(BuildContext context, category) {
    TextEditingController categoryNameController = TextEditingController(
        text: category.category); // Use 'category' instead of 'categorie'
    File? selectedImage;
    String? currentImage = category.image;

    Get.defaultDialog(
      title: "Edit Category",
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryNameController,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
            SizedBox(height: 10),
            selectedImage != null
                ? Image.file(selectedImage!, width: 100, height: 100)
                : currentImage != null && currentImage.isNotEmpty
                    ? Image.network(currentImage, width: 100, height: 100)
                    : Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: Center(child: Text("No Image")),
                      ),
            ElevatedButton(
              onPressed: () async {
                File? image = await _pickImage();
                if (image != null) {
                  setState(() {
                    selectedImage = image; // Update selectedImage
                  });
                }
              },
              child: Text("Pick Image"),
            ),
          ],
        );
      }),
      textConfirm: "Update",
      textCancel: "Cancel",
      onConfirm: () {
        if (categoryNameController.text.isNotEmpty) {
          categoryController.updateCategory(
            category.id,
            categoryNameController.text,
            selectedImage,
          );
          Get.back();
        }
      },
    );
  }

  void _confirmDelete(BuildContext context, int categoryId) {
    Get.defaultDialog(
      title: "Delete Category",
      middleText: "Are you sure you want to delete this category?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        categoryController.deleteCategory(categoryId);
        Get.back();
      },
    );
  }
}