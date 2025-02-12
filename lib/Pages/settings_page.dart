import 'package:chat_app/Pages/acount_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111B21),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: const [
          Icon(Icons.search),
        ],
      ),
      backgroundColor: const Color(0xFF111B21),
      body: ListView(
        children: [
          // User Information Section
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AcountPage()),
              );
            },
            child: ListTile(
              leading: const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png'),
              ),
              title: const Text(
                'Prathmesh Suhagpure',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                'Jay Shree Ram 🚩🚩',
                style: TextStyle(
                  color: Colors.grey[300],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.qr_code,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[800]),

          // Options Section
          buildSettingsOption(
              icon: Icons.key,
              title: "Account",
              subtitle: "Security notifications, change number"),
          buildSettingsOption(
              icon: Icons.lock,
              title: "Privacy",
              subtitle: "Block contacts, disappearing messages"),
          buildSettingsOption(
              icon: Icons.person,
              title: "Avatar",
              subtitle: "Create, edit, profile photo"),
          buildSettingsOption(
              icon: Icons.photo_album,
              title: "Lists",
              subtitle: "Manage people and groups"),
          buildSettingsOption(
              icon: Icons.chat,
              title: "Chats",
              subtitle: "Theme, wallpapers, chat history"),
          buildSettingsOption(
              icon: Icons.notifications,
              title: "Notifications",
              subtitle: "Message, group & call tones"),
          buildSettingsOption(
              icon: Icons.storage,
              title: "Storage and data",
              subtitle: "Network usage, auto-download"),
          buildSettingsOption(
              icon: Icons.language,
              title: "App language",
              subtitle: "English (device's language)"),
          buildSettingsOption(
              icon: Icons.help_outline,
              title: "Help",
              subtitle: "Help center, contact us, privacy policy"),
          buildSettingsOption(
              icon: Icons.person_add_alt,
              title: "Invite a friend",
              subtitle: ""),
          buildSettingsOption(
            icon: Icons.update,
            title: "App updates",
            subtitle: "",
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 20,
            child: Padding(
              padding: EdgeInsets.only(left: 17),
              child: Text(
                "Also from Meta",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildSettingsOption(
            icon: FontAwesomeIcons.instagram,
            title: "Open Instagram",
            subtitle: "",
          ),
          buildSettingsOption(
            icon: FontAwesomeIcons.facebook,
            title: "Open Facebook",
            subtitle: "",
          ),
          buildSettingsOption(
            icon: FontAwesomeIcons.threads,
            title: "Open Threads",
            subtitle: "",
          ),
        ],
      ),
    );
  }

  Widget buildSettingsOption(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white)),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle, style: TextStyle(color: Colors.grey[600]))
          : null,
      onTap: () {
        // Handle onTap action
      },
    );
  }
}
