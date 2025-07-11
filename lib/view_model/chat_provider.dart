//== lib/view_models/chat_provider.dart ==
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/chat_message.dart';

final chatProvider = StateNotifierProvider<ChatViewModel, List<ChatMessage>>(
      (ref) => ChatViewModel(),
);

class ChatViewModel extends StateNotifier<List<ChatMessage>> {
  ChatViewModel() : super([]);

  final String apiUrl = "http://172.16.147.244:8000/generate"; // Replace with your deployed Render URL

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