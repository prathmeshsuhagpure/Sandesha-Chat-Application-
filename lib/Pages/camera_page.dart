import 'package:chat_app/Screens/camera_screen.dart';
import 'package:flutter/material.dart';
class CameraPage extends StatelessWidget {
  const CameraPage({super.key,});


  @override
  Widget build(BuildContext context) {
    return CameraScreen(onImageSend: (image){
      print("Image sent: $image");
    },);
  }
}
