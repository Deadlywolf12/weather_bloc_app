import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_app/annimations/typing_animator.dart';
import 'package:weather_bloc_app/bloc/chat/chat_bloc.dart';
import 'package:weather_bloc_app/bloc/chat/chat_event.dart';
import 'package:weather_bloc_app/bloc/chat/chat_state.dart';
import 'package:weather_bloc_app/models/chat_message_model.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/screens/widgets/alert_box.dart';
import 'package:weather_bloc_app/screens/widgets/chat_bubble.dart';
import 'package:weather_bloc_app/screens/widgets/new_chat.dart';

class ChatBoxBottomSheet extends StatefulWidget {
  final VoidCallback onClose;

  const ChatBoxBottomSheet({super.key, required this.onClose});

  @override
  State<ChatBoxBottomSheet> createState() => _ChatBoxBottomSheetState();
}

class _ChatBoxBottomSheetState extends State<ChatBoxBottomSheet> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _controller = TextEditingController();

  final ScrollController _chatScrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 5,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        ListTile(
          leading: GestureDetector(
              onTap: widget.onClose,
              child: const Icon(Icons.arrow_back_ios_new)),
          title: const Center(
            child: Text(
              "Cloudie Chat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              AlertBox(
                title: "Delete Chat",
                content: "Are you sure you want to delete chat",
                btn1: "Cancel",
                btn2: "Delete",
                onBtn1Pressed: () {
                  Navigator.of(context).pop();
                },
                onBtn2Pressed: () {
                  context.read<ChatBloc>().add(ChatStarted());
                  Navigator.of(context).pop();
                },
              ).showCustomAlertDialog(context);
            },
            child: const Icon(Icons.delete_outline_sharp),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildChatArea(List<ChatMessage> chat, bool isTyping) {
    if (chat.isEmpty) return const NewChat();

    return ListView.builder(
      controller: _chatScrollController,
      itemCount: isTyping ? chat.length + 1 : chat.length,
      itemBuilder: (context, index) {
        if (index < chat.length) {
          final msg = chat[index];
          return ChatBubble().createChatBubble(msg.isBot, msg.message);
        } else {
          return ChatBubble()
              .createChatBubble(true, "", child: TypingIndicator());
        }
      },
    );
  }

  Widget _buildInputArea(bool isDisabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !isDisabled,
              decoration: InputDecoration(
                hintText:
                    isDisabled ? "Bot is replying..." : "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isDisabled
                ? null
                : () {
                    final userMessage = _controller.text.trim();
                    if (userMessage.isEmpty) return;

                    context.read<ChatBloc>().add(SendUserMessage(userMessage));
                    _controller.clear();
                  },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            List<ChatMessage> chat = [];
            bool isDisabled = false;

            if (state is ChatLoaded) {
              chat = state.messages;
              isDisabled = state.isTyping;

              // scroll to bottom on new message
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            }

            return Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 37, 25, 47),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: chat.isEmpty
                        ? const NewChat()
                        : ListView.builder(
                            controller: scrollController,
                            itemCount:
                                isDisabled ? chat.length + 1 : chat.length,
                            itemBuilder: (context, index) {
                              if (index < chat.length) {
                                final msg = chat[index];
                                return ChatBubble()
                                    .createChatBubble(msg.isBot, msg.message);
                              } else {
                                return ChatBubble().createChatBubble(true, "",
                                    child: TypingIndicator());
                              }
                            },
                          ),
                  ),
                  _buildInputArea(isDisabled),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
