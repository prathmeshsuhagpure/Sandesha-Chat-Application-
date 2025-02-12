import 'package:chat_app/Screens/login_screen.dart';
import 'package:chat_app/otp_service/verify_otp_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.number, required this.countryCode});

  final String number;
  final String countryCode;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? _errorMessage; // For displaying error messages
  final bool _isLoading = false; // To show a loading indicator during verification
  final OtpFieldController _otpController = OtpFieldController();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late String fullPhoneNumber;

  @override
  void initState() {
    super.initState();
    fullPhoneNumber = widget.countryCode + widget.number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Verify ${widget.countryCode} ${widget.number}",
          style: TextStyle(color: Colors.teal[800], fontSize: 16.5),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "We have sent an SMS with a code to ",
                    style: TextStyle(
                      color: Colors.teal[800],
                      fontSize: 16.5,
                    ),
                  ),
                  TextSpan(
                    text: "${widget.countryCode} ${widget.number}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " Wrong number?",
                    style: TextStyle(
                      color: Colors.cyan[800],
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            OTPTextField(
              controller: _otpController,
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 30,
              style: const TextStyle(fontSize: 17, color: Colors.white),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onChanged: (pin) {
                print(pin); // Optional: check the entered OTP
              },
              onCompleted: (pin) {
                VerifyOtpService.verifyOTP(
                  context: context,
                  phoneNumber: widget.number,
                  countryCode: widget.countryCode,
                  otp: pin,
                  onSuccess: () {
                    // Navigate to the next screen upon successful OTP verification
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                    secureStorage.write(
                        key: "userPhoneNumber", value: fullPhoneNumber);
                  },
                  onError: (errorMessage) {
                    setState(() {
                      _errorMessage = errorMessage;
                    });
                    print("error in login is$errorMessage");
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter 6-digit code",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 30),
            bottomButton(
              "Resend SMS",
              Icons.message,
              () async {
                setState(() => _errorMessage = null); // Clear previous error
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Resend OTP feature is under development."),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 1.5),
            const SizedBox(height: 12),
            bottomButton(
              "Call me",
              Icons.call,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Sorry! This feature is not available yet.",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.teal,
            size: 24,
          ),
          const SizedBox(width: 25),
          Text(
            text,
            style: const TextStyle(
              color: Colors.cyan,
              fontSize: 14.5,
            ),
          ),
        ],
      ),
    );
  }
}
