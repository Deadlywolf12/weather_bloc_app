import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bloc_app/bloc/chat/chat_event.dart';
import 'package:weather_bloc_app/bloc/chat/chat_state.dart';
import 'package:weather_bloc_app/models/chat_message_model.dart';

import 'package:weather_bloc_app/services/chat_services/webhook_calls.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  double lat = 0.0;
  double lon = 0.0;
  ChatBloc() : super(ChatInitial()) {
    on<SendUserMessage>(_onSendMessage);
    on<ChatStarted>(_onChatStarted);
    on<AppendMessages>(_onAppendMessages);
    _loadCoordinates();
  }

  Future<void> _loadCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    lat = prefs.getDouble('lat') ?? 0.0;
    lon = prefs.getDouble('long') ?? 0.0;
  }

  Future<void> _onAppendMessages(
      AppendMessages event, Emitter<ChatState> emit) async {
    final oldMessages =
        state is ChatLoaded ? (state as ChatLoaded).messages : [];

    final newMessages = List<ChatMessage>.from(oldMessages)
      ..addAll([event.message]);

    emit(ChatLoaded(newMessages));
  }

  Future<void> _onSendMessage(
      SendUserMessage event, Emitter<ChatState> emit) async {
    final oldMessages =
        state is ChatLoaded ? (state as ChatLoaded).messages : [];

    final newMessages = List<ChatMessage>.from(oldMessages)
      ..add(ChatMessage(isBot: false, message: event.message));

    emit(ChatLoaded(newMessages, isTyping: true));

    await Future.delayed(const Duration(seconds: 2));

    final botReply = await getBotReplyFromWebhook(event.message);

    final updatedMessages = List<ChatMessage>.from(oldMessages)
      ..add(ChatMessage(isBot: false, message: event.message))
      ..add(ChatMessage(isBot: true, message: botReply));

    emit(ChatLoaded(updatedMessages, isTyping: false));
  }

  Future<void> _onChatStarted(
      ChatStarted event, Emitter<ChatState> emit) async {
    emit(ChatLoaded([])); // Empty initial chat list
  }

  Future<String> getBotReplyFromWebhook(String message) async {
    return WeatherBotService(lat: lat, long: lon).sendReq(message);
  }
}
