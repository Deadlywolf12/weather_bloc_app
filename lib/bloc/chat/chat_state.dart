import 'package:equatable/equatable.dart';
import '../../models/chat_message_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];

  get messages => null;
}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  const ChatLoaded(this.messages, {this.isTyping = false});

  @override
  List<Object?> get props => [messages, isTyping];
}

class ChatLoading extends ChatState {}
