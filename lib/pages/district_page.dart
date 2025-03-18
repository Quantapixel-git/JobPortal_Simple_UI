import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:job/pages/home_page.dart';

class Districts extends StatelessWidget {
  const Districts({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> districts = [
      "District 1",
      "District 2",
      "District 3",
      "District 4",
      "District 5",
      "District 6",
      "District 7",
      "District 8",
      "District 9",
      "District 10",
      "District 11",
      "District 12",
      "District 13",
      "District 14",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Districts"),
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
        itemCount: districts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              districts[index],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            leading: const Icon(Icons.location_on, color: Colors.red),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.toNamed('/jobcategories');
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
