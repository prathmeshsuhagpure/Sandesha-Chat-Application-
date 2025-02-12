import 'package:chat_app/Screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../Model/chat_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ChatModel sourceChat;
  final List<ChatModel> chatModel = [
    ChatModel(
      name: "Atharv",
      icon: "Icons.person",
      isGroup: false,
      time: "4:00",
      currentMessage: "Hi",
      status: 'Available',
      id: 1,
    ),
    ChatModel(
      name: "Yash",
      icon: "Icons.person",
      isGroup: false,
      time: "4:00",
      currentMessage: "Hi",
      status: 'Busy',
      id: 2,
    ),
    ChatModel(
      name: "Manoj",
      icon: "Icons.person",
      isGroup: false,
      time: "4:00",
      currentMessage: "Hi",
      status: 'Offline',
      id: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Text(
              "Select a Chat to Start",
              style: TextStyle(
                color: Colors.tealAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: chatModel.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    sourceChat = chatModel.removeAt(index);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          chatModels: chatModel,
                          sourceChat: sourceChat,
                        ),
                      ),
                    );
                  },
                  child: _buildChatCard(chatModel[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(ChatModel chat) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: const Color(0xff1A2733),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.teal,
          child: Icon(
            _getIconData(chat.icon),
            color: Colors.white,
          ),
        ),
        title: Text(
          chat.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          chat.status,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "Icons.person":
        return Icons.person;
      case "Icons.group":
        return Icons.group;
      default:
        return Icons.person; // Default icon
    }
  }
}
