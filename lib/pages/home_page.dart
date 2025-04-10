import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:job/controllers/district_controller.dart';
import 'package:job/models/job_model.dart';
import 'package:job/pages/custom_Searchbar.dart';
import '../controllers/state_controller.dart'; // Import your StateController
import '../models/state_model.dart'; // Import your StateModel
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

JobModel? randomFeaturedJob;
bool isRandomJobLoading = true;

class _HomePageState extends State<HomePage> {
  bool _showAdminLogin = false;
  final StateController stateController = Get.put(StateController());
  final DistrictController districtController =
      Get.put(DistrictController()); // Instantiate here

  List<String> imageList = [
    'assets/images/listinglogo.jpeg',
    'assets/images/listinglogo.jpeg',
    'assets/images/listinglogo.jpeg',
  ];

  Future<void> fetchRandomFeaturedJob() async {
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/jobportal_simple/api/getRandomFeaturedJobs'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1 && data['data'] != null) {
        setState(() {
          randomFeaturedJob = JobModel.fromJson(data['data']);
          isRandomJobLoading = false;
        });
      } else {
        setState(() => isRandomJobLoading = false);
      }
    } else {
      setState(() => isRandomJobLoading = false);
      throw Exception('Failed to load random featured job');
    }
  }

  @override
  void initState() {
    super.initState();
    stateController.fetchStates();
    districtController.fetchFeaturedJobs();
    fetchCarouselImages();
    fetchRandomFeaturedJob(); // Add this line
  }

  Future<void> fetchCarouselImages() async {
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/jobportal_simple/api/getAllCarousel'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        List<String> images = [];
        for (var item in data['data']) {
          // Check if the status is 1 before adding the image
          if (item['status'] == 1) {
            images.add(item['image']);
          }
        }
        setState(() {
          imageList = images; // Update the imageList with fetched images
        });
      }
    } else {
      throw Exception('Failed to load carousel images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.yellow, // Yellow background
        title: Row(
          children: [
            GestureDetector(
              onLongPress: () {
                setState(() {
                  _showAdminLogin = !_showAdminLogin;
                });
              },
              child: Image.asset(
                'assets/images/listinglogo.jpeg', // Add your logo path here
                height: 180,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 10),
            if (_showAdminLogin)
              TextButton(
                onPressed: () {
                  Get.toNamed('/adminlogin');
                },
                child: Text(
                  "adminlogin".tr,
                  style: const TextStyle(
                      color: Colors.black, // Changed to black
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),
            const CustomSearchSection(), // Add search bar here
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 18),
              child: const Text(
                'Job Highlights',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                ),
                items: imageList.map((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child:
                              Icon(Icons.camera, color: Colors.grey, size: 60),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select State',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (stateController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (stateController.states.isEmpty) {
                      return const Center(child: Text('No states available'));
                    }
                    return SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: stateController.states.length,
                        itemBuilder: (context, index) {
                          StateModel state = stateController.states[index];
                          return GestureDetector(
                            onTap: () {
                              stateController.selectedStateId.value =
                                  state.id; // Update selected state ID
                              Get.toNamed('/districts',
                                  arguments:
                                      state.id); // Navigate to Districts page
                            },
                            child: Container(
                              width: 174,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(state.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.yellow.withOpacity(0.8),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      state.state.tr,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  const Text(
                    'Recommended Jobs',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  isRandomJobLoading
                      ? const Center(child: CircularProgressIndicator())
                      : randomFeaturedJob == null
                          ? const Center(
                              child: Text('No recommended job available'))
                          : GestureDetector(
                              onTap: () {
                                Get.toNamed('/jobdetail',
                                    arguments: randomFeaturedJob!.id);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: randomFeaturedJob!.isFeatured == 1
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
                                          randomFeaturedJob!.companyLogo ?? '',
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
                                              randomFeaturedJob!.jobTitle,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              randomFeaturedJob!.companyName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Location: ${randomFeaturedJob!.companyLocation}',
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
                                            const Text('Salary:'),
                                            Text(
                                              '${randomFeaturedJob!.salary}',
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
                            )
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
