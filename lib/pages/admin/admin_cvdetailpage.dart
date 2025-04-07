import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job/models/cv_model.dart'; // Import your CV model
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:open_file/open_file.dart'; // Import open_file

class CvDetailPage extends StatelessWidget {
  final ResumeModel resume;

  CvDetailPage({required this.resume});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(resume.name)),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement your refresh logic here if needed
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("Name: ${resume.name}",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Date of Birth: ${resume.dob}"),
                SizedBox(height: 10),
                Text("Email: ${resume.email}"),
                SizedBox(height: 10),
                Text("Mobile: ${resume.mobile}"),
                SizedBox(height: 10),
                Text("Qualification: ${resume.qualification}"),
                SizedBox(height: 10),
                Text("Experience: ${resume.experience}"),
                SizedBox(height: 10),
                Text("Skills: ${resume.skills}"),
                SizedBox(height: 10),
                Text("Address: ${resume.address}"),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _launchURL(resume.linkedin),
                  child: Text(
                    "LinkedIn: ${resume.linkedin}",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _openPDF(resume.resume),
                  child: Text(
                    "Resume: ${resume.resume}",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Download Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadProfile(resume.id),
                    icon: Icon(Icons.download, color: Colors.black,),
                    label: Text("Download Profile PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Function to open the profile print URL
void _downloadProfile(int id) async {
  final String url = "https://quantapixel.in/jobportal_simple/PrintProfile/$id";
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    Get.snackbar("Error", "Could not open download link");
  }
}

// Function to open a URL
void _launchURL(String url) async {
  if (url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true) {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not launch $url");
    }
  } else {
    Get.snackbar("Error", "Invalid URL: $url");
  }
}

// Function to open a PDF
void _openPDF(String pdfPath) async {
  if (pdfPath.startsWith("http") || pdfPath.startsWith("https")) {
    final Uri uri = Uri.parse(pdfPath);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not open PDF: $pdfPath");
    }
  } else {
    final file = File(pdfPath);
    if (await file.exists()) {
      await OpenFile.open(file.path);
    } else {
      Get.snackbar("Error", "PDF file not found: $pdfPath");
    }
  }
}
