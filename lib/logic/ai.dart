import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> aiGenerator(
  String prompt,
  List<String> conversationHistory, {
  required String apiKey,
  required String apiUrl,
  required String model,
}) async {
  final userPrompt = 'User: $prompt \n';
  conversationHistory.add(userPrompt); // Add user's prompt to the history

  final url = Uri.parse(apiUrl);
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    "model": model,
    "messages": conversationHistory
        .map((message) => {
              "role": message.startsWith("User:") ? "user" : "assistant",
              "content": message.substring(message.indexOf(":") + 2),
            })
        .toList(),
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final responseJson = jsonDecode(response.body);
    final choices = responseJson['choices'];

    if (choices == null || choices.isEmpty) {
      throw Exception('No choices found in the API response');
    }

    final generatedText = choices[0]['message']['content'];
    final assistantResponse = 'Assistant: $generatedText';
    conversationHistory
        .add(assistantResponse); // Add assistant's response to the history

    return generatedText;
  } else {
    final errorMessage =
        'Failed to generate text: ${response.statusCode} ${response.body}';
    throw Exception(errorMessage);
  }
}
