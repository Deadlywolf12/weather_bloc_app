import '../../models/chat_message_model.dart';

abstract class ChatEvent {}

class SendUserMessage extends ChatEvent {
  final String message;
  final bool isFromSuggestion;
  SendUserMessage(this.message, {this.isFromSuggestion = false});
}

class ChatStarted extends ChatEvent {}

class AppendMessages extends ChatEvent {
  final ChatMessage message;
  AppendMessages(this.message);
}
