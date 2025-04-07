import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.yellow, // Updated header color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings,
                      size: 30, color: Colors.black), // Updated icon color
                ),
                const SizedBox(height: 10),
                Text(
                  "Admin Panel",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard, "Dashboard", '/admindashboard'),
          _buildDrawerItem(Icons.location_city, "Manage States", '/adminstate'),
          _buildDrawerItem(Icons.map, "Manage Districts", '/admindistrict'),
          _buildDrawerItem(
              Icons.category, "Manage Categories", '/admincategory'),
          _buildDrawerItem(Icons.work, "Manage Jobs", '/adminjobs'),
          _buildDrawerItem(Icons.camera, "Carousel", '/admincarousel'),
          _buildDrawerItem(Icons.person, "Users CV", '/adminuserprofile'),
          const Divider(),
          _buildDrawerItem(Icons.logout, "Logout", '/home'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.black), // Updated icon color
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Get.offAllNamed(route);
      },
    );
  }
}
