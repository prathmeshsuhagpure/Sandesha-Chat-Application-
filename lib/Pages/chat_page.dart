import 'package:chat_app/Custom%20UI/custom_chat_card.dart';
import 'package:chat_app/Model/chat_model.dart';
import 'package:chat_app/Screens/select_contact.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.chatModels,
    required this.sourceChat,
  });

  final List<ChatModel> chatModels;
  final ChatModel sourceChat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SelectContact()),
          );
        },
        child: const Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => CustomChatCard(
          chatModel: widget.chatModels[index],
          sourceChat: widget.sourceChat,
        ),
        itemCount: widget.chatModels.length,
      ),
    );
  }
}
