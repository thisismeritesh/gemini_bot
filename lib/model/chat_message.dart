enum Sender { user, bot }

class ChatMessage {
  final Sender sender;
  final String text;

  ChatMessage({required this.sender, required this.text});
}
