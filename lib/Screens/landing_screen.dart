import 'package:chat_app/Pages/login_page.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: const Color(0xFF111B21),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Welcome to WhatsApp",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Image.asset(
                  "assets/bg.png",
                  color: Colors.greenAccent[700],
                  height: 340,
                  width: 340,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: "Agree and Continue to accept the ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const TextSpan(
                          text: "WhatsApp Terms of Service and Privacy Policy",
                          style: TextStyle(
                            color: Colors.cyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 110,
                    height: 50,
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      elevation: 8,
                      color: Colors.greenAccent[700],
                      child: const Center(
                        child: Text(
                          "AGREE AND CONTINUE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
