import 'package:camera/camera.dart';
import 'package:chat_app/Screens/camera_screen.dart';
import 'package:chat_app/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';
import 'otp_service/verify_otp_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await VerifyOtpService.getToken();
  cameras = await availableCameras();
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "OpenSans",
        primaryColor: const Color(0xFF111B21),
        //accentColor: Color(0xff128c7e),
        useMaterial3: true,
      ),
      /*home: FutureBuilder(
          future: _checkIfUserExists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data == false) {
              // means user does not exist
              _clearToken();
              return const SplashScreen();
            }
            return const LoginScreen();
          },
        ),*/
      home: const LoginScreen(),
    );
  }
}

Future<bool> _checkIfUserExists() async {
  final userExists = await VerifyOtpService.userExists();
  return userExists;
}

Future<void> _clearToken() async {
  await VerifyOtpService.clearToken();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const Center(
          child: Text("Hello"),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
