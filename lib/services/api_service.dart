class ApiService {
  static final String baseUrl = "https://ai-app-backend-3.onrender.com";

  static Future<String> sendMessage(String prompt) async {
    // Replace this with actual backend API call
    await Future.delayed(Duration(seconds: 1));
    return '''
Here’s a simulated AI response for: "$prompt"

```python
def example():
    print("Hello World")
''';
}
}