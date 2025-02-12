import 'dart:convert';
import 'package:chat_app/Custom%20UI/own_file_card.dart';
import 'package:chat_app/Custom%20UI/own_message_card.dart';
import 'package:chat_app/Custom%20UI/reply_card.dart';
import 'package:chat_app/Custom%20UI/reply_file_card.dart';
import 'package:chat_app/Model/chat_model.dart';
import 'package:chat_app/Model/message_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'camera_screen.dart';
import 'camera_view.dart';

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen(
      {super.key, required this.chatModel, required this.sourceChat});

  final ChatModel chatModel;
  final ChatModel sourceChat;

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  late final IO.Socket socket;
  bool sendButton = false;
  List<MessageModel> messages = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late XFile file;
  int popTime = 0;

  @override
  void initState() {
    super.initState();
    messages.clear();
    connectToSocket();
    fetchPreviousMessages(
        widget.sourceChat.id.toString(), widget.chatModel.id.toString());
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  void connectToSocket() {
    try {
      socket = IO.io(
        "http://192.168.98.145:5000", // Replace with your actual backend URL
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .build(),
      );

      socket.connect();

      socket.onConnect((_) {
        debugPrint("Connected to server");
        // Sign in the current user
        socket.emit("signIn", widget.sourceChat.id);
      });

      // Listen for incoming messages
      socket.on("receive_message", (msg) {
        debugPrint("Message received: $msg");

        if (mounted) {
          setState(() {
            messages.add(MessageModel(
              senderId: msg['senderId'],
              targetId: msg['targetId'],
              message: msg['content'],
              //type: msg['type'],
              //type: "destination",
              type: msg['senderId'] == widget.sourceChat.id
                  ? "source"
                  : "destination",
              time: DateTime.parse(msg['timestamp']),
            ));
          });
        }
      });
    } catch (e) {
      debugPrint("Socket connection error: $e");
    }
  }

  void sendMessage(
    String content,
    int sourceId,
    int targetId,
  ) {
    if (content.trim().isEmpty) return;

    final messageData = {
      "senderId": sourceId,
      "content": content,
      "targetId": targetId,
      "type": "text",
      "timestamp": DateTime.now().toIso8601String(),
    };
    try {
      // Emit the `send_message` event
      socket.emit("send_message", messageData);

      // Update the UI
      setState(() {
        messages.add(
          MessageModel(
            type: "source",
            message: content,
            time: DateTime.now(),
            senderId: sourceId.toString(),
            targetId: targetId.toString(),
          ),
        );
      });
      _messageController.clear();
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  Future<void> fetchPreviousMessages(String senderId, String targetId) async {
    debugPrint(
        "Fetching messages for senderId=$senderId and targetId=$targetId");

    const String baseUrl = "http://192.168.98.145:5000/routes/messages";

    // Construct the URL with query parameters
    final Uri url = Uri.parse(baseUrl).replace(queryParameters: {
      "senderId": senderId,
      "targetId": targetId,
    });

    try {
      // Retrieve the token (e.g., from secure storage or shared preferences)
      final String? token =
          await getToken(); // Replace `getToken` with your method for fetching the token

      if (token == null) {
        debugPrint("Error: Token is null");
        return;
      }

      // Perform the GET request with the Authorization header
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token", // Add the token here
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Update the messages list with the fetched data
        setState(() {
          messages = data.map((msg) {
            final bool isSource =
                msg['senderId'].toString() == widget.sourceChat.id.toString();
            debugPrint(
                "Message from ${msg['senderId']}, current user ${widget.sourceChat.id}, isSource: $isSource");

            return MessageModel(
              senderId: msg['senderId'].toString(),
              targetId: msg['targetId'].toString(),
              message: msg['content'],
              type: isSource ? "source" : "destination",
              time: msg["timestamp"] != null
                  ? DateTime.parse(msg['timestamp'])
                  : DateTime.now(),
              path: msg['path'] ?? '',
            );
          }).toList();
        });
        // Auto-scroll to the latest message
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      } else {
        debugPrint("Error fetching messages: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    }
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: "token");
  }

  void setMessage({
    required String type,
    required String message,
    required String path,
  }) {
    MessageModel messageModel = MessageModel(
      type: type,
      message: message,
      path: path,
      time: DateTime.now(),
      senderId: widget.sourceChat.id.toString(),
      targetId: widget.chatModel.id.toString(),
    );

    setState(() {
      messages.add(messageModel);
    });

    // Auto-scroll to the latest message
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> onImageSend(String path, String message) async {
    debugPrint("Image path: $path, Message: $message");

    for (int i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });

    try {
      final String? token = await getToken();
      if (token == null) {
        debugPrint("Error token is null");
        return;
      }

      var request = http.MultipartRequest(
          "POST", Uri.parse("http://192.168.98.145:5000/routes/addImage"));

      request.fields.addAll({
        "senderId": widget.sourceChat.id.toString(),
        "targetId": widget.chatModel.id.toString(),
        "message": message,
      });

      request.files.add(await http.MultipartFile.fromPath("img", path));
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Content-type": "multipart/form-data",
      });

      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(httpResponse.body);
        final String imagePath = data["path"] ?? "";

        if (imagePath.isEmpty) {
          throw Exception("Server returned empty image path");
        }

        setMessage(
          type: "source",
          message: message,
          path: imagePath,
        );

        socket.emit("send_message", {
          "senderId": widget.sourceChat.id,
          "targetId": widget.chatModel.id,
          "content": message,
          "path": imagePath,
          "type": "image",
          "timestamp": DateTime.now().toIso8601String(),
        });
      } else {
        debugPrint(
            "Image upload failed. please try again. Status code: ${response.statusCode}");
        throw Exception("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error sending image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sending image: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    socket.off("receive_message");
    socket.disconnect();
    focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*Image.asset(
          "assets/whatsapp_background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),*/
        Scaffold(
          backgroundColor: const Color(0xFF111B21),
          appBar: AppBar(
            backgroundColor: const Color(0xFF111B21),
            leadingWidth: 70,
            titleSpacing: 0,
            leading: InkWell(
              onTap: Navigator.of(context).pop,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueGrey,
                    child: SvgPicture.asset(
                      widget.chatModel.isGroup
                          ? "assets/group_icon.svg"
                          : "assets/person_icon.svg",
                      color: Colors.white,
                      height: 35,
                      width: 35,
                    ),
                  )
                ],
              ),
            ),
            title: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                  margin: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatModel.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Last seen today at 12:45",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.videocam,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.call,
                  color: Colors.white,
                ),
              ),
              PopupMenuButton<String>(
                iconColor: Colors.white,
                color: Colors.black,
                onSelected: (value) {
                  //print(value);
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                        value: "View Contact",
                        child: Text(
                          "View Contact",
                          style: TextStyle(color: Colors.white),
                        )),
                    const PopupMenuItem(
                        value: "Search",
                        child: Text("Search",
                            style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(
                        value: "Add to list",
                        child: Text("Add to list",
                            style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(
                        value: "Media, links and docs",
                        child: Text("Media, links and docs",
                            style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(
                        value: "Mute notifications",
                        child: Text("Mute notifications",
                            style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(
                        value: "Disappearing messages",
                        child: Text("Disappearing messages",
                            style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(
                        value: "Chat theme",
                        child: Text("Chat theme",
                            style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(
                        value: "more",
                        child: Text("more",
                            style: TextStyle(color: Colors.white))),
                  ];
                },
              ),
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Container(
                            height: 70,
                          );
                        }

                        final message = messages[index];

                        // Check if the message is from the source or a reply
                        if (message.type == "source") {
                          if (message.path.isNotEmpty) {
                            // File message from the source
                            return OwnFileCard(
                              path: message.path,
                              message: message.message,
                              time: message.time
                                  .toString(), // Adjust as per widget requirements
                            );
                          } else {
                            // Text message from the source
                            return OwnMessageCard(
                              message: message.message,
                              time: message.time
                                  .toString(), // Adjust as per widget requirements
                            );
                          }
                        } else {
                          if (message.path.isNotEmpty) {
                            // File message in reply
                            return ReplyFileCard(
                              path: message.path,
                              message: message.message,
                              time: message.time
                                  .toString(), // Adjust as per widget requirements
                            );
                          } else {
                            // Text message in reply
                            return ReplyCard(
                              message: message.message,
                              time: message.time
                                  .toString(), // Adjust as per widget requirements
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  //color: Colors.grey[600],
                                  color: const Color(0xff181a1b),
                                  margin: const EdgeInsets.only(
                                    left: 2,
                                    right: 2,
                                    bottom: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  elevation: 8,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    focusNode: focusNode,
                                    controller: _messageController,
                                    keyboardType: TextInputType.multiline,
                                    textAlignVertical: TextAlignVertical.center,
                                    maxLines: 5,
                                    minLines: 1,
                                    cursorColor: Colors.grey,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Message",
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = false;
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.emoji_emotions,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (builder) => Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom,
                                                  ),
                                                  child: bottomSheet(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.attach_file,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.currency_rupee_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                popTime = 2;
                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CameraScreen(
                                                    onImageSend: onImageSend,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      contentPadding: const EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 2,
                                  right: 5,
                                  bottom: 10,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: const Color(0xff128c7e),
                                  radius: 25,
                                  child: IconButton(
                                    onPressed: () {
                                      if (sendButton) {
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                        sendMessage(
                                          _messageController.text,
                                          widget.sourceChat.id,
                                          widget.chatModel.id,
                                        );
                                        _messageController.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      sendButton ? Icons.send : Icons.mic,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.of(context).pop();
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(onEmojiSelected: (category, emoji) {
      setState(() {
        _messageController.text = _messageController.text + emoji.emoji;
      });
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 235, // Adjust the height as per your UI needs
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0xff181a1b),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                iconCreation(
                  Icons.insert_drive_file,
                  Colors.black,
                  "Document",
                  Colors.indigo,
                  () {},
                ),
                iconCreation(
                  Icons.camera_alt,
                  Colors.black,
                  "Camera",
                  Colors.red,
                  () {
                    setState(() {
                      popTime = 3;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          onImageSend: onImageSend,
                        ),
                      ),
                    );
                  },
                ),
                iconCreation(
                  Icons.location_on,
                  Colors.black,
                  "Location",
                  Colors.green,
                  () {},
                ),
                iconCreation(
                  Icons.person,
                  Colors.black,
                  "Contact",
                  Colors.blue,
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                iconCreation(
                  Icons.browse_gallery,
                  Colors.black,
                  "Gallery",
                  Colors.purple,
                  () async {
                    try {
                      setState(() {
                        popTime = 2;
                      });
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          file = pickedFile;
                        });
                        print("File selected: ${file.path}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraView(
                                    path: file.path,
                                    onImageSend: onImageSend,
                                  )),
                        );
                      } else {
                        debugPrint("No file selected");
                      }
                    } catch (e) {
                      debugPrint("Error picking file: $e");
                    }
                  },
                ),
                iconCreation(
                  Icons.headphones,
                  Colors.black,
                  "Audio",
                  Colors.orange,
                  () {},
                ),
                iconCreation(
                  Icons.poll,
                  Colors.black,
                  "Poll",
                  Colors.yellow,
                  () {},
                ),
                iconCreation(
                  Icons.currency_rupee,
                  Colors.black,
                  "Payment",
                  Colors.cyan,
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, Color color, String text, Color iconColor,
      VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              color: iconColor,
              icon,
              size: 29,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
