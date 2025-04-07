import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job/models/district_model.dart';
import 'package:job/models/state_model.dart'; // Import your StateModel
import 'package:job/pages/admin/admin_drawer.dart';

class AdminDistricts extends StatelessWidget {
  final String baseUrl = "https://quantapixel.in/jobportal_simple/api";
  final List<DistrictModel> districts = [];
  final List<StateModel> states = [];
  var isLoading = false.obs;
  int selectedStateId = 0;

  AdminDistricts({Key? key}) : super(key: key) {
    // Fetch districts and states when the widget is created
    _fetchDistricts();
    _fetchStates();
  }

  Future<void> _fetchDistricts() async {
    isLoading(true); // Set loading state to true
    try {
      final response = await http.get(Uri.parse("$baseUrl/allDistrict"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          districts.clear(); // Clear previous districts
          districts.addAll(
            List<DistrictModel>.from(
              data['data'].map((item) => DistrictModel.fromJson(item)),
            ),
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
      isLoading(false); // Set loading state to false
    }
  }

  Future<void> _fetchStates() async {
    isLoading(true); // Set loading state to true
    try {
      final response = await http.get(Uri.parse("$baseUrl/allState"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          states.clear(); // Clear previous states
          states.addAll(
            List<StateModel>.from(
              data['data'].map((item) => StateModel.fromJson(item)),
            ),
          );
          if (states.isNotEmpty) {
            selectedStateId = states.first.id; // Default to first state
          }
        } else {
          Get.snackbar("Error", "Failed to fetch states: ${data['message']}");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch states: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false); // Set loading state to false
    }
  }

  Future<void> _addDistrict(String districtName, File? image) async {
    isLoading(true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/addDistrict"),
      );
      request.fields['state_id'] = selectedStateId.toString();
      request.fields['district'] = districtName;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
        ));
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      final data = json.decode(responseData.body);
      if (data['status'] == 1) {
        Get.snackbar("Success", "District added successfully");
        await _fetchDistricts(); // Refresh the district list
      } else {
        Get.snackbar("Error", "Failed to add district: ${data['message']}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> _updateDistrict(
      int districtId, String districtName, File? image) async {
    isLoading(true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/updateDistrict"),
      );
      request.fields['id'] = districtId.toString();
      request.fields['state_id'] = selectedStateId.toString();
      request.fields['district'] = districtName;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
        ));
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      final data = json.decode(responseData.body);
      if (data['status'] == 1) {
        Get.snackbar("Success", "District updated successfully");
        await _fetchDistricts(); // Refresh the district list
      } else {
        Get.snackbar("Error", "Failed to update district: ${data['message']}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Districts")),
      drawer: const AdminDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchDistricts();
          await _fetchStates();
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
                if (isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: districts.length,
                  itemBuilder: (context, index) {
                    final district = districts[index];
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
                          district.district,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "State: ${district.stateName}",
                          style: TextStyle(fontSize: 14),
                        ),
                        leading: district.image.isNotEmpty
                            ? ClipRRect(
                                child: Image.network(district.image,
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
                                  _editDistrictDialog(context, district),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red, size: 28),
                              onPressed: () =>
                                  _confirmDelete(context, district.id),
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
          onPressed: () => _addDistrictDialog(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                vertical: 15.0), // Increased button height
          ),
          child: const Text('Add District', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Future<File?> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  void _addDistrictDialog(BuildContext context) {
    TextEditingController districtNameController = TextEditingController();
    File? selectedImage;

    Get.defaultDialog(
      title: "Add District",
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: districtNameController,
              decoration: InputDecoration(labelText: "District Name"),
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: selectedStateId, // Use the selected state ID
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedStateId = newValue; // Update selected state ID
                  });
                }
              },
              items: states.map<DropdownMenuItem<int>>((state) {
                return DropdownMenuItem<int>(
                  value: state.id,
                  child: Text(state.state), // Use state.state for display
                );
              }).toList(),
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
        if (districtNameController.text.isNotEmpty && selectedImage != null) {
          _addDistrict(districtNameController.text, selectedImage);
          Get.back();
        } else {
          Get.snackbar("Error", "Please fill all fields");
        }
      },
    );
  }

  void _editDistrictDialog(BuildContext context, DistrictModel district) {
    TextEditingController districtNameController =
        TextEditingController(text: district.district);
    File? selectedImage;

    Get.defaultDialog(
      title: "Edit District",
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: districtNameController,
              decoration: InputDecoration(labelText: "District Name"),
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: district.stateId, // Use the current district's stateId
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedStateId = newValue; // Update selected state ID
                  });
                }
              },
              items: states.map<DropdownMenuItem<int>>((state) {
                return DropdownMenuItem<int>(
                  value: state.id,
                  child: Text(state.state), // Use state.state for display
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            selectedImage != null
                ? Image.file(selectedImage!, width: 100, height: 100)
                : district.image.isNotEmpty
                    ? Image.network(district.image, width: 100, height: 100)
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
        if (districtNameController.text.isNotEmpty) {
          _updateDistrict(
              district.id, districtNameController.text, selectedImage);
          Get.back();
        } else {
          Get.snackbar("Error", "Please fill all fields");
        }
      },
    );
  }

  Future<void> _deleteDistrict(int districtId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/deleteDistrict"),
        body: {"id": districtId.toString()},
      );
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        // Remove the district from the local list
        districts.removeWhere((district) => district.id == districtId);
        Get.snackbar("Success", "District deleted successfully");
        // Refresh the district list to ensure UI is updated
        await _fetchDistricts();
      } else {
        Get.snackbar("Error", "Failed to delete district: ${data['message']}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  void _confirmDelete(BuildContext context, int districtId) {
    Get.defaultDialog(
      title: "Delete District",
      middleText: "Are you sure you want to delete this district?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        _deleteDistrict(districtId);
        Get.back();
      },
    );
  }
}
