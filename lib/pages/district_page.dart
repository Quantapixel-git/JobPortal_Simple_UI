import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/district_controller.dart'; // Import your DistrictController
import '../models/district_model.dart'; // Import your DistrictModel

class Districts extends StatefulWidget {
  const Districts({super.key});

  @override
  _DistrictsState createState() => _DistrictsState();
}

class _DistrictsState extends State<Districts> {
  final DistrictController districtController = Get.find<
      DistrictController>(); // Use Get.find to get the existing instance

  @override
  void initState() {
    super.initState();
    final int stateId = Get.arguments; // Get the state ID passed from HomePage
    districtController
        .fetchDistrictsById(stateId); // Fetch districts for the selected state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Districts"),
        backgroundColor: Colors.yellow,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Get.offAllNamed('/home');
              },
              child: const Icon(Icons.home),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (districtController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (districtController.districts.isEmpty) {
          return const Center(child: Text('No districts available'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12.0),
          itemCount: districtController.districts.length,
          itemBuilder: (context, index) {
            DistrictModel district = districtController.districts[index];
            return ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              leading: ClipOval(
                child: Image.network(
                  district.image, // Use the district image
                  width: 50, // Set a fixed width
                  height: 50, // Set a fixed height
                  fit: BoxFit.cover, // Ensure the image covers the area
                ),
              ),
              title: Text(
                district.district,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to job categories and pass state ID and district ID
                Get.toNamed('/jobcategories', arguments: {
                  'stateId': Get.arguments, // Pass the state ID
                  'districtId': district.id,
                });
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            thickness: 0.8,
          ),
        );
      }),
    );
  }
}
