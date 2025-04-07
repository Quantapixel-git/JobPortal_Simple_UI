import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:job/pages/admin/admin_drawer.dart';
import 'package:get/get.dart';

class AdminCarousel extends StatefulWidget {
  const AdminCarousel({super.key});

  @override
  _AdminCarouselState createState() => _AdminCarouselState();
}

class _AdminCarouselState extends State<AdminCarousel> {
  List<dynamic> carouselImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
  }

  Future<void> fetchCarouselImages() async {
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/jobportal_simple/api/getAllCarousel'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        setState(() {
          carouselImages = data['data'];
          isLoading = false;
        });
      }
    }
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    Get.defaultDialog(
      title: "Add Carousel Image",
      content: Text("Are you sure you want to upload this image?"),
      onConfirm: () async {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://quantapixel.in/jobportal_simple/api/addCarouselImage'));

        request.files
            .add(await http.MultipartFile.fromPath('image', pickedFile.path));

        final response = await request.send();
        if (response.statusCode == 201) {
          Get.back(); // Close the dialog
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image Uploaded Successfully!')));
          fetchCarouselImages();
        }
        // Get.back();
      },
      onCancel: () {
        Get.back(); // Close the dialog
      },
    );
  }

  Future<void> deleteImage(int id) async {
    Get.defaultDialog(
      title: "Delete Carousel Image",
      middleText: "Are you sure you want to delete this image?",
      onConfirm: () async {
        final response = await http.post(
          Uri.parse(
              'https://quantapixel.in/jobportal_simple/api/deleteCarouselImage'),
          body: {'id': id.toString()},
        );

        if (response.statusCode == 200) {
          setState(() {
            carouselImages.removeWhere((item) => item['id'] == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image Deleted Successfully!')));
          Get.back(); // Close the dialog
        }
      },
      onCancel: () {
        Get.back(); // Close the dialog
      },
    );
  }

  Future<void> updateStatus(int id, int status) async {
    final response = await http.post(
      Uri.parse(
          'https://quantapixel.in/jobportal_simple/api/updateCarouselStatus'),
      body: {'id': id.toString(), 'status': status.toString()},
    );

    if (response.statusCode == 200) {
      setState(() {
        for (var item in carouselImages) {
          if (item['id'] == id) {
            item['status'] = status;
            break;
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status Updated Successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Carousel")),
      drawer: const AdminDrawer(),
      body: RefreshIndicator(
        onRefresh: fetchCarouselImages,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Pull down to refresh',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: carouselImages.length,
                      itemBuilder: (context, index) {
                        var item = carouselImages[index];
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
                            contentPadding: const EdgeInsets.all(
                                8.0), // Add padding around the ListTile
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item['image'],
                                width: 120, // Increased width
                                height: 120, // Increased height
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              "Carousel ID: ${item['id']}",
                              style: TextStyle(
                                  fontSize:
                                      14), // Increased font size for better visibility
                            ),
                            subtitle: Text(
                              item['status'] == 1
                                  ? "Status: Active"
                                  : "Status: Inactive",
                              style: TextStyle(
                                color: item['status'] == 1
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width:
                                      40, // Reduced size of the toggle button
                                  child: Switch(
                                    value: item['status'] == 1,
                                    onChanged: (value) {
                                      int newStatus = value ? 1 : 2;
                                      updateStatus(item['id'], newStatus);
                                    },
                                  ),
                                ),
                                SizedBox(width: 3),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => deleteImage(item['id']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
        child: ElevatedButton(
          onPressed: uploadImage,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          child: const Text('Add Images', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
