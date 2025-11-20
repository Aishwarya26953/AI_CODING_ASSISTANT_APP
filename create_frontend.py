import os

# Base folder
base_dir = "frontend_flutter"
lib_dir = os.path.join(base_dir, "lib")
screens_dir = os.path.join(lib_dir, "screens")
widgets_dir = os.path.join(lib_dir, "widgets")
services_dir = os.path.join(lib_dir, "services")
assets_dir = os.path.join(base_dir, "assets")

# Create directories
for d in [lib_dir, screens_dir, widgets_dir, services_dir, assets_dir]:
    os.makedirs(d, exist_ok=True)

# Files with their content
files_content = {
    os.path.join(lib_dir, "main.dart"): """import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Coding Assistant',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: ChatScreen(),
    );
  }
}
""",

    os.path.join(screens_dir, "chat_screen.dart"): """import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  void sendMessage() async {
    if (_controller.text.isEmpty) return;
    final prompt = _controller.text;
    setState(() {
      messages.add({'user': prompt});
    });
    _controller.clear();
    final response = await ApiService.sendMessage(prompt);
    setState(() {
      messages.add({'ai': response});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Coding Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ChatBubble(message: msg);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: _controller),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: sendMessage)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
""",

    os.path.join(widgets_dir, "chat_bubble.dart"): """import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Map<String, String> message;
  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    String text = message['user'] ?? message['ai'] ?? '';
    bool isUser = message.containsKey('user');
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
""",

    os.path.join(services_dir, "api_service.dart"): """class ApiService {
  static Future<String> sendMessage(String prompt) async {
    // Replace with actual backend API call
    await Future.delayed(Duration(seconds: 1));
    return 'AI Response for: $prompt';
  }
}
""",

    os.path.join(base_dir, "pubspec.yaml"): """name: frontend_flutter
description: AI Coding Assistant Flutter App
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/
"""
}

# Create all files with content
for path, content in files_content.items():
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

print(f"✅ Flutter frontend structure created successfully in '{base_dir}' folder!")
