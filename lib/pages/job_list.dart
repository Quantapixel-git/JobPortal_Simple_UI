import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/job_model.dart'; // Import your JobModel

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<JobModel> allJobs = [];
  List<JobModel> featuredJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    print("Initializing JobList...");
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    // Retrieve the arguments passed from the previous page
    final Map<String, dynamic> args = Get.arguments;
    final int stateId = args['stateId'];
    final int districtId = args['districtId'];
    final int categoryId = args['categoryId'];

    print(
        "Fetching jobs with State ID: $stateId, District ID: $districtId, Category ID: $categoryId");

    // Prepare the API request
    final response = await http.post(
      Uri.parse("https://quantapixel.in/jobportal_simple/api/getFilteredJobs"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "state_id": stateId,
        "district_id": districtId,
        "category_id": categoryId,
      }),
    );

    print("API Response Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response Data: $data");

      if (data['status'] == 1) {
        allJobs = List<JobModel>.from(
            data['data'].map((item) => JobModel.fromJson(item)));
        featuredJobs = allJobs.where((job) => job.isFeatured == 1).toList();
        print(
            "Jobs fetched successfully: ${allJobs.length} total, ${featuredJobs.length} featured");
      } else {
        Get.snackbar("Error", "Failed to fetch jobs: ${data['message']}");
        print("Error fetching jobs: ${data['message']}");
      }
    } else {
      Get.snackbar("Error", "Failed to fetch jobs: ${response.statusCode}");
      print("Error status code: ${response.statusCode}");
    }

    setState(() {
      isLoading = false;
    });
    print("Loading state set to false.");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Listings"),
        backgroundColor: Colors.yellow,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "All Jobs"),
            Tab(text: "Featured Jobs"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildJobList(allJobs),
                _buildJobList(featuredJobs),
              ],
            ),
    );
  }

  Widget _buildJobList(List<JobModel> jobs) {
    print("Building job list with ${jobs.length} jobs.");
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return GestureDetector(
          onTap: () {
            print("Tapped on job: ${job.jobTitle}");
            Get.toNamed('/jobdetail', arguments: job.id);
          },
          child: Card(
            elevation: job.isFeatured == 1 ? 4 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: job.isFeatured == 1
                  ? const BorderSide(color: Colors.redAccent, width: 1.5)
                  : BorderSide.none,
            ),
            color: Colors.white,
            shadowColor: Colors.grey.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      job.companyLogo ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.jobTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.companyName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Location: ${job.companyLocation}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Salary: '),
                        Text(
                          '${job.salary}',
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 1),
    );
  }
}
