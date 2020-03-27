class ChatMessage {
  String sender;
  int time;
  String message;

  ChatMessage(Map<String, dynamic> data) {
    this.sender = data['sender'];
    this.time = data['time'];
    this.message = data['message'];
  }

  sendMessage({String message,String receiver}){
    
  }
}
