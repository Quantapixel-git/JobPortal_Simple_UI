import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:job/models/job_model.dart';

class CustomSearchSection extends StatelessWidget {
  const CustomSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 80,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 20,
          right: 20,
          child: Hero(
            tag: 'searchBar',
            child: GestureDetector(
              onTap: () {
                Get.to(() => const SearchPage(),
                    transition: Transition.noTransition);
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: IgnorePointer(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search here...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<JobModel> allJobs = [];
  bool isLoading = false;

  Future<void> searchJobs(String keyword) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://quantapixel.in/jobportal_simple/api/searchJobs'),
      body: {'keyword': keyword},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        setState(() {
          allJobs = List<JobModel>.from(
              data['data'].map((item) => JobModel.fromJson(item)));
        });
      } else {
        setState(() {
          allJobs = [];
        });
      }
    } else {
      setState(() {
        allJobs = [];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'searchBar',
            child: Material(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 10, right: 10, bottom: 10),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      searchJobs(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Type a keyword...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : allJobs.isEmpty
                    ? const Center(child: Text("No jobs found."))
                    : ListView.separated(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: allJobs.length,
                        itemBuilder: (context, index) {
                          final job = allJobs[index];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed('/jobdetail', arguments: job.id);
                            },
                            child: Card(
                              elevation: job.isFeatured == 1 ? 4 : 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: job.isFeatured == 1
                                    ? const BorderSide(
                                        color: Colors.redAccent, width: 1.5)
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Text('Salary: '),
                                          Text(
                                            '₹${job.salary}',
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
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 1),
                      ),
          ),
        ],
      ),
    );
  }
}
