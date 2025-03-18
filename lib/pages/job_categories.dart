import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobCategories extends StatelessWidget {
  const JobCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> jobCategories = [
      "Marketing",
      "Security",
      "Human Resources (HR)",
      "Software Development",
      "Sales",
      "Customer Support",
      "Finance & Accounting",
      "Education & Training",
      "Healthcare",
      "Construction & Engineering",
      "Legal",
      "Logistics & Supply Chain",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Categories"),
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
        itemCount: jobCategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              jobCategories[index],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            leading: const Icon(Icons.add_circle, color: Colors.red),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.toNamed('/joblist');
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
