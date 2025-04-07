import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../models/job_model.dart'; // Import your JobModel
import 'package:share_plus/share_plus.dart';

class JobDetail extends StatefulWidget {
  const JobDetail({super.key});

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  JobModel? job; // To hold the job details
  bool isLoading = true;
  int currentImageIndex =
      0; // To track the current image index for the dots indicator

  @override
  void initState() {
    super.initState();
    _fetchJobDetails();
  }

  Future<void> _fetchJobDetails() async {
    // Retrieve the job ID passed from the previous page
    final int jobId = Get.arguments;

    // Prepare the API request
    final response = await http.post(
      Uri.parse("https://quantapixel.in/jobportal_simple/api/getJobById"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": jobId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        job = JobModel.fromJson(data['data']);
      } else {
        Get.snackbar(
            "Error", "Failed to fetch job details: ${data['message']}");
      }
    } else {
      Get.snackbar(
          "Error", "Failed to fetch job details: ${response.statusCode}");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            onPressed: () async {
              final jobDetails = '''
📢 *${job?.jobTitle}* at *${job?.companyName}*

📍 Location: ${job?.companyLocation}
💼 Experience: ${job?.experience} years
🎓 Qualification: ${job?.qualification}
💰 Salary: ${job?.salary}
🧠 Skills: ${job?.skills}
📞 Contact: ${job?.contactNumber}
📧 Email: ${job?.email}
📅 Apply Before: ${job?.expiryAt}

📝 Description:
${job?.jobDescription}

🔗 Visit our job portal for more info!
''';

              if (job?.image != null && job!.image!.isNotEmpty) {
                try {
                  // Download image from the network
                  final response = await http.get(Uri.parse(job!.image!));
                  final bytes = response.bodyBytes;

                  // Store image temporarily on device
                  final tempDir = await getTemporaryDirectory();
                  final file = File('${tempDir.path}/job_image.jpg');
                  await file.writeAsBytes(bytes);

                  // Share with image
                  await Share.shareXFiles(
                    [XFile(file.path)],
                    text: jobDetails,
                  );
                } catch (e) {
                  // If something fails, fallback to text share only
                  await Share.share(jobDetails);
                }
              } else {
                // Share without image
                await Share.share(jobDetails);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : job != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Gallery with Dots Indicator
                      Column(
                        children: [
                          SizedBox(
                            height: 280,
                            child: PageView(
                              onPageChanged: (index) {
                                setState(() {
                                  currentImageIndex = index;
                                });
                              },
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    job!.image ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (job!.additionalImage1 != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      job!.additionalImage1!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (job!.additionalImage2 != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      job!.additionalImage2!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Dots Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentImageIndex == index
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Company Name
                      Center(
                        child: Text(
                          job!.companyName,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Job Title
                      Text(
                        "🔹 Job Title: ${job!.jobTitle}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),

                      // Requirements
                      const Text(
                        "📌 Job Requirements:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "✔ Experience: ${job!.experience} years\n"
                        "✔ Qualification: ${job!.qualification}\n"
                        "✔ Salary: ${job!.salary}\n"
                        "✔ Gender: ${job!.gender}\n"
                        "✔ Marital Status: ${job!.maritalStatus}\n"
                        "✔ Skills: ${job!.skills}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Address
                      const Text(
                        "📍 Address:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        job!.jobLocations,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Contact Information
                      const Text(
                        "📞 Contact Details:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "☎ Phone: ${job!.contactNumber}\n"
                        "📧 Email: ${job!.email}\n"
                        "📍 Location: ${job!.companyLocation}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Job Description
                      const Text(
                        "📄 About Job:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        " jobDescription: ${job!.jobDescription}\n"
                        " jobLocations: ${job!.jobLocations}\n"
                        "Apply Before: ${job!.expiryAt}",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                )
              : const Center(child: Text("Job not found")),
    );
  }
}
