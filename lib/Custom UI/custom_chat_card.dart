import 'package:chat_app/Model/chat_model.dart';
import 'package:chat_app/Screens/individual_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomChatCard extends StatelessWidget {
  const CustomChatCard(
      {super.key, required this.chatModel, required this.sourceChat,});

  final ChatModel chatModel;
  final ChatModel sourceChat;

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[800], // Darker background for avatar
            child: SvgPicture.asset(
              chatModel.isGroup
                  ? "assets/group_icon.svg"
                  : "assets/person_icon.svg",
              color: Colors.white,
              height: 37,
              width: 37,
            ), // Placeholder icon
          ),
          trailing: Text(
            chatModel.time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600], // Subtle grey for time
            ),
          ),
          title: Text(
            chatModel.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Row(
            children: [
              const Icon(
                Icons.done_all,
                size: 16,
                color: Colors.green, // Green to indicate read message
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  chatModel.currentMessage,
                  overflow: TextOverflow.ellipsis,
                  // Ensures text doesn't overflow
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400], // Lighter grey for last message
                  ),
                ),
              ),
            ],
          ),
          tileColor: const Color(0xFF111B21), // Dark background for each tile
          onTap: () {
            // Action when tapping on chat
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndividualChatScreen(
                  chatModel: chatModel,
                  sourceChat: sourceChat,
                ),
              ),
            );
          },
        ),
        Divider(color: Colors.grey[900],
        thickness: 1,
        height: 1,),
      ],
    );
  }
}
