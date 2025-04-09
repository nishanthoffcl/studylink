import 'package:flutter/material.dart';
import 'group_dashboard_screen.dart';
import 'create_group_screen.dart';
import 'join_group_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF431F91), Color(0xFF1A73E8)], 
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "StudyLink",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 30),
                _buildButton(context, Icons.search, "Explore Groups", const GroupDashboardScreen()),
                _buildButton(context, Icons.group_add, "Create Group", const CreateGroupScreen()),
                _buildButton(context, Icons.person_add, "Join Group", const JoinGroupScreen()),
                _buildButton(context, Icons.folder, "My Groups", const GroupDashboardScreen()),
              ],
            ),
            Positioned(
              top: 50,
              right: 20,
              child: Row(
                children: [
                  _buildIconButton(Icons.notifications, "Notifications"),
                  const SizedBox(width: 15),
                  _buildIconButton(Icons.person, "Profile"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        },
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon, size: 28, color: Colors.white),
      tooltip: tooltip,
      onPressed: () {},
    );
  }
}
