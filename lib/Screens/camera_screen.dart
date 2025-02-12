import 'dart:math';
import 'package:camera/camera.dart';
import 'package:chat_app/Screens/camera_view.dart';
import 'package:chat_app/Screens/video_view.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    required this.onImageSend,
  });

  final Function onImageSend;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;

  late Future<void> cameraValue;
  bool isRecording = false;
  String videoPath = "";
  bool flash = false;
  bool isCameraFront = true;
  double transform = 0;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: CameraPreview(_cameraController));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            flash = !flash;
                          });
                          flash
                              ? _cameraController.setFlashMode(FlashMode.torch)
                              : _cameraController.setFlashMode(FlashMode.off);
                        },
                        icon: Icon(
                          flash ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () async {
                          try {
                            await _cameraController.startVideoRecording();
                            setState(() {
                              isRecording = true;
                            });
                          } catch (e) {
                            print("Error starting video recording: $e");
                          }
                        },
                        onLongPressUp: () async {
                          XFile videoPath =
                              await _cameraController.stopVideoRecording();
                          setState(() {
                            isRecording = false;
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => VideoView(
                                      videoPath: videoPath.path,
                                    )),
                          );
                        },
                        onTap: () {
                          if (!isRecording) {
                            takePhoto(context);
                          }
                        },
                        child: isRecording
                            ? const Icon(
                                Icons.radio_button_on,
                                color: Colors.red,
                                size: 70,
                              )
                            : const Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70,
                              ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            isCameraFront = !isCameraFront;
                            transform = transform + pi;
                          });
                          int cameraPos = isCameraFront ? 0 : 1;
                          _cameraController = CameraController(
                              cameras[cameraPos], ResolutionPreset.high);
                          cameraValue = _cameraController.initialize();
                        },
                        icon: Transform.rotate(
                          angle: transform,
                          child: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Hold for video, tap for photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void takePhoto(BuildContext context) async {
    try {
      XFile path = await _cameraController.takePicture();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraView(
            path: path.path,
            onImageSend: widget.onImageSend,
          ),
        ),
      );
    } catch (e) {
      print("Error taking photo: $e");
    }
  }
}
