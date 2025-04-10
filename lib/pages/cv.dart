import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:job/controllers/cv_controller.dart';
import 'package:job/models/cv_model.dart';

class Cv extends StatefulWidget {
  const Cv({super.key});

  @override
  State<Cv> createState() => _CvState();
}

class _CvState extends State<Cv> {
  final _formKey = GlobalKey<FormState>();
  String? _uploadedFileName;
  File? _uploadedFile;
  final ResumeController _resumeController = Get.put(ResumeController());

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
        _uploadedFile = File(result.files.single.path!);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Create a ResumeModel instance with the filled data
      ResumeModel resume = ResumeModel(
        id: 0, // or some default value
        name: _nameController.text.trim(),
        dob: _dobController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _phoneController.text.trim(),
        qualification: _qualificationController.text.trim(),
        experience: _experienceController.text.trim(),
        skills: _skillsController.text.trim(),
        address: _addressController.text.trim(),
        linkedin: _linkedinController.text.trim(),
        resume: _uploadedFile != null ? _uploadedFile!.path : '',
        status: 1, // or some default value
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Submit the resume
      _resumeController.addResume(resume, _uploadedFile);
    } else {
      // If the form is not valid, show a message or handle it accordingly
      Get.snackbar("Error", "Please fill in all required fields.");
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    _addressController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/nobglogo.png', // Adjust path if needed
            //   height: 100,
            // ),
            Text(
              'Your CV',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file,
                        color: Colors.black, size: 32),
                    label: Text('uploadcv'.tr,
                        style: const TextStyle(fontSize: 23)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 75),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Always show personal details fields
                _buildTextField("fullname".tr, Icons.person, _nameController),
                _buildDobField(),
                _buildTextField("email".tr, Icons.email, _emailController),
                _buildTextField("phone".tr, Icons.phone, _phoneController),
                _buildTextField(
                    "qualification".tr, Icons.school, _qualificationController),
                _buildTextField(
                    "experience".tr, Icons.work, _experienceController),
                _buildTextField("skills".tr, Icons.star, _skillsController),
                _buildTextField("address".tr, Icons.home, _addressController),
                _buildTextField("linkedin".tr, Icons.link, _linkedinController),

                const SizedBox(height: 10),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          // Custom validation for LinkedIn URL
          if (label.toLowerCase() == "linkedin") {
            final urlPattern = r'^(https?:\/\/)?(www\.)?(linkedin\.com\/.*)$';
            final result = RegExp(urlPattern).hasMatch(value);
            if (!result) {
              return 'Please enter a valid LinkedIn URL';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDobField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "DOB",
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select DOB';
          }
          return null;
        },
      ),
    );
  }
}
