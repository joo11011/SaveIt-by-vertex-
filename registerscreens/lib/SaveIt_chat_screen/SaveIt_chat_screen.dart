import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:savelt_app/view/SaveIt_chat_screen/widgets/message_style.dart';
import 'package:final_project/SaveIt_chat_screen/widgets/message_style.dart';

class SaveItChatScreen extends StatefulWidget {
  const SaveItChatScreen({super.key});

  @override
  State<SaveItChatScreen> createState() => _SaveItChatScreenState();
}

class _SaveItChatScreenState extends State<SaveItChatScreen> {
  static const String webhookUrl =
      'https://saveit-webhook.vercel.app/api/webhook';

  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isThinking = false;

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

    try {
      final payload = {
        "responseId": "temp-${DateTime.now().millisecondsSinceEpoch}",
        "queryResult": {
          "queryText": trimmed,
          "languageCode": "ar", // Dialogflow هيحدد intent
        },
      };

      final resp = await http.post(
        Uri.parse(webhookUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final reply = (data['fulfillmentText'] ?? '').toString().trim();

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
      } else {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              text: "Server error: ${resp.statusCode}",
              isMe: false,
              time: DateTime.now(),
            ),
          );
        });
      }
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
    } finally {
      setState(() => _isThinking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
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
                        child: _ThinkingBubble(),
                      ),
                    );
                  }
                  final msg = _messages[_isThinking ? index - 1 : index];
                  return MessageStyle(message: msg);
                },
              ),
            ),
            SafeArea(top: false, child: _InputBar(onSend: _onSend)),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('Thinking…', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _InputBar extends StatefulWidget {
  final Future<void> Function(String text) onSend;
  const _InputBar({required this.onSend});

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  final TextEditingController _ctrl = TextEditingController();
  bool _sending = false;

  Future<void> _handleSend() async {
    if (_sending) return;
    final txt = _ctrl.text.trim();
    if (txt.isEmpty) return;
    setState(() => _sending = true);
    await widget.onSend(txt);
    _ctrl.clear();
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Type your message…',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Ink(
            decoration: ShapeDecoration(
              color: _sending
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.primary,
              shape: const CircleBorder(),
            ),
            child: IconButton(
              onPressed: _sending ? null : _handleSend,
              icon: const Icon(Icons.send_rounded),
              color: Theme.of(context).colorScheme.onPrimary,
              tooltip: 'Send',
            ),
          ),
        ],
      ),
    );
  }
}
