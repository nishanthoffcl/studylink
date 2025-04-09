import 'package:flutter/material.dart';
import 'resource_section_screen.dart';
import 'create_group_screen.dart';
import 'join_group_screen.dart';

class GroupDashboardScreen extends StatelessWidget {
  const GroupDashboardScreen({super.key});

  final List<String> dummyGroups = const ["Machine Learning", "Flutter Devs", "AI Study Club"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Darker & more stylish background
      appBar: AppBar(
        title: const Text("My Groups", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2A2D3E), // Improved AppBar color
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(context, Icons.group_add, "Create Group", const CreateGroupScreen()),
                _buildActionButton(context, Icons.person_add, "Join Group", const JoinGroupScreen()),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: dummyGroups.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blueGrey.shade900, // Improved card color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage("assets/user.png"), // Placeholder image
                    ),
                    title: Text(dummyGroups[index], style: const TextStyle(color: Colors.white, fontSize: 18)),
                    subtitle: const Text("A group for discussing topics", style: TextStyle(color: Colors.white70)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ResourceSectionScreen()));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String title, Widget screen) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent, // Vibrant button color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
    );
  }
}
