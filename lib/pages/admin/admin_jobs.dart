import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job/controllers/job_controller.dart';
import 'package:job/models/job_model.dart'; // Import your JobModel
import 'package:job/pages/admin/admin_add_jobs_page.dart';
import 'package:job/pages/admin/admin_drawer.dart';
import 'package:job/pages/admin/admin_edit_job_page.dart';

class AdminJobs extends StatelessWidget {
  final JobController jobController = Get.put(JobController());
  final RxList<JobModel> expiredJobs = <JobModel>[].obs;
  final RxList featuredJobs = [].obs;
  var showExpiredJobs = false.obs;
  var showFeaturedJobs = false.obs;

  Future<void> _updateFeaturedStatus(int jobId, int isFeatured) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://quantapixel.in/jobportal_simple/api/updateFeaturedStatus'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "job_id": jobId,
          "is_featured": isFeatured,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 1) {
        Get.snackbar("Success", "Featured status updated.",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "Failed to update featured status.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _updateJobStatus(int jobId, int status) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://quantapixel.in/jobportal_simple/api/updateJobStatus'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"job_id": jobId, "status": status}),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 1) {
        Get.snackbar("Success", "Job status updated.",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "Failed to update job status.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Jobs"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'all') {
                showExpiredJobs.value = false; // Update the observable
                showFeaturedJobs.value = false; // Update the observable
                jobController.fetchJobs(); // Fetch all jobs
              } else if (value == 'expired') {
                showExpiredJobs.value = true; // Update the observable
                showFeaturedJobs.value = false; // Update the observable
                fetchExpiredJobs(); // Fetch expired jobs
              } else if (value == 'featured') {
                showExpiredJobs.value = false; // Update the observable
                showFeaturedJobs.value = true; // Update the observable
                fetchFeaturedJobs(); // Fetch featured jobs
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'all',
                  child: Text("All Jobs"),
                ),
                PopupMenuItem<String>(
                  value: 'expired',
                  child: Text("Expired Jobs"),
                ),
                PopupMenuItem<String>(
                  value: 'featured',
                  child: Text("Featured Jobs (Not Expired)"),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: const AdminDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await jobController.fetchStates();
          await jobController.fetchDistricts();
          await jobController.fetchCategories();
          await jobController.fetchJobs(); // Ensure jobs are fetched
          await fetchExpiredJobs(); // Fetch expired jobs
          await fetchFeaturedJobs(); // Fetch featured jobs
        },
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Pull down to refresh",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (jobController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                // Determine which jobs to display
                final jobsToDisplay = showExpiredJobs.value
                    ? expiredJobs
                    : showFeaturedJobs.value
                        ? featuredJobs
                        : jobController.jobs;

                return ListView.builder(
                  itemCount: jobsToDisplay.length,
                  itemBuilder: (context, index) {
                    final job = jobsToDisplay[index];
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
                        title: Text(
                          job.jobTitle,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Company: ${job.companyName}"),
                            SizedBox(
                                height: 5), // Small gap between text and icons
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.visibility,
                                          color: Colors.green),
                                      onPressed: () {
                                        Get.toNamed('/jobdetail',
                                            arguments: job.id);
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        Get.to(() => EditJob(job: job));
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () =>
                                          _confirmDelete(context, job.id),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Job Status: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Transform.scale(
                                      scale:
                                          0.75, // Reduce size here (you can try 0.6 or 0.5 too)
                                      child: Switch(
                                        value: job.status == 1,
                                        onChanged: (value) async {
                                          final newStatus = value ? 1 : 2;
                                          await _updateJobStatus(
                                              job.id, newStatus);
                                          job.status = newStatus;
                                          jobController.jobs.refresh();
                                        },
                                        activeColor: Colors.green,
                                        inactiveThumbColor: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      job.status == 1 ? "Active" : "Not Active",
                                      style: TextStyle(
                                        color: job.status == 1
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Featured: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Transform.scale(
                                      scale: 0.75,
                                      child: Switch(
                                        value: job.isFeatured == 1,
                                        onChanged: (value) async {
                                          final newFeaturedStatus =
                                              value ? 1 : 2;
                                          await _updateFeaturedStatus(
                                              job.id, newFeaturedStatus);

                                          // Update the job's isFeatured status immediately
                                          final index = jobController.jobs
                                              .indexWhere(
                                                  (j) => j.id == job.id);
                                          if (index != -1) {
                                            jobController
                                                    .jobs[index].isFeatured =
                                                newFeaturedStatus; // Update the observable list directly
                                            jobController.jobs
                                                .refresh(); // Notify the UI to refresh
                                          }
                                        },
                                        activeColor: Colors.orange,
                                        inactiveThumbColor: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      job.isFeatured == 1 ? "Yes" : "No",
                                      style: TextStyle(
                                        color: job.isFeatured == 1
                                            ? Colors.orange
                                            : Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: job.image != null
                            ? Container(
                                width: 50, // Adjust width if needed
                                height: 50, // Adjust height if needed
                                child: Image.network(job.image!,
                                    fit: BoxFit.cover),
                              )
                            : Icon(Icons.image_not_supported),
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
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => AddJob());
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          child: const Text('Add Jobs', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Future<void> fetchExpiredJobs() async {
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/jobportal_simple/api/getAllExpiredJobs'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        // Convert the JSON data to JobModel instances
        expiredJobs.value = (jsonResponse['data'] as List)
            .map((job) => JobModel.fromJson(job))
            .toList()
            .cast<JobModel>(); // Ensure the list is cast to RxList<JobModel>
      }
    } else {
      throw Exception('Failed to load expired jobs');
    }
  }

  Future<void> fetchFeaturedJobs() async {
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/jobportal_simple/api/getAllFeaturedJobs'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        // Convert the JSON data to JobModel instances
        featuredJobs.value = (jsonResponse['data'] as List)
            .map((job) => JobModel.fromJson(job))
            .toList()
            .cast<JobModel>(); // Ensure the list is cast to RxList<JobModel>
      }
    } else {
      throw Exception('Failed to load featured jobs');
    }
  }

  void _confirmDelete(BuildContext context, int jobId) {
    Get.defaultDialog(
      title: "Delete Job",
      middleText: "Are you sure you want to delete this job?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        jobController.deleteJob(jobId).then((_) {
          // Refresh the job list after deletion
          jobController.fetchJobs();
          fetchExpiredJobs(); // Refresh expired jobs after deletion
          fetchFeaturedJobs(); // Refresh featured jobs after deletion
        });
        Get.back();
      },
    );
  }
}
