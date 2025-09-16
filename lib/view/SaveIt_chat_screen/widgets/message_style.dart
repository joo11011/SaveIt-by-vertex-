import 'package:flutter/material.dart';
import 'chat_message.dart';

class MessageStyle extends StatelessWidget {
  final ChatMessage message;

  const MessageStyle({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final bg = isMe ? Colors.green : Colors.grey[200]; //-------------------
    final fg = isMe ? Colors.white : Colors.black87;

    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final radius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
          );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: bg, borderRadius: radius),
          child: Column(
            crossAxisAlignment: align,
            children: [
              Text(message.text, style: TextStyle(color: fg, fontSize: 15)),
              const SizedBox(height: 4),
              Text(
                "${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 11,
                  color: isMe ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
