import 'package:chat_app/Custom%20UI/button_card.dart';
import 'package:chat_app/Custom%20UI/custom_contact_card.dart';
import 'package:chat_app/Screens/create_group.dart';
import 'package:flutter/material.dart';
import '../Model/contact_model.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    List<ContactModel> contacts = [
      ContactModel(
        name: "Prathmesh",
        status: "A Flutter Developer",
      ),
      ContactModel(
        name: "Jay",
        status: "A Flutter Developer",
      ),
      ContactModel(
        name: "Yash",
        status: "A Flutter Developer",
      ),
      ContactModel(
        name: "Madhura",
        status: "A Flutter Developer",
      ),
      ContactModel(
        name: "Janvi",
        status: "A Flutter Developer",
      ),
      ContactModel(
        name: "Khushi",
        status: "A Flutter Developer",
      ),
      ContactModel(
        name: "Rocky",
        status: "A Flutter Developer",
      ),
      ContactModel(
        name: "Manoj",
        status: "A Flutter Developer",
      ),
    ];

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
              "Select Contact",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "200 Contacts",
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.white,
              )),
          PopupMenuButton<String>(
            iconColor: Colors.white,
            color: Colors.black,
            onSelected: (value) {
              //print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                    value: "Invite a friend",
                    child: Text(
                      "Invite a friend",
                      style: TextStyle(color: Colors.white),
                    )),
                const PopupMenuItem(
                    value: "Contacts",
                    child: Text("Contacts",
                        style: TextStyle(color: Colors.white))),
                const PopupMenuItem(
                    value: "Refresh",
                    child:
                        Text("Refresh", style: TextStyle(color: Colors.white))),
                const PopupMenuItem(
                    value: "Help",
                    child: Text("Help", style: TextStyle(color: Colors.white))),
              ];
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF111B21),
      body: ListView.builder(
          itemCount: contacts.length + 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateGroup()),
                    );
                  },
                  child:
                      const ButtonCard(icon: Icons.group, name: "New Group"));
            } else if (index == 1) {
              return const ButtonCard(
                  icon: Icons.person_add, name: "New Contact");
            } else if (index == 2) {
              return const ButtonCard(
                  icon: Icons.person_add, name: "New Community");
            }
            return CustomContactCard(contact: contacts[index - 3]);
          }),
    );
  }
}
