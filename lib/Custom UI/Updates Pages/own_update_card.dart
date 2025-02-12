import 'package:flutter/material.dart';

class OwnUpdateCard extends StatelessWidget {
  const OwnUpdateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundColor: Colors.black,
            backgroundImage: AssetImage(""),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.greenAccent[700],
              radius: 10,
              child: const Icon(
                Icons.add,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      title: const Text(
        "My Updates",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        "Tap to add updates",
        style: TextStyle(
          fontSize: 13,
          color: Colors.white70,
        ),
      ),
    );
  }
}
