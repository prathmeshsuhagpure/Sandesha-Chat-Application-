import 'package:chat_app/Custom%20UI/custom_ring_updates.dart';
import 'package:flutter/material.dart';

class OthersUpdateCard extends StatelessWidget {
  const OthersUpdateCard({
    super.key,
    required this.name,
    required this.time,
    required this.imageName,
    required this.isSeen,
    required this.statusNum,
  });

  final String name;
  final String time;
  final String imageName;
  final bool isSeen;
  final int statusNum;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomPaint(
        painter: StatusPainter(isSeen: isSeen, statusNum: statusNum),
        child: const CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage(""),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.white
        ),
      ),
      subtitle: Text(
        "Today at, $time",
        style: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}
