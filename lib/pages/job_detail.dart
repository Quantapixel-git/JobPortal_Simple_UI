import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobDetail extends StatelessWidget {
  const JobDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Company Details"),
        backgroundColor: Colors.red,
         actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  Get.offAllNamed('/home');
                },
                child: Icon(Icons.home)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/company.jpg",
                  height: 280,
                  // width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Company Name
            Center(
              child: Text(
                "Google Inc.",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            const SizedBox(height: 10),

            // Job Title
            const Text(
              "🔹 Job Title: Senior Software Engineer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // Requirements
            const Text(
              "📌 Job Requirements:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Text(
              "✔ 5+ years experience in Flutter & Dart\n"
              "✔ Strong knowledge of REST APIs & Firebase\n"
              "✔ Experience with GetX & Clean Architecture\n"
              "✔ Excellent problem-solving skills",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Address
            const Text(
              "📍 Address:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Text(
              "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Contact Information
            const Text(
              "📞 Contact Details:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Text(
              "☎ Phone: +1 650-253-0000\n"
              "📧 Email: hr@google.com\n"
              "🌍 Website: www.google.com",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Apply Now Button
          ],
        ),
      ),
    );
  }
}
