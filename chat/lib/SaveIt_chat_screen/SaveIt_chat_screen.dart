// import 'package:flutter/material.dart';
// import 'widgets/chat_message.dart';
// import 'widgets/message_style.dart';
// import 'widgets/thinking_bubble.dart';
// import 'widgets/input_bar.dart';
// import 'widgets/service.dart';

// class SaveItChatScreen extends StatefulWidget {
//   const SaveItChatScreen({super.key});

//   @override
//   State<SaveItChatScreen> createState() => _SaveItChatScreenState();
// }

// class _SaveItChatScreenState extends State<SaveItChatScreen> {
//   final List<ChatMessage> _messages = <ChatMessage>[];
//   bool _isThinking = false;

//   Future<void> _onSend(String text) async {
//     final trimmed = text.trim();
//     if (trimmed.isEmpty) return;

//     setState(() {
//       _messages.insert(
//         0,
//         ChatMessage(text: trimmed, isMe: true, time: DateTime.now()),
//       );
//       _isThinking = true;
//     });

//     try {
//       final reply = await Service.sendMessage(trimmed);
//       setState(() {
//         _messages.insert(
//           0,
//           ChatMessage(
//             text: reply.isEmpty
//                 ? "Sorry, I couldn't understand. Could you rephrase?"
//                 : reply,
//             isMe: false,
//             time: DateTime.now(),
//           ),
//         );
//       });
//     } catch (e) {
//       setState(() {
//         _messages.insert(
//           0,
//           ChatMessage(
//             text: "Network error. Please try again.",
//             isMe: false,
//             time: DateTime.now(),
//           ),
//         );
//       });
//     } finally {
//       setState(() => _isThinking = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           titleSpacing: 0,
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 'SaveIt Chat',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 _isThinking ? 'Typing…' : 'Online',
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   color: _isThinking ? Colors.orange : Colors.green,
//                 ),
//               ),
//             ],
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new_rounded),
//             onPressed: () => Navigator.of(context).maybePop(),
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: true,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 itemCount: _messages.length + (_isThinking ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (_isThinking && index == 0) {
//                     return const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 6),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: ThinkingBubble(),
//                       ),
//                     );
//                   }
//                   final msg = _messages[_isThinking ? index - 1 : index];
//                   return MessageStyle(message: msg);
//                 },  
//               ),
//             ),
//             SafeArea(top: false, child: InputBar(onSend: _onSend)),
//           ],
//         ),
//       ),
//     );
//   }
// }











import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/chat_message.dart';
import 'widgets/message_style.dart';
import 'widgets/thinking_bubble.dart';
import 'widgets/input_bar.dart';
import 'widgets/service.dart';

class SaveItChatScreen extends StatefulWidget {
  const SaveItChatScreen({super.key});

  @override
  State<SaveItChatScreen> createState() => _SaveItChatScreenState();
}

class _SaveItChatScreenState extends State<SaveItChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('chat_history');
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      setState(() {
        _messages.clear();
        _messages.addAll(decoded.map((e) => ChatMessage(
              text: e['text'],
              isMe: e['isMe'],
              time: DateTime.parse(e['time']),
            )));
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _messages
        .map((m) => {
              'text': m.text,
              'isMe': m.isMe,
              'time': m.time.toIso8601String(),
            })
        .toList();
    await prefs.setString('chat_history', jsonEncode(data));
  }

  Future<void> _onSend(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        ChatMessage(text: trimmed, isMe: true, time: DateTime.now()),
      );
      _isThinking = true;
    });
    await _saveMessages();

    try {
      final reply = await Service.sendMessage(trimmed);
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: reply.isEmpty
                ? "Sorry, I couldn't understand. Could you rephrase?"
                : reply,
            isMe: false,
            time: DateTime.now(),
          ),
        );
      });
      await _saveMessages();
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: "Network error. Please try again.",
            isMe: false,
            time: DateTime.now(),
          ),
        );
      });
      await _saveMessages();
    } finally {
      setState(() => _isThinking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'SaveIt Chat',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                _isThinking ? 'Typing…' : 'Online',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _isThinking ? Colors.orange : Colors.green,
                    ),
              ),
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: _messages.length + (_isThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isThinking && index == 0) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ThinkingBubble(),
                      ),
                    );
                  }
                  final msg = _messages[_isThinking ? index - 1 : index];
                  return MessageStyle(message: msg);
                },
              ),
            ),
            SafeArea(top: false, child: InputBar(onSend: _onSend)),
          ],
        ),
      ),
    );
  }
}
