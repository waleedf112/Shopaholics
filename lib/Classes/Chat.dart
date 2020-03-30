class ChatMessage {
  String sender;
  String message;

  ChatMessage(Map<String, dynamic> data) {
    this.sender = data['sender'];
    this.message = data['message'];
  }
}
