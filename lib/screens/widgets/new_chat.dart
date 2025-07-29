import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_app/bloc/chat/chat_bloc.dart';
import 'package:weather_bloc_app/bloc/chat/chat_event.dart';
import 'package:weather_bloc_app/bloc/chat/chat_state.dart';
import 'package:weather_bloc_app/models/chat_message_model.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/screens/widgets/chat_bubble.dart';

class NewChat extends StatefulWidget {
  const NewChat({super.key});

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  bool _hasInteracted = false;

  void _handleSuggestion(String label) {
    if (!_hasInteracted) {
      setState(() => _hasInteracted = true);
    }

    // Dispatch to Bloc
    context.read<ChatBloc>().add(
          SendUserMessage(label, isFromSuggestion: true),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            final messages = state is ChatLoaded ? state.messages : [];

            return Expanded(
              child: messages.isEmpty && !_hasInteracted
                  ? _buildWelcomeMessage()
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatBubble().createChatBubble(
                          message.isBot,
                          message.message,
                          // isLoading: message.isLoading,
                        );
                      },
                    ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/chatbot.png', width: 40),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Hey! I'm Cloudie 👋\nHow can I help you today?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "You can try asking:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              _suggestionChip("Best time to walk?"),
              _suggestionChip("Will it rain today?"),
              _suggestionChip("5-day forecast"),
              _suggestionChip("What's the temperature?"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _suggestionChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () => _handleSuggestion(label),
      backgroundColor: AppColors.tiles,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}
