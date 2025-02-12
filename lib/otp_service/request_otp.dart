import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat_app/Screens/otp_screen.dart';

class requestOtpService {
  static Future<void> requestOTP({
    required BuildContext context,
    required String phoneNumber,
    required String countryCode,
  }) async {
    final String fullPhoneNumber = "$countryCode$phoneNumber";
    final String apiUrl = "http://192.168.98.145:5000/routes/generateOTP";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": fullPhoneNumber}),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              number: phoneNumber,
              countryCode: countryCode,
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? "Failed to send OTP. Try again.";
        showErrorDialog(context, error);
      }
    } catch (e) {
      showErrorDialog(context, "Something went wrong. Please try again.");
    }
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
