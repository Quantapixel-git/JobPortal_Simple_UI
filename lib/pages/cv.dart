import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class Cv extends StatefulWidget {
  const Cv({super.key});

  @override
  State<Cv> createState() => _CvState();
}

class _CvState extends State<Cv> {
  final _formKey = GlobalKey<FormState>();
  String? _uploadedFileName;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PostyourCV'.tr), // Instead of 'Post Your CV'
        backgroundColor: Colors.red,
          actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                Get.locale == const Locale('en') ? 'EN' : 'TE',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              if (Get.locale == const Locale('en')) {
                Get.updateLocale(const Locale('te'));
              } else {
                Get.updateLocale(const Locale('en'));
              }
            },
          ),
        ], // Themed color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file,
                        color: Colors.white, size: 32),
                    label: Text('uploadcv'.tr,
                        style: const TextStyle(fontSize: 23)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 75),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                          color: Colors.grey, thickness: 1, endIndent: 10),
                    ),
                    Text("or".tr,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    Expanded(
                      child:
                          Divider(color: Colors.grey, thickness: 1, indent: 10),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
                  "personaldetails".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),

                _buildTextField("fullname".tr, Icons.person),
                _buildTextField("dob".tr, Icons.calendar_today),
                _buildTextField("email".tr, Icons.email),
                _buildTextField("phone".tr, Icons.phone),
                _buildTextField("qualification".tr, Icons.school),
                _buildTextField("experience".tr, Icons.work),
                _buildTextField("skills".tr, Icons.star),
                _buildTextField("address".tr, Icons.home),
                _buildTextField("linkedin".tr, Icons.link),

                const SizedBox(height: 10),

                // Upload CV Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('cvsubmitted'.tr)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                    ),
                    child: Text('submitcv'.tr,
                        style: const TextStyle(fontSize: 20)),
                  ),
                ),

                if (_uploadedFileName != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Uploaded: $_uploadedFileName",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                const SizedBox(height: 20),

                // Submit Button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.red),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
