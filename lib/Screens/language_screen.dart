import 'package:chat_app/Screens/landing_screen.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';
  final List<Map<String, String>> _languages = [
    {'name': 'English', 'subtitle': "device's language"},
    {'name': 'हिन्दी', 'subtitle': 'Hindi'},
    {'name': 'मराठी', 'subtitle': 'Marathi'},
    {'name': 'ગુજરાતી', 'subtitle': 'Gujarati'},
    {'name': 'தமிழ்', 'subtitle': 'Tamil'},
    {'name': 'বাংলা', 'subtitle': 'Bengali'},
    {'name': 'తెలుగు', 'subtitle': 'Telugu'},
    {'name': 'ಕನ್ನಡ', 'subtitle': 'Kannada'},
    {'name': 'മലയാളം', 'subtitle': 'Malayalam'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21), // Dark background color
      body: Column(
        children: [
          const SizedBox(height: 50), // Padding from the top
          // Card with "Welcome to WhatsApp"
          Card(
            color: const Color(0xFF1F2C34), // Card background color
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Background image
                Container(
                  height: 200, // Set height for the card
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('assets/whatsapp_bg_image.png'),
                      fit: BoxFit.cover, // Make the image cover the area
                    ),
                  ),
                ),
                // Overlay text
                Container(
                  height: 200, // Match the height of the image container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.4), // Add overlay for text visibility
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Welcome to WhatsApp',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Choose your language to get started',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // List of languages
          Expanded(
            child: ListView.builder(
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                return RadioListTile<String>(
                  value: language['name']!,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                  title: Text(
                    language['name']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: language['subtitle'] != null
                      ? Text(
                    language['subtitle']!,
                    style: const TextStyle(color: Colors.white70),
                  )
                      : null,
                  activeColor: const Color(0xFF00A884), // WhatsApp green
                );
              },
            ),
          ),
        ],
      ),
      // Floating action button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A884), // WhatsApp green
        onPressed: () {
          // Navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LandingScreen()),
          );
        },
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
