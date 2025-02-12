import 'package:chat_app/Model/country_model.dart';
import 'package:chat_app/Screens/country_screen.dart';
import 'package:chat_app/otp_service/request_otp.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String countryName = "India";
  String countryCode = "+91";
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111B21),
        actions: const [
          Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF111B21),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Enter your phone number",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                wordSpacing: 1,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "WhatsApp will need to verify your phone number.",
              style: TextStyle(color: Colors.grey),
            ),
            const Text(
              "Carrier charges may apply.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "What's my number?",
              style: TextStyle(
                color: Colors.cyan[800],
              ),
            ),
            const SizedBox(height: 15),
            countryCard(),
            const SizedBox(height: 5),
            numberField(),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
            const Spacer(),
            InkWell(
              onTap: () async {
                final phoneNumber = _controller.text.trim();
                if (phoneNumber.length < 10) {
                  setState(() {
                    _errorMessage =
                        "Please enter a valid 10-digit phone number.";
                  });
                  return;
                }
                setState(() {
                  _errorMessage = null; // Clear any previous error
                });

                // Call OTP Service
                await requestOtpService.requestOTP(
                  context: context,
                  phoneNumber: phoneNumber,
                  countryCode: countryCode,
                );
              },
              child: Container(
                height: 40,
                width: 70,
                color: Colors.tealAccent[400],
                child: const Center(
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget countryCard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CountryScreen(
              setCountryData: setCountryData,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.teal,
              width: 1.8,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  countryName,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.teal,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget numberField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 38,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 70,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.teal,
                  width: 1.8,
                ),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  "+",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  countryCode.substring(1),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          Container(
            width: MediaQuery.of(context).size.width / 1.5 - 100,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.teal,
                  width: 1.8,
                ),
              ),
            ),
            child: TextFormField(
              style: TextStyle(color: Colors.white,),
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8),
                hintText: "Phone number",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setCountryData(CountryModel countryModel) {
    setState(() {
      countryName = countryModel.name;
      countryCode = countryModel.code;
    });
    Navigator.pop(context);
  }
}
