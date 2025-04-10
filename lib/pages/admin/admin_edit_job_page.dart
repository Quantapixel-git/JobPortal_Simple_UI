import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:job/controllers/job_controller.dart';
import 'package:job/models/job_model.dart';
import 'package:job/pages/admin/admin_jobs.dart';

class EditJob extends StatefulWidget {
  final JobModel job;

  EditJob({required this.job});

  @override
  _EditJobState createState() => _EditJobState();
}

class _EditJobState extends State<EditJob> {
  final JobController jobController = Get.find();

  // Controllers for text fields
  late TextEditingController jobTitleController;
  late TextEditingController companyNameController;
  late TextEditingController companyLocationController;
  late TextEditingController salaryController;
  late TextEditingController qualificationController;
  late TextEditingController experienceController;
  late TextEditingController genderController;
  late TextEditingController maritalStatusController;
  late TextEditingController contactNumberController;
  late TextEditingController emailController;
  late TextEditingController skillsController;
  late TextEditingController jobLocationsController;
  late TextEditingController jobDescriptionController;
  late TextEditingController expiryAtController;

  File? selectedCompanyLogo;
  File? selectedRequiredImage;
  File? selectedAdditionalImage1;
  File? selectedAdditionalImage2;

  bool isFeatured = false;

  @override
  void initState() {
    super.initState();

    // Initialize TextEditingControllers with existing job data
    jobTitleController = TextEditingController(text: widget.job.jobTitle);
    companyNameController = TextEditingController(text: widget.job.companyName);
    companyLocationController =
        TextEditingController(text: widget.job.companyLocation);
    salaryController = TextEditingController(text: widget.job.salary);
    qualificationController =
        TextEditingController(text: widget.job.qualification);
    experienceController = TextEditingController(text: widget.job.experience);
    genderController = TextEditingController(text: widget.job.gender);
    maritalStatusController =
        TextEditingController(text: widget.job.maritalStatus);
    contactNumberController =
        TextEditingController(text: widget.job.contactNumber);
    emailController = TextEditingController(text: widget.job.email);
    skillsController = TextEditingController(text: widget.job.skills);
    jobLocationsController =
        TextEditingController(text: widget.job.jobLocations);
    jobDescriptionController =
        TextEditingController(text: widget.job.jobDescription);
    expiryAtController = TextEditingController(text: widget.job.expiryAt);

    // Set the selected state, district, and category IDs
    jobController.selectedStateId.value = widget.job.stateId;
    jobController.selectedDistrictId.value = widget.job.districtId;
    jobController.selectedCategoryId.value = widget.job.categoryId;

    // Initialize the isFeatured variable based on the job data
    isFeatured = widget.job.isFeatured == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Job")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Dropdown for states
              Obx(() {
                return Container(
                  width: double.infinity,
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: jobController.selectedStateId.value,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        jobController.selectedStateId.value = newValue;
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
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: jobController.selectedDistrictId.value,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        jobController.selectedDistrictId.value = newValue;
                      }
                    },
                    items: jobController.districts
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
                    value: jobController.selectedCategoryId.value,
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
                readOnly: true,
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
              SizedBox(height: 10),

              // Is Featured Checkbox
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
                    },
                  ),
                ],
              ),

              // Company Logo Image Picker
              GestureDetector(
                onTap: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedCompanyLogo = image;
                    });
                  }
                },
                child: selectedCompanyLogo != null
                    ? Image.file(selectedCompanyLogo!, width: 100, height: 100)
                    : widget.job.companyLogo != null
                        ? Image.network(widget.job.companyLogo!,
                            width: 100, height: 100)
                        : Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: Center(
                                child: Text("Tap to select Company Logo")),
                          ),
              ),
              Text("Company Logo"),

              // Required Image Picker
              GestureDetector(
                onTap: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedRequiredImage = image;
                    });
                  }
                },
                child: selectedRequiredImage != null
                    ? Image.file(selectedRequiredImage!,
                        width: 100, height: 100)
                    : widget.job.image != null
                        ? Image.network(widget.job.image!,
                            width: 100, height: 100)
                        : Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: Center(
                                child: Text("Tap to select Required Image")),
                          ),
              ),
              Text("Required Image"),

              // Additional Image 1 Image Picker
              GestureDetector(
                onTap: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedAdditionalImage1 = image;
                    });
                  }
                },
                child: selectedAdditionalImage1 != null
                    ? Image.file(selectedAdditionalImage1!,
                        width: 100, height: 100)
                    : widget.job.additionalImage1 != null
                        ? Image.network(widget.job.additionalImage1!,
                            width: 100, height: 100)
                        : Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: Center(
                                child:
                                    Text("Tap to select Additional Image 1")),
                          ),
              ),
              Text("Additional Image 1"),

              // Additional Image 2 Image Picker
              GestureDetector(
                onTap: () async {
                  File? image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      selectedAdditionalImage2 = image;
                    });
                  }
                },
                child: selectedAdditionalImage2 != null
                    ? Image.file(selectedAdditionalImage2!,
                        width: 100, height: 100)
                    : widget.job.additionalImage2 != null
                        ? Image.network(widget.job.additionalImage2!,
                            width: 100, height: 100)
                        : Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: Center(
                                child:
                                    Text("Tap to select Additional Image 2")),
                          ),
              ),
              Text("Additional Image 2"),

              ElevatedButton(
                onPressed: () async {
                  try {
                    // Call the updateJob method and wait for it to complete
                    await jobController.updateJob(
                      widget.job.id,
                      JobModel(
                        id: widget.job.id,
                        stateId: jobController.selectedStateId.value,
                        districtId: jobController.selectedDistrictId.value,
                        categoryId: jobController.selectedCategoryId.value,
                        jobTitle: jobTitleController.text.isNotEmpty
                            ? jobTitleController.text
                            : widget.job.jobTitle,
                        companyLogo:
                            selectedCompanyLogo?.path ?? widget.job.companyLogo,
                        companyName: companyNameController.text.isNotEmpty
                            ? companyNameController.text
                            : widget.job.companyName,
                        companyLocation:
                            companyLocationController.text.isNotEmpty
                                ? companyLocationController.text
                                : widget.job.companyLocation,
                        salary: salaryController.text.isNotEmpty
                            ? salaryController.text
                            : widget.job.salary,
                        qualification: qualificationController.text.isNotEmpty
                            ? qualificationController.text
                            : widget.job.qualification,
                        experience: experienceController.text.isNotEmpty
                            ? experienceController.text
                            : widget.job.experience,
                        gender: genderController.text.isNotEmpty
                            ? genderController.text
                            : widget.job.gender,
                        maritalStatus: maritalStatusController.text.isNotEmpty
                            ? maritalStatusController.text
                            : widget.job.maritalStatus,
                        contactNumber: contactNumberController.text.isNotEmpty
                            ? contactNumberController.text
                            : widget.job.contactNumber,
                        email: emailController.text.isNotEmpty
                            ? emailController.text
                            : widget.job.email,
                        skills: skillsController.text.isNotEmpty
                            ? skillsController.text
                            : widget.job.skills,
                        image: selectedRequiredImage?.path ?? widget.job.image,
                        additionalImage1: selectedAdditionalImage1?.path ??
                            widget.job.additionalImage1,
                        additionalImage2: selectedAdditionalImage2?.path ??
                            widget.job.additionalImage2,
                        jobLocations: jobLocationsController.text.isNotEmpty
                            ? jobLocationsController.text
                            : widget.job.jobLocations,
                        jobDescription: jobDescriptionController.text.isNotEmpty
                            ? jobDescriptionController.text
                            : widget.job.jobDescription,
                        expiryAt: expiryAtController.text.isNotEmpty
                            ? expiryAtController.text
                            : widget.job.expiryAt,
                        isFeatured: isFeatured ? 1 : 2,
                        status: 1,
                        createdAt: widget.job.createdAt,
                        updatedAt: DateTime.now().toString(),
                        stateName: widget.job.stateName,
                        districtName: widget.job.districtName,
                        categoryName: widget.job.categoryName,
                        stateImage: widget.job.stateImage,
                        districtImage: widget.job.districtImage,
                        categoryImage: widget.job.categoryImage,
                      ),
                      selectedCompanyLogo,
                      selectedRequiredImage,
                    );

                    // Refresh the job list after updating
                    await jobController.fetchJobs();
                    print("Job updated successfully, now navigating back.");
                    Get.off(() => AdminJobs()); // Navigate back to AdminJobs
                  } catch (e) {
                    // Handle the error and show a user-friendly message
                    Get.snackbar("Error", "Failed to update job: $e");
                  }
                },
                child: Text("Update Job"),
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
