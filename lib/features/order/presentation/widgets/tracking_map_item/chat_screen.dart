import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        backgroundColor: AssetsConstants.mainColor,
        backButtonColor: AssetsConstants.whiteColor,
        title: "liên hệ với nhân viên",
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: const [
                ChatMessage(
                  text: 'Good Evening!',
                  time: '8:29 pm',
                  isSent: false,
                  avatarUrl:
                      'https://storage.googleapis.com/a1aa/image/n7jzMyRlCVo2Nx7WnG64D1lehgO4TfdWOeIXOarpLC6qaZhnA.jpg',
                ),
                ChatMessage(
                  text: 'Welcome to Car2go Customer Service',
                  time: '8:29 pm',
                  isSent: false,
                  avatarUrl:
                      'https://storage.googleapis.com/a1aa/image/n7jzMyRlCVo2Nx7WnG64D1lehgO4TfdWOeIXOarpLC6qaZhnA.jpg',
                ),
                ChatMessage(
                  text: 'Welcome to Car2go Customer Service',
                  time: '8:29 pm',
                  isSent: true,
                ),
                ChatMessage(
                  text: 'Welcome to Car2go Customer Service',
                  time: 'Just now',
                  isSent: true,
                ),
              ],
            ),
          ),
          const ChatInputBox(),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String time;
  final bool isSent;
  final String? avatarUrl;

  const ChatMessage({
    super.key,
    required this.text,
    required this.time,
    required this.isSent,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSent && avatarUrl != null)
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl!),
          ),
        if (!isSent) const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 5),
                constraints: const BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                  color: isSent ? Colors.cyan[50] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  border: isSent ? Border.all(color: Colors.orange) : null,
                ),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        if (isSent) const SizedBox(width: 10),
      ],
    );
  }
}

class ChatInputBox extends StatelessWidget {
  const ChatInputBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: const Row(
        children: [
          Icon(Icons.add_circle, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.send, color: Colors.grey),
        ],
      ),
    );
  }
}
