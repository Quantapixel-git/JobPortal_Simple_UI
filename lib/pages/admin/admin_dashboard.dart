import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_drawer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic> counts = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTableCounts();
  }

  Future<void> fetchTableCounts() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/jobportal_simple/api/getTableCounts'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        setState(() {
          counts = data['data'];
          isLoading = false;
        });
      } else {
        Get.snackbar("Error", "Failed to fetch data: ${data['message']}");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Get.snackbar("Error", "Failed to fetch data: ${response.statusCode}");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const AdminDrawer(),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchTableCounts, // Pull down to refresh
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Keeps 2 columns
                    crossAxisSpacing: 10, // Increases space between cards
                    mainAxisSpacing: 10, // More spacing between rows
                    childAspectRatio: 0.8, // Reducing this increases height
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return _buildDashboardCard(
                            Icons.image,
                            "Carousel",
                            counts['carousel']?.toString() ?? "0",
                            Colors.black);
                      case 1:
                        return _buildDashboardCard(
                            Icons.category,
                            "Categories",
                            counts['categories']?.toString() ?? "0",
                            Colors.black);
                      case 2:
                        return _buildDashboardCard(
                            Icons.people,
                            "CV's",
                            counts['profiles']?.toString() ?? "0",
                            Colors.black);
                      case 3:
                        return _buildExpandedJobCard();
                      case 4:
                        return _buildDashboardCard(
                            Icons.analytics,
                            "Districts",
                            counts['districts']?.toString() ?? "0",
                            Colors.black);
                      case 5:
                        return _buildDashboardCard(Icons.map, "States",
                            counts['states']?.toString() ?? "0", Colors.black);
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildDashboardCard(
      IconData icon, String title, String count, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.yellow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 5),
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 5),
            Text(count,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedJobCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.yellow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work, size: 40, color: Colors.black),
                const SizedBox(width: 10),
                const Text(
                  "Jobs",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            const Divider(color: Colors.black),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildJobDetail("Total",
                        counts['jobs']['total in DB']?.toString() ?? "0"),
                    _buildJobDetail(
                        "Active", counts['jobs']['active']?.toString() ?? "0"),
                    _buildJobDetail("Inactive",
                        counts['jobs']['inactive']?.toString() ?? "0"),
                    _buildJobDetail("Featured",
                        counts['jobs']['featured']?.toString() ?? "0"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDetail(String label, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          Text(count,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
