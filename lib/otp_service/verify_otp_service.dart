import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class VerifyOtpService {
  static Future<void> verifyOTP({
    required BuildContext context,
    required String phoneNumber,
    required String countryCode,
    required String otp,
    required VoidCallback onSuccess,
    required void Function(String errorMessage) onError,
  }) async {
    final String fullPhoneNumber = "$countryCode$phoneNumber";
    const String apiUrl = "http://192.168.98.145:5000/routes/verifyOTP";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": fullPhoneNumber, "otp": otp}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Save token locally
        final token = responseData['token'];
        if (token != null) {
          await _saveToken(token);
        }

        // Save user details locally if available
        final userJson = {
          'phone': fullPhoneNumber,
          'name': responseData['name'] ?? "", // Name may be optional
          'createdAt':
              responseData['createdAt'] ?? DateTime.now().toIso8601String(),
        };

        await _saveUserDetails(userJson);

        // Call success callback
        onSuccess();
      } else {
        // Parse error response and call error callback
        final errorResponse = jsonDecode(response.body);
        onError(errorResponse['message'] ?? "Failed to verify OTP.");
      }
    } catch (e) {
      // Handle network or other errors
      onError("Something went wrong. Please try again.");
    }
  }

  // Save token to local storage
  static Future<void> _saveToken(String token) async {
    secureStorage.write(key: "token", value: token);
  }

  // Save user details to local storage
  static Future<void> _saveUserDetails(Map<String, dynamic> userDetails) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userDetails', jsonEncode(userDetails));
  }

  // Retrieve user details from local storage
  /*static Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userDetails');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }*/

  // Retrieve token from local storage
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Clear token and user details (for logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userDetails');
    await secureStorage.delete(key: "token");
    await secureStorage.delete(key: "userPhoneNumber");
  }

  static Future<bool> userExists() async {
    const url = "http://192.168.98.145:5000/routes/user-exists";
    try {
      String? phoneNumber = await getUserPhoneNumber();
      if (phoneNumber == null) {
        debugPrint("Error: phone number is null");
        return false;
      }
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneNumber}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["exists"] ?? false;
      } else {
        debugPrint("Failed to check user: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error checking if user exists: $e");
      return false;
    }
  }

  static Future<String?> getUserPhoneNumber() async {
    return await secureStorage.read(key: 'userPhoneNumber');
  }

  static Future<void> clearToken() async {
    await secureStorage.delete(key: 'token');
  }
}
