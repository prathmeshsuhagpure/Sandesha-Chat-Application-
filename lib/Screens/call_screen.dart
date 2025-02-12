import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: ListView(
        children: [
          callCard(
            name: "Atharv",
            imageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
            iconData: Icons.call_missed,
            iconColor: Colors.red,
            time: "11:40 AM",
            isVideo: false,
          ),
          callCard(
            name: "Yash",
            imageUrl: "https://randomuser.me/api/portraits/men/2.jpg",
            iconData: Icons.call_made,
            iconColor: Colors.green,
            time: "Yesterday",
            isVideo: true,
          ),
          callCard(
            name: "Jay",
            imageUrl: "https://randomuser.me/api/portraits/men/3.jpg",
            iconData: Icons.call_received,
            iconColor: Colors.green,
            time: "10:15 PM",
            isVideo: false,
          ),
          callCard(
            name: "Prathmesh",
            imageUrl: "https://randomuser.me/api/portraits/men/4.jpg",
            iconData: Icons.call,
            iconColor: Colors.green,
            time: "Monday",
            isVideo: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add_call),
        onPressed: () {
          // Add new call functionality
        },
      ),
    );
  }

  Widget callCard({
    required String name,
    required String imageUrl,
    required IconData iconData,
    required Color iconColor,
    required String time,
    required bool isVideo,
  }) {
    return Card(
      color: const Color(0xFF111B21),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              time,
              style: TextStyle(fontSize: 12.8, color: Colors.grey[400]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isVideo)
              IconButton(
                icon: const Icon(
                  Icons.videocam,
                  color: Colors.teal,
                ),
                onPressed: () {
                  // Add video call functionality
                },
              ),
            IconButton(
              icon: const Icon(
                Icons.call,
                color: Colors.teal,
              ),
              onPressed: () {
                // Add voice call functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
