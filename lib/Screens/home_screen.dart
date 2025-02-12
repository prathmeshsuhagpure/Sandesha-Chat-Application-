import 'package:chat_app/Model/chat_model.dart';
import 'package:chat_app/Pages/camera_page.dart';
import 'package:chat_app/Pages/chat_page.dart';
import 'package:chat_app/Pages/settings_page.dart';
import 'package:chat_app/Pages/updates_page.dart';
import 'package:chat_app/Screens/call_screen.dart';
import 'package:chat_app/Screens/create_group.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.chatModels,
    required this.sourceChat,
  });

  final List<ChatModel> chatModels;
  final ChatModel sourceChat;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      // Use the getAppBar function to fetch the correct AppBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF111B21),
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF111B21),
            icon: Icon(Icons.update_rounded),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF111B21),
            icon: Icon(Icons.camera_alt),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF111B21),
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildChatsScreen() // Display Chats screen for "Chats" tab
          : _selectedIndex == 1
              ? _buildUpdatesScreen() // Display Updates screen for "Updates" tab
              : _selectedIndex == 2
                  ? _buildCommunitiesScreen() // Display Communities for "Communities" tab
                  : _buildCallsScreen(), // Display Calls screen for "Calls" tab
    );
  }

  // Get the AppBar based on selected tab
  PreferredSizeWidget _getAppBar() {
    switch (_selectedIndex) {
      case 1:
        return const UpdatesAppBar();
      case 2:
        return const CommunitiesAppBar();
      case 3:
        return const CallsAppBar();
      default:
        return const ChatsAppBar();
    }
  }

  // Chat screen layout
  Widget _buildChatsScreen() {
    return ChatPage(
      chatModels: widget.chatModels,
      sourceChat: widget.sourceChat,
    );
    /*return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 130.0,
          toolbarHeight: 10,
          pinned: true,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      hintText: "Ask Meta AI or Search",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.circle, color: Colors.blue[300]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Filters Section (will disappear on scroll)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterChip(label: const Text("All"), onSelected: (_) {}),
                      FilterChip(
                          label: const Text("Unread"), onSelected: (_) {}),
                      FilterChip(
                          label: const Text("Favourites"), onSelected: (_) {}),
                      FilterChip(
                          label: const Text("Groups"), onSelected: (_) {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(
                title: Text('Chat $index',
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text('Last message',
                    style: TextStyle(color: Colors.grey[600])),
                leading: Icon(Icons.person, color: Colors.white),
                tileColor: Colors.black,
                onTap: () {},
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );*/
  }

  // Placeholder for Updates screen
  Widget _buildUpdatesScreen() {
    return UpdatesPage();
  }

  // Placeholder for Communities screen
  Widget _buildCommunitiesScreen() {
    //return Container();
    return CameraPage();
  }

  // Placeholder for Calls screen
  Widget _buildCallsScreen() {
    return CallScreen();
  }
}

// Chats AppBar
class ChatsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF111B21),
      title: Row(
        children: [
          const Text(
            "Sandesha",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraPage()),
              );
            },
          ),
          PopupMenuButton<String>(
            iconColor: Colors.white,
            color: Colors.black,
            onSelected: (value) {
              //print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    value: "New Group",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateGroup()),
                      );
                    },
                    child: Text(
                      "New Group",
                      style: TextStyle(color: Colors.white),
                    )),
                const PopupMenuItem(
                    value: "New Broadcast",
                    child: Text("New Broadcast",
                        style: TextStyle(color: Colors.white))),
                const PopupMenuItem(
                    value: "Linked Devices",
                    child: Text("Linked Devices",
                        style: TextStyle(color: Colors.white))),
                const PopupMenuItem(
                    value: "Starred messages",
                    child: Text("Starred messages ",
                        style: TextStyle(color: Colors.white))),
                const PopupMenuItem(
                    value: "Payments",
                    child: Text("Payments",
                        style: TextStyle(color: Colors.white))),
                PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                    value: "Settings",
                    child: const Text("Settings",
                        style: TextStyle(color: Colors.white))),
              ];
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Updates AppBar
class UpdatesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UpdatesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF111B21),
      title: const Text(
        "Updates",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Communities AppBar
class CommunitiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommunitiesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF111B21),
      title: const Text(
        "Camera",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Calls AppBar
class CallsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CallsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF111B21),
      title: const Text(
        "Calls",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            // Add search functionality
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onSelected: (value) {
            // Handle options
            print("Selected: $value");
          },
          color: Colors.grey[800],
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: "Settings",
                child: Text(
                  "Settings",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: "Clear call log",
                child: Text(
                  "Clear call log",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
