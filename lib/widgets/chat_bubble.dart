import 'package:flutter/material.dart';
import 'package:social_medial_sample_project/models/chat_model.dart';

class ChatBubble extends StatelessWidget {

  final ChatModel chatModel;
  final String currentUserID;

  const ChatBubble(this.chatModel, this.currentUserID, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(15),

          bottomLeft: chatModel.userID == currentUserID ? const Radius.circular(15) : Radius.zero,
          bottomRight: chatModel.userID == currentUserID ? Radius.zero : const Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: chatModel.userID == currentUserID ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "By ${chatModel.username}",
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            chatModel.message,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
