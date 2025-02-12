import 'package:chat_app/Custom%20UI/Updates%20Pages/others_update_card.dart';
import 'package:chat_app/Custom%20UI/Updates%20Pages/own_update_card.dart';
import 'package:flutter/material.dart';

class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key});

  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 48,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[100],
              elevation: 8,
              onPressed: () {},
              child: Icon(
                Icons.edit,
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.greenAccent[700],
            elevation: 5,
            child: const Icon(
              Icons.camera_alt,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OwnUpdateCard(),
            const SizedBox(
              height: 10,
            ),
            label("Recent Updates"),
            const OthersUpdateCard(
              name: 'prathmesh',
              time: '01:23',
              imageName: '.jpg',
              isSeen: false,
              statusNum: 2,
            ),
            const OthersUpdateCard(
              name: 'atharv',
              time: '01:23',
              imageName: '.jpg',
              isSeen: false,
              statusNum: 8,
            ),
            const SizedBox(
              height: 10,
            ),
            label("Viewed Updates"),
            const OthersUpdateCard(
              name: 'Jay',
              time: '01:23',
              imageName: '.jpg',
              isSeen: true,
              statusNum: 1,
            ),
            const OthersUpdateCard(
              name: 'Yash',
              time: '01:23',
              imageName: '.jpg',
              isSeen: true,
              statusNum: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget label(String labelName) {
    return Container(
      height: 33,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff101D25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Text(
          labelName,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
