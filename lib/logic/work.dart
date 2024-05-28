import 'dart:convert';

import 'package:flutter/material.dart';

import '../counst.dart';
import '../model/file.dart';
import 'ai.dart';

const apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
const model = 'llama3-8b-8192';

final List<String> conversationHistory = [];

Future<void> agi() async {
  // Your prompt
  const prompt = 'a snake game in flutter';
  debugPrint('Your Prompt: $prompt \n');

  const planner =
      '''Provide a high-level, conceptual, step-by-step guide for $prompt, 
      In the first step, set up any required constants or configuration variables 
      that needed for this project and each step after that is builds upon 
      the previous, culminating in the main entry point to be the last, 
      but no actual code implementation and no Example.
  ''';

  final plannerResponse = await aiGenerator(planner, conversationHistory,
      apiKey: apiKey, apiUrl: apiUrl, model: model);
  debugPrint("Planning @ : $plannerResponse \n");
  var json = '''
  Based on the previous high-level guide, list the required code files needed 
  to implement the project, without including actual code or examples.
  List them out in a JSON object with the following structure like this for me:
'''
      ''' {
	          "files": [
	          	"file1.txt",
	          	"file2.txt",
              "file3.txt",

              "main file",
	          ]
          }'''
      "\nDon't add any additional text to your response"
      // "\nAnd don't for get to add the closing curly brace at the end"
      ;
  var jsonResponse = await aiGenerator(json, conversationHistory,
      apiKey: apiKey, apiUrl: apiUrl, model: model);
  debugPrint("# # # Json Data: $jsonResponse \n");

  Map<String, dynamic> jsonData = jsonDecode(jsonResponse);
  FilesModel filesModel = FilesModel.fromJson(jsonData);

  int totalFiles = filesModel.files.length;
  debugPrint('Total Files Need For This Project: $totalFiles Files \n');

//the code loop
  for (String file in filesModel.files) {
    String cont = '''Provide a fully functional implementation for the $file
    code file, without additional comments or explanations. 
    Also without triple backticks (```) or (```dart) at the beginning and 
    the and of the code And make sure to import the correct package
''';
    // String string = file == filesModel.files[0]
    //     ? "Let start with $file. Only generate the code, without (```) or (```dart)"
    //     : "Then $file. Only generate the code, without (```) or (```dart)";
    var code = await aiGenerator(cont, conversationHistory,
        apiKey: apiKey, apiUrl: apiUrl, model: model);
    debugPrint("Code for $file:\n$code");
    await Future.delayed(const Duration(seconds: 4));
    debugPrint("Done");
    // break;
  }
  var ask = await aiGenerator(
      "Can you discribe what are we just doing?", conversationHistory,
      apiKey: apiKey, apiUrl: apiUrl, model: model);
  debugPrint(ask);

// push to github
//     try {
//       const githubName = 'BiutifullMe';
//       const repoName = 'aggi';
//       final path = "lib/$fileName";
//       final newContent = code;
//       const commitMessage = 'Create file content';
//       await updateOrCreateFile(
//           githubName, repoName, path, newContent, commitMessage);
//       debugPrint("updating \n $code");
//     } catch (e) {
//       debugPrint('Error: $e \n');
//     }
  debugPrint('Conversation History: \n');
  for (final message in conversationHistory) {
    debugPrint(message);
  }
}
