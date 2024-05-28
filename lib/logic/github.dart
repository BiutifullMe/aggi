import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../counst.dart';

Future<void> updateOrCreateFile(
  String owner,
  String repo,
  String path,
  String newContent,
  String commitMessage, {
  String branch = 'main',
}) async {
  final url = Uri.https('api.github.com', '/repos/$owner/$repo/contents/$path');
  String fileSha;

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $githubToken',
        'Accept': 'application/vnd.github+json',
      },
    );

    if (response.statusCode == 200) {
      // File exists
      final Map<String, dynamic> data = jsonDecode(response.body);
      fileSha = data['sha'];
    } else if (response.statusCode == 404) {
      // File doesn't exist, create a new file
      final createResponse = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $githubToken',
          'Accept': 'application/vnd.github+json',
        },
        body: jsonEncode({
          'message': commitMessage,
          'content': base64Encode(utf8.encode(newContent)),
        }),
      );

      if (createResponse.statusCode == 201) {
        // File created successfully
        final Map<String, dynamic> data = jsonDecode(createResponse.body);
        fileSha = data['content']['sha'];
      } else {
        throw Exception(
            'Failed to create file: ${createResponse.reasonPhrase}');
      }
    } else {
      throw Exception('Failed to get file SHA: ${response.reasonPhrase}');
    }
  } catch (e) {
    debugPrint('Error: $e');
    return;
  }

  final updateResponse = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer $githubToken',
      'Accept': 'application/vnd.github+json',
    },
    body: jsonEncode({
      'message': commitMessage,
      'content': base64Encode(utf8.encode(newContent)),
      'sha': fileSha,
      'branch': branch,
    }),
  );

  if (updateResponse.statusCode == 200) {
    debugPrint('File updated successfully');
  } else {
    debugPrint('Error: ${updateResponse.reasonPhrase}');
    debugPrint('Response body: ${updateResponse.body}');
    throw Exception('Failed to update file');
  }
}

Future<String> getRawFileContent(String fileUrl) async {
  final response = await http.get(Uri.parse(fileUrl));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch raw file content');
  }
}
