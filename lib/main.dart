import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: ChatScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: toggleTheme,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;

  ChatScreen({required this.isDarkMode, required this.onThemeToggle});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final List<String> _history = [];

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": message});
      _history.add(message);
    });

    try {
      // ✅ USE YOUR RENDER BACKEND URL
      final String baseUrl = "https://ai-app-backend-3.onrender.com";
      final url = Uri.parse('$baseUrl/ai/ai/chat');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['response'] ?? "No response";
        setState(() {
          _messages.add({"role": "ai", "text": aiResponse});
        });
      } else {
        setState(() {
          _messages.add({"role": "ai", "text": "Error: ${response.statusCode}"});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "ai", "text": "Exception: $e"});
      });
    }

    _controller.clear();
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Code copied!")));
  }

  bool _containsCode(String text) {
    return text.contains("```");
  }

  List<Widget> _buildMessageContent(String text, bool isDarkMode) {
    List<Widget> widgets = [];
    final parts = text.split("```");

    for (int i = 0; i < parts.length; i++) {
      if (i.isOdd) {
        widgets.add(
          Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      parts[i],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: isDarkMode ? Colors.greenAccent : Colors.black,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, size: 18),
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  onPressed: () => copyToClipboard(parts[i]),
                ),
              ],
            ),
          ),
        );
      } else if (parts[i].trim().isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              parts[i].trim(),
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chat")),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Center(
                child: Text(
                  'Settings',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            SwitchListTile(
              title: Text("Dark Mode"),
              value: widget.isDarkMode,
              onChanged: widget.onThemeToggle,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Chat History"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatHistoryScreen(history: _history),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                final text = msg["text"] ?? "";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blueAccent
                          : (widget.isDarkMode
                              ? Colors.grey[850]
                              : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildMessageContent(text, widget.isDarkMode),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      filled: true,
                      fillColor:
                          widget.isDarkMode ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatHistoryScreen extends StatefulWidget {
  final List<String> history;
  ChatHistoryScreen({required this.history});

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  void deleteHistoryItem(int index) {
    setState(() {
      widget.history.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat History")),
      body: widget.history.isEmpty
          ? Center(child: Text("No chat history yet."))
          : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(widget.history[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => deleteHistoryItem(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
