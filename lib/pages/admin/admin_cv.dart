import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job/controllers/cv_controller.dart';
// import 'package:job/models/cv_model.dart';
import 'package:job/pages/admin/admin_cvdetailpage.dart';
// import 'dart:io';
import 'package:job/pages/admin/admin_drawer.dart';
// import 'package:job/pages/cv_detail_page.dart'; // Import the CV detail page

class AdminResumes extends StatelessWidget {
  final ResumeController resumeController = Get.put(ResumeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Resumes")),
      drawer: const AdminDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await resumeController.fetchResumes();
        },
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Pull down to refresh",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(() {
                if (resumeController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: resumeController.resumes.length,
                  itemBuilder: (context, index) {
                    final resume = resumeController.resumes[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
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
                        title: Text(resume.name),
                        subtitle: Text(resume.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility, color: Colors.green),
                              onPressed: () {
                                Get.to(() => CvDetailPage(
                                    resume:
                                        resume)); // Navigate to CV detail page
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _confirmDelete(context, resume.id),
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
    );
  }

  void _confirmDelete(BuildContext context, int resumeId) {
    Get.defaultDialog(
      title: "Delete Resume",
      middleText: "Are you sure you want to delete this resume?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        resumeController.deleteResume(resumeId);
        Get.back();
      },
    );
  }
}
