import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:job/controllers/job_controller.dart';
import 'package:job/models/job_model.dart';
import 'package:job/pages/admin/admin_jobs.dart';

class AddJob extends StatefulWidget {
  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final JobController jobController = Get.find();

  bool isFeatured = false;

  // Create TextEditingControllers for all fields
  final TextEditingController jobTitleController = TextEditingController();

  final TextEditingController companyNameController = TextEditingController();

  final TextEditingController companyLocationController =
      TextEditingController();

  final TextEditingController salaryController = TextEditingController();

  final TextEditingController qualificationController = TextEditingController();

  final TextEditingController experienceController = TextEditingController();

  final TextEditingController genderController = TextEditingController();

  final TextEditingController maritalStatusController = TextEditingController();

  final TextEditingController contactNumberController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController skillsController = TextEditingController();

  final TextEditingController jobLocationsController = TextEditingController();

  final TextEditingController jobDescriptionController =
      TextEditingController();

  final TextEditingController expiryAtController = TextEditingController();

  final TextEditingController isFeaturedController = TextEditingController();

  File? selectedCompanyLogo;

  File? selectedAdditionalImage1;

  File? selectedAdditionalImage2;

  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Job")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Obx(() {
                return Container(
                  width: double.infinity,
                  // padding:
                  // const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    hint: Text("Choose State"), // Hint text
                    value: jobController.selectedStateId.value != 0
                        ? jobController.selectedStateId.value
                        : null, // Set to null if no valid state is selected
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        jobController.selectedStateId.value = newValue;
                        jobController.selectedDistrictId.value =
                            0; // Reset district selection
                      }
                    },
                    items: jobController.states
                        .map<DropdownMenuItem<int>>((state) {
                      return DropdownMenuItem<int>(
                        value: state.id,
                        child: Text(state.state),
                      );
                    }).toList(),
                  ),
                );
              }),

// Dropdown for districts
              Obx(() {
                return Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric( vertical: 6),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    hint: Text("Choose District"), // Hint text
                    value: jobController.selectedDistrictId.value != 0
                        ? jobController.selectedDistrictId.value
                        : null, // Set to null if no valid district is selected
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        jobController.selectedDistrictId.value = newValue;
                      }
                    },
                    items: jobController.districts
                        .where((district) =>
                            district.stateId ==
                            jobController.selectedStateId.value)
                        .map<DropdownMenuItem<int>>((district) {
                      return DropdownMenuItem<int>(
                        value: district.id,
                        child: Text(district.district),
                      );
                    }).toList(),
                  ),
                );
              }),

// Dropdown for categories
              Obx(() {
                return Container(
                  width: double.infinity,
                  child: DropdownButton<int>(
                    isExpanded: true,
                    hint: Text("Choose Category"), // Hint text
                    value: jobController.selectedCategoryId.value != 0
                        ? jobController.selectedCategoryId.value
                        : null, // Set to null if no valid category is selected
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        jobController.selectedCategoryId.value = newValue;
                      }
                    },
                    items: jobController.categories
                        .map<DropdownMenuItem<int>>((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.category),
                      );
                    }).toList(),
                  ),
                );
              }),
              // Job Title
              TextField(
                controller: jobTitleController,
                decoration: InputDecoration(labelText: "Job Title"),
              ),
              // Company Name
              TextField(
                controller: companyNameController,
                decoration: InputDecoration(labelText: "Company Name"),
              ),
              // Company Location
              TextField(
                controller: companyLocationController,
                decoration: InputDecoration(labelText: "Company Location"),
              ),
              // Salary
              TextField(
                controller: salaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Monthly Salary"),
              ),
              // Qualification
              TextField(
                controller: qualificationController,
                decoration: InputDecoration(labelText: "Qualification"),
              ),
              // Experience
              TextField(
                controller: experienceController,
                // keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Experience"),
              ),
              // Gender
              TextField(
                controller: genderController,
                decoration: InputDecoration(labelText: "Gender"),
              ),
              // Marital Status
              TextField(
                controller: maritalStatusController,
                decoration: InputDecoration(labelText: "Marital Status"),
              ),
              // Contact Number
              TextField(
                controller: contactNumberController,
                keyboardType: TextInputType.phone, 
                decoration: InputDecoration(labelText: "Contact Number"),
              ),
              // Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
              ),
              // Skills
              TextField(
                controller: skillsController,
                decoration: InputDecoration(labelText: "Skills"),
              ),
              // Job Locations
              TextField(
                controller: jobLocationsController,
                decoration: InputDecoration(labelText: "Job Locations"),
              ),
              // Job Description
              TextField(
                controller: jobDescriptionController,
                decoration: InputDecoration(labelText: "Job Description"),
              ),
              // Expiry Date
              TextField(
                controller: expiryAtController,
                decoration: InputDecoration(labelText: "Expiry Date"),
                readOnly: true, // Prevent manual input
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    expiryAtController.text = "${pickedDate.toLocal()}"
                        .split(' ')[0]; // Format the date
                  }
                },
              ),
              // Is Featured
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Is Featured"),
                  Checkbox(
                    value: isFeatured,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isFeatured = newValue ?? false;
                      });
                      print("Checkbox Changed: ${isFeatured ? 1 : 2}");
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Company Logo Image Picker
              GestureDetector(
                onTap: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedCompanyLogo =
                          image; // Update the state to reflect the selected image
                    });
                  }
                },
                child: selectedCompanyLogo != null
                    ? Image.file(selectedCompanyLogo!, width: 100, height: 100)
                    : Container(
                        height: 100,
                        color: Colors.grey[300],
                        child:
                            Center(child: Text("Tap to select Company Logo")),
                      ),
              ),
              Text("Company Logo"),

              GestureDetector(
                onTap: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedImage =
                          image; // Update the state to reflect the selected image
                    });
                  }
                },
                child: selectedImage != null
                    ? Image.file(selectedImage!, width: 100, height: 100)
                    : Container(
                        height: 100,
                        color: Colors.grey[300],
                        child:
                            Center(child: Text("Tap to select Required Image")),
                      ),
              ),
              Text("Required Image"),
              // Additional Image 1 Image Picker
              GestureDetector(
                onTap: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedAdditionalImage1 =
                          image; // Update the state to reflect the selected image
                    });
                  }
                },
                child: selectedAdditionalImage1 != null
                    ? Image.file(selectedAdditionalImage1!,
                        width: 100, height: 100)
                    : Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: Center(
                            child: Text("Tap to select Additional Image 1")),
                      ),
              ),
              Text("Additional Image 1"),

              // Additional Image 2 Image Picker
              GestureDetector(
                onTap: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedAdditionalImage2 =
                          image; // Update the state to reflect the selected image
                    });
                  }
                },
                child: selectedAdditionalImage2 != null
                    ? Image.file(selectedAdditionalImage2!,
                        width: 100, height: 100)
                    : Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: Center(
                            child: Text("Tap to select Additional Image 2")),
                      ),
              ),
              Text("Additional Image 2"),
//               Obx(() {
//                 return DropdownButton<int>(
//                   hint: Text("Choose State"), // Hint text
//                   value: jobController.selectedStateId.value != 0
//                       ? jobController.selectedStateId.value
//                       : null, // Set to null if no valid state is selected
//                   onChanged: (int? newValue) {
//                     if (newValue != null) {
//                       jobController.selectedStateId.value = newValue;
//                       jobController.selectedDistrictId.value =
//                           0; // Reset district selection
//                     }
//                   },
//                   items:
//                       jobController.states.map<DropdownMenuItem<int>>((state) {
//                     return DropdownMenuItem<int>(
//                       value: state.id,
//                       child: Text(state.state),
//                     );
//                   }).toList(),
//                 );
//               }),

// // Dropdown for districts
//               Obx(() {
//                 return DropdownButton<int>(
//                   hint: Text("Choose District"), // Hint text
//                   value: jobController.selectedDistrictId.value != 0
//                       ? jobController.selectedDistrictId.value
//                       : null, // Set to null if no valid district is selected
//                   onChanged: (int? newValue) {
//                     if (newValue != null) {
//                       jobController.selectedDistrictId.value = newValue;
//                     }
//                   },
//                   items: jobController.districts
//                       .where((district) =>
//                           district.stateId ==
//                           jobController.selectedStateId.value)
//                       .map<DropdownMenuItem<int>>((district) {
//                     return DropdownMenuItem<int>(
//                       value: district.id,
//                       child: Text(district.district),
//                     );
//                   }).toList(),
//                 );
//               }),

// // Dropdown for categories
//               Obx(() {
//                 return DropdownButton<int>(
//                   hint: Text("Choose Category"), // Hint text
//                   value: jobController.selectedCategoryId.value != 0
//                       ? jobController.selectedCategoryId.value
//                       : null, // Set to null if no valid category is selected
//                   onChanged: (int? newValue) {
//                     if (newValue != null) {
//                       jobController.selectedCategoryId.value = newValue;
//                     }
//                   },
//                   items: jobController.categories
//                       .map<DropdownMenuItem<int>>((category) {
//                     return DropdownMenuItem<int>(
//                       value: category.id,
//                       child: Text(category.category),
//                     );
//                   }).toList(),
//                 );
//               }),
              ElevatedButton(
                onPressed: () async {
                  if (jobTitleController.text.isNotEmpty &&
                      selectedCompanyLogo != null &&
                      selectedImage != null && // Check for the required image
                      companyNameController.text.isNotEmpty &&
                      companyLocationController.text.isNotEmpty &&
                      salaryController.text.isNotEmpty &&
                      qualificationController.text.isNotEmpty &&
                      experienceController.text.isNotEmpty &&
                      genderController.text.isNotEmpty &&
                      maritalStatusController.text.isNotEmpty &&
                      contactNumberController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      skillsController.text.isNotEmpty &&
                      jobLocationsController.text.isNotEmpty &&
                      jobDescriptionController.text.isNotEmpty &&
                      expiryAtController.text.isNotEmpty) {
                    JobModel newJob = JobModel(
                      id: 0,
                      stateId: jobController.selectedStateId.value,
                      districtId: jobController.selectedDistrictId.value,
                      categoryId: jobController.selectedCategoryId.value,
                      jobTitle: jobTitleController.text,
                      companyLogo: selectedCompanyLogo?.path,
                      companyName: companyNameController.text,
                      companyLocation: companyLocationController.text,
                      salary: salaryController.text,
                      qualification: qualificationController.text,
                      experience: experienceController.text,
                      gender: genderController.text,
                      maritalStatus: maritalStatusController.text,
                      contactNumber: contactNumberController.text,
                      email: emailController.text,
                      skills: skillsController.text,
                      image: selectedImage?.path,
                      additionalImage1: selectedAdditionalImage1?.path,
                      additionalImage2: selectedAdditionalImage2?.path,
                      jobLocations: jobLocationsController.text,
                      jobDescription: jobDescriptionController.text,
                      expiryAt: expiryAtController.text,
                      isFeatured: isFeatured ? 1 : 2,
                      status: 1,
                      createdAt: DateTime.now().toString(),
                      updatedAt: DateTime.now().toString(),
                      stateName: '',
                      districtName: '',
                      categoryName: '',
                      stateImage: '',
                      districtImage: '',
                      categoryImage: '',
                    );

                    try {
                      // Call the addJob method and wait for it to complete
                      await jobController.addJob(
                          newJob, selectedCompanyLogo, selectedImage);

                      // Refresh the job list after adding
                      await jobController.fetchJobs();

                      print("Job added successfully, now navigating back.");
                      Get.off(() => AdminJobs()); // Navigate back to AdminJobs
                    } catch (e) {
                      // Handle the error and show a user-friendly message
                      Get.snackbar("Error", "Failed to add job: $e");
                    }
                  } else {
                    Get.snackbar("Error",
                        "Please fill in all required fields and select an image.");
                  }
                },
                child: Text("Add Job"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
