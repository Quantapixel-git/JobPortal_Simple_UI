import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.admin_panel_settings,
                        size: 30, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Admin Panel",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.red),
              title: const Text("Dashboard"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.red),
              title: const Text("Manage Users"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.business, color: Colors.red),
              title: const Text("Manage Companies"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.work, color: Colors.red),
              title: const Text("Manage Jobs"),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildDashboardCard(Icons.people, "Users", "120", Colors.blue),
            _buildDashboardCard(
                Icons.business, "Companies", "45", Colors.green),
            _buildDashboardCard(Icons.work, "Jobs", "230", Colors.orange),
            _buildDashboardCard(
                Icons.analytics, "Districts", "15", Colors.purple),
          ],
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(count,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
