import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../services/gemini_service.dart';

class GeminiProvider extends ChangeNotifier {
  // Initialize the Generative Model
  static GenerativeModel _initModel() {
    // Use your own API key here
    String key = "";
    if (key.isEmpty) {
      throw Exception('GEMINI_API_KEY not found');
    }
    return GenerativeModel(model: 'gemini-pro', apiKey: key);
  }

  static final _geminiService = GeminiService(model: _initModel());

  // Properties
  String? response;
  bool isLoading = false;

  // List to manage chat messages
  List<Map<String, String>> chatMessages = [];

  // Method to generate content from text
  Future<void> generateContentFromText({required String prompt}) async {
    isLoading = true;
    notifyListeners();

    // Add the user's message to the chat history
    chatMessages.add({
      'sender': 'user',
      'text': prompt,
    });
    notifyListeners();

    response = null;
    try {
      // Fetch response from the AI model
      response = await _geminiService.generateContentFromText(prompt: prompt);

      // Add the AI's response to the chat history
      chatMessages.add({
        'sender': 'ai',
        'text': response ?? 'Error: No response from AI',
      });
    } catch (e) {
      // Handle any errors and add an error message to the chat history
      chatMessages.add({
        'sender': 'ai',
        'text': 'Error: ${e.toString()}',
      });
    }

    isLoading = false;
    notifyListeners();
  }

  // Method to generate content from an image
  Future<void> generateContentFromImage({
    required String prompt,
    required Uint8List bytes,
  }) async {
    isLoading = true;
    notifyListeners();

    // Add the user's prompt to the chat history
    chatMessages.add({
      'sender': 'user',
      'text': prompt,
    });
    notifyListeners();

    response = null;
    try {
      // Create data part for the image
      final dataPart = DataPart('image/jpeg', bytes);

      // Fetch response from the AI model
      response = await _geminiService.generateContentFromImage(
        prompt: prompt,
        dataPart: dataPart,
      );

      // Add the AI's response to the chat history
      chatMessages.add({
        'sender': 'ai',
        'text': response ?? 'Error: No response from AI',
      });
    } catch (e) {
      // Handle any errors and add an error message to the chat history
      chatMessages.add({
        'sender': 'ai',
        'text': 'Error: ${e.toString()}',
      });
    }

    isLoading = false;
    notifyListeners();
  }

  // Method to reset the chat
  void reset() {
    chatMessages.clear();
    response = null;
    isLoading = false;
    notifyListeners();
  }
}