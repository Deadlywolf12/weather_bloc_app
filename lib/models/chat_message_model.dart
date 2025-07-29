class ChatMessage {
  final bool isBot;
  final String message;
  final bool isLoading;

  ChatMessage({
    required this.isBot,
    required this.message,
    this.isLoading = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        isBot: json['isBot'],
        message: json['message'],
        isLoading: json['isLoading'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'isBot': isBot,
        'message': message,
        'isLoading': isLoading,
      };
}
