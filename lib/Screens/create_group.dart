import 'package:chat_app/Custom%20UI/custom_group_avatar.dart';
import 'package:flutter/material.dart';

import '../Custom UI/custom_contact_card.dart';
import '../Model/contact_model.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ContactModel> contacts = [
    ContactModel(name: "Prathmesh", status: "A Flutter Developer"),
    ContactModel(name: "Jay", status: "A Flutter Developer"),
    ContactModel(name: "Yash", status: "A Flutter Developer"),
    ContactModel(name: "Madhura", status: "A Flutter Developer"),
    ContactModel(name: "Janvi", status: "A Flutter Developer"),
    ContactModel(name: "Khushi", status: "A Flutter Developer"),
    ContactModel(name: "Rocky", status: "A Flutter Developer"),
    ContactModel(name: "Manoj", status: "A Flutter Developer"),
  ];

  List<ContactModel> groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the desired color for the back button
        ),
        backgroundColor: const Color(0xFF111B21),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Group",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Add contacts",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add search functionality
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF111B21),
      body: Container(
        child: Stack(
          children: [
            ListView.builder(
              itemCount: contacts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    height: groups.isNotEmpty ? 90 : 10,
                  );
                }
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (contacts[index - 1].select == false) {
                        contacts[index - 1].select = true;
                        groups.add(contacts[index - 1]);
                      } else {
                        contacts[index - 1].select = false;
                        groups.remove(contacts[index - 1]);
                      }
                    });
                  },
                  child: CustomContactCard(contact: contacts[index - 1]),
                );
              },
            ),
            if (groups.isNotEmpty)
              Column(
                children: [
                  Container(
                    height: 90,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xff232D36),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              contacts[contacts.indexOf(groups[index])].select =
                              false;
                              groups.removeAt(index);
                            });
                          },
                          child: CustomGroupAvatar(contact: groups[index]),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
