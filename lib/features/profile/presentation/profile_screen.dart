import 'package:flutter/material.dart';


import 'package:auto_route/auto_route.dart';


@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hồ sơ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 15, // Set the title spacing to 0 for left alignment
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildProfileHeader(),
          const Divider(),
          _buildMenuItem(
            icon: Icons.account_box,
            title: 'Account',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.book,
            title: 'Addresses Book',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.sync,
            title: 'Status',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.notifications,
            title: 'Notification',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.chat,
            title: 'Chat settings',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.data_usage,
            title: 'Data and storage',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.lock,
            title: 'Privacy and security',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.info,
            title: 'About',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(
                'assets/images/profile/Image.png'), // Replace with your image path
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Darlene Steward',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'darlene.steward@example.com',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.orange,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
