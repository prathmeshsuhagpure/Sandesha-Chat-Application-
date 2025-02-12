import 'package:chat_app/Screens/splash_screen.dart';
import 'package:chat_app/otp_service/verify_otp_service.dart';
import 'package:flutter/material.dart';

class AcountPage extends StatelessWidget {
  const AcountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111B21),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              VerifyOtpService.clearSession();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
              );
              debugPrint("LogOut Successful");
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: Colors.grey[800]),
            const SizedBox(height: 20),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png', // Replace with actual profile picture URL
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add functionality for changing profile picture
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildInfoTile(
              icon: Icons.person,
              title: 'Name',
              value: 'Prathmesh Suhagpure',
            ),
            //Divider(color: Colors.grey[800]),
            buildInfoTile(
              icon: Icons.info_outline,
              title: 'About',
              value: 'Jay Shree Ram 🚩🚩',
            ),
            //Divider(color: Colors.grey[800]),
            buildInfoTile(
              icon: Icons.phone,
              title: 'Phone',
              value: '+91 70383 60065',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoTile(
      {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 24),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
