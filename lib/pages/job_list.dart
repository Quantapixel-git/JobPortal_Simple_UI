import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobList extends StatelessWidget {
  const JobList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> softwareJobs = [
      {"title": "Flutter Developer", "company": "Quanta Pixel", "vacancies": 6},
      {"title": "Frontend Developer", "company": "Google", "vacancies": 4},
      {"title": "Backend Developer", "company": "Amazon", "vacancies": 3},
      {"title": "Full Stack Developer", "company": "Microsoft", "vacancies": 5},
      {"title": "Mobile App Developer", "company": "Meta", "vacancies": 2},
      {"title": "Flutter Developer", "company": "Zomato", "vacancies": 6},
      {"title": "React Developer", "company": "Paytm", "vacancies": 3},
      {"title": "Node.js Developer", "company": "Netflix", "vacancies": 2},
      {"title": "DevOps Engineer", "company": "IBM", "vacancies": 4},
      {"title": "Data Engineer", "company": "Infosys", "vacancies": 3},
      {"title": "AI/ML Engineer", "company": "Tesla", "vacancies": 5},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Software Development Jobs"),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(12.0),
        itemCount: softwareJobs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              softwareJobs[index]["title"],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              softwareJobs[index]["company"],
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            leading: const Icon(Icons.computer, color: Colors.red),
            trailing: Column(
              children: [
                Text(
                  '${softwareJobs[index]["vacancies"]}',
                  style: const TextStyle(color: Colors.red, fontSize: 10),
                ),
                Text("Vacancies")
              ],
            ),
            onTap: () {
              Get.toNamed('/jobdetail');
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          thickness: 0.8,
        ),
      ),
    );
  }
}
