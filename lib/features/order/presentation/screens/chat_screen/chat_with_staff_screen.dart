import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/order/presentation/widgets/driver_tracking_map_item/chat_screen.dart';
import 'package:movemate/services/chat_services/data/chat_services.dart';
import 'package:movemate/services/chat_services/models/chat_model.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class ChatWithStaffScreen extends HookConsumerWidget {
  final String staffId;
  final String staffName;
  final StaffRole staffRole;
  final String bookingId;

  const ChatWithStaffScreen({
    Key? key,
    required this.staffId,
    required this.staffName,
    required this.staffRole,
    required this.bookingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatManager = ChatManager(
      bookingId: bookingId,
      currentUserId: ref.read(authProvider)!.id.toString() ,
      currentUserRole: 'customer',
    );

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.mainColor,
        backButtonColor: AssetsConstants.whiteColor,
        title: "Chat với $staffName",
      ),
      body: FutureBuilder<String>(
        future: chatManager.getOrCreateConversation(staffId, staffRole),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final conversationId = snapshot.data!;
          return ChatContent(
            conversationId: conversationId,
            chatManager: chatManager,
          );
        },
      ),
    );
  }
}

class ChatContent extends HookConsumerWidget {
  final String conversationId;
  final ChatManager chatManager;

  const ChatContent({
    Key? key,
    required this.conversationId,
    required this.chatManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageController = useTextEditingController();
    final messages = useStream(chatManager.getMessages(conversationId));

    return Column(
      children: [
        Expanded(
          child: messages.hasData
              ? ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.data!.length,
                  itemBuilder: (context, index) {
                    final message = messages.data![index];
                    final isSent = message.senderId == chatManager.currentUserId;
                    
                    return ChatMessage(
                      text: message.content,
                      time: _formatTimestamp(message.timestamp),
                      isSent: isSent,
                      // avatarUrl: !isSent ? message.senderAvatar : null,
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        ),
        ChatInputBox(
          onSendMessage: (content) async {
            if (content.trim().isNotEmpty) {
              await chatManager.sendMessage(conversationId, content);
              messageController.clear();
            }
          },
          controller: messageController,
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

// Modify ChatInputBox
class ChatInputBox extends StatelessWidget {
  final Function(String) onSendMessage;
  final TextEditingController controller;

  const ChatInputBox({
    Key? key,
    required this.onSendMessage,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          const Icon(Icons.add_circle, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.grey),
            onPressed: () => onSendMessage(controller.text),
          ),
        ],
      ),
    );
  }
}
