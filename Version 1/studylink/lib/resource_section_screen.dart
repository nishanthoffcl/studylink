import 'package:flutter/material.dart';

class ResourceSectionScreen extends StatelessWidget {
  const ResourceSectionScreen({super.key});

  final List<Map<String, String>> dummyResources = const [
    {"title": "Introduction to ML.pdf", "type": "PDF", "rating": "4.5"},
    {"title": "data.csv", "type": "CSV", "rating": "4.8"},
    {"title": "neural_net.py", "type": "Python", "rating": "4.2"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Resources", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: "Most Downloaded",
                  items: const [
                    DropdownMenuItem(value: "Most Downloaded", child: Text("Most Downloaded", style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: "Top Rated", child: Text("Top Rated", style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (value) {},
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: const Text("Upload", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: dummyResources.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dummyResources[index]["title"]!, style: const TextStyle(color: Colors.white)),
                  subtitle: Text("⭐ ${dummyResources[index]["rating"]}", style: const TextStyle(color: Colors.white70)),
                  trailing: const Icon(Icons.download, color: Colors.white),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
