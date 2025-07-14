import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gemini_bot/model/chat_message.dart';

part 'chat_message_provider.g.dart';

@riverpod
class ChatMessageProvider extends _$ChatMessageProvider{
  @override
  List<ChatMessage> build()=>[];
    final String apiUrl = "https://gemini-bot-u61c.onrender.com/generate";
     Future<void> sendMessage(String userText) async {
    if (userText.trim().isEmpty) return;

    state = [...state, ChatMessage(sender: Sender.user, text: userText)];

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": userText, "max_length": 100}),
      );

      if (response.statusCode == 200) {
        final reply = jsonDecode(response.body)["response"];
        state = [...state, ChatMessage(sender: Sender.bot, text: reply)];
      } else {
        state = [...state, ChatMessage(sender: Sender.bot, text: "❌ Error from server.")];
      }
    } catch (e) {
      state = [...state, ChatMessage(sender: Sender.bot, text: "⚠️ Network error.")];
    }
  }
}