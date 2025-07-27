import 'dart:math';
import "package:flutter/material.dart";
import "package:flutter_chat_core/flutter_chat_core.dart";
import "package:flutter_chat_ui/flutter_chat_ui.dart";
import "package:flutter_gemini/flutter_gemini.dart";

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final _chatController = InMemoryChatController();
  Future<String> callAiAgent(String prompt) async {
    try {
      final response = await Gemini.instance.prompt(parts: [Part.text(prompt)]);
      if (response == null) {
        return "Can't connect to gemini at the moment";
      }
      print("inside print: ${response.output} ");
      return response.output ?? "No response from Gemini";
    } catch (e) {
      print("An error happened $e");
      return "An error happened: $e";
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: Color(0xffF1F0E9),
                child: IconButton(
                  color: Color(0xff0D4715),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              child: Chat(
                theme: ChatTheme.light(fontFamily: "Poppins"),
                chatController: _chatController,
                currentUserId: "user1",
                onMessageSend: (text) async {
                  _chatController.insertMessage(
                    TextMessage(
                      id: '${Random().nextInt(1000) + 1}',
                      authorId: "user1",
                      text: text,
                      createdAt: DateTime.now().toUtc(),
                    ),
                  );
                  try {
                    final response = await callAiAgent(text);
                    _chatController.insertMessage(
                      TextMessage(
                        id: '${Random().nextInt(1000) + 1}',
                        authorId: "gemini",
                        text: response,
                        createdAt: DateTime.now().toUtc(),
                      ),
                    );
                  } catch (e) {
                    print("Error happened: $e");
                  }
                },
                resolveUser: (UserID id) async {
                  return User(id: id, name: "Shahd Hossam");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
