import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/screens/widgets/chat_bubble.dart';
import 'package:weather_bloc_app/screens/widgets/new_chat.dart';

class ChatBoxBottomSheet extends StatelessWidget {
  final VoidCallback onClose;
  const ChatBoxBottomSheet({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chats = [];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
              ),
              ListTile(
                leading: Icon(Icons.arrow_back_ios_new),
                title: Center(
                  child: Text("Cloudie Chat",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                trailing: GestureDetector(
                    onTap: onClose, child: Icon(Icons.delete_outline_sharp)),
              ),
              const Divider(),
              Expanded(
                child: chats.isEmpty
                    ? buildWelcomeMessage()
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: 2,
                        itemBuilder: (context, index) => ChatBubble()
                            .createChatBubble(chats[index]['isBot'],
                                chats[index]['message'])),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
