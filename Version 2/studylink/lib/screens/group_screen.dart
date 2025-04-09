import 'package:flutter/material.dart';
import 'group_detail_screen.dart'; // Import the detail screen

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy list of groups
    final List<String> groups = ['Group A', 'Group B', 'Group C'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groups'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groups[index]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Group Detail Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailScreen(groupName: groups[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For now, just print
          print('Add New Group');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
