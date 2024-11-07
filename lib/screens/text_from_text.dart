import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gemini_provider.dart';


class TextFromTextScreen extends StatelessWidget {
  const TextFromTextScreen({super.key});
  static final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final geminiProvider = Provider.of<GeminiProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        geminiProvider.reset();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gemini AI ✨'),
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Chat History
                Expanded(
                  child: ListView.builder(
                    itemCount: geminiProvider.chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = geminiProvider.chatMessages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: message['sender'] == 'user'
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            // Label for user or AI
                            Text(
                              message['sender'] == 'user'
                                  ? "You: ${message['text']}"
                                  : "AI: ${message['text']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Input Field and Send Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your prompt here...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            geminiProvider.generateContentFromText(
                              prompt: _textController.text,
                            );
                            _textController.clear();
                          }
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Centered Loading Indicator
            if (geminiProvider.isLoading)
              Center(
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
