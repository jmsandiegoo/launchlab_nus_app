import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: const [
      SizedBox(
        height: 200,
      ),
      Text("Chat Page"),
    ]));
  }
}
