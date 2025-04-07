import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:job/controllers/state_controller.dart';
import 'package:job/pages/admin/admin_drawer.dart';

class AdminStates extends StatelessWidget {
  final StateController stateController = Get.put(StateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("States")),
      drawer: const AdminDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await stateController.fetchStates();
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
                if (stateController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: stateController.states.length,
                  itemBuilder: (context, index) {
                    final state = stateController.states[index];
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
                          state.state,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        leading: state.image.isNotEmpty
                            ? ClipRRect(
                                // borderRadius: BorderRadius.circular(8),
                                child: Image.network(state.image,
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
                              onPressed: () => _editStateDialog(context, state),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red, size: 28),
                              onPressed: () =>
                                  _confirmDelete(context, state.id),
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
          onPressed: () => _addStateDialog(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                vertical: 15.0), // Increased button height
          ),
          child: const Text('Add State', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Future<File?> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  void _addStateDialog(BuildContext context) {
    TextEditingController stateNameController = TextEditingController();
    File? selectedImage;

    Get.defaultDialog(
        title: "Add State",
        content: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: stateNameController,
                  decoration: InputDecoration(labelText: "State Name")),
              SizedBox(height: 10),
              selectedImage != null
                  ? Image.file(selectedImage!, width: 100, height: 100)
                  : Container(
                      height: 100,
                      color: Colors.grey[300],
                      child: Center(child: Text("No Image Selected"))),
              ElevatedButton(
                onPressed: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedImage = image;
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
          Get.back();
          if (stateNameController.text.isNotEmpty && selectedImage != null) {
            stateController.addState(stateNameController.text, selectedImage!);
          }
        },
        onCancel: () {
          Get.back();
        });
  }

  void _editStateDialog(BuildContext context, state) {
    TextEditingController stateNameController =
        TextEditingController(text: state.state);
    File? selectedImage;
    String? currentImage = state.image;

    Get.defaultDialog(
        title: "Edit State",
        content: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: stateNameController,
                  decoration: InputDecoration(labelText: "State Name")),
              SizedBox(height: 10),
              selectedImage != null
                  ? Image.file(selectedImage!, width: 100, height: 100)
                  : currentImage != null && currentImage.isNotEmpty
                      ? Image.network(currentImage, width: 100, height: 100)
                      : Container(
                          height: 100,
                          color: Colors.grey[300],
                          child: Center(child: Text("No Image"))),
              ElevatedButton(
                onPressed: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedImage = image;
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
          Get.back();
          if (stateNameController.text.isNotEmpty) {
            stateController.updateState(
              state.id,
              stateNameController.text,
              selectedImage,
            );
          }
        },
        onCancel: () {
          Get.back();
        });
  }

  void _confirmDelete(BuildContext context, int stateId) {
    Get.defaultDialog(
        title: "Delete State",
        middleText: "Are you sure you want to delete this state?",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        onConfirm: () {
          stateController.deleteState(stateId);
          Get.back();
        },
        onCancel: () {
          Get.back();
        });
  }
}
