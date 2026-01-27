// lib/services/gemini_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../utils/api_keys.dart';

class GeminiService {
  // API key loaded from environment variables via ApiKeys
  late String API_KEY;

  GeminiService() {
    API_KEY = ApiKeys.geminiApiKey;
  }

  // ========================================================================
  // CORRECT API ENDPOINT
  // ========================================================================

  // Use gemini-2.5-flash (latest, fastest model available)
  static const String BASE_URL =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // Alternative models you can try:
  // static const String BASE_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent';
  // static const String BASE_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<String> sendMessage(String message) async {
    // Check if API key is set
    if (API_KEY.isEmpty || API_KEY == 'YOUR_GEMINI_API_KEY_HERE') {
      return '''🔑 API Key Not Set!

Please follow these steps to fix:

1. Create .env file in project root with:
   GEMINI_API_KEY=YOUR_API_KEY_HERE
2. Get your API key: https://aistudio.google.com/app/apikey
3. Restart the app
''';
    }

    try {
      String enhancedPrompt = _enhancePromptForLearning(message);

      // Debug logging
      print('=== DEBUG INFO ===');
      print('API Key length: ${API_KEY.length}');
      print('API Key is empty: ${API_KEY.isEmpty}');
      print(
        'API Key preview: ${API_KEY.isNotEmpty ? API_KEY.substring(0, min(10, API_KEY.length)) : 'EMPTY'}',
      );
      print(
        'API Key ends with: ${API_KEY.isNotEmpty ? API_KEY.substring(max(0, API_KEY.length - 5)) : 'N/A'}',
      );

      final url = '$BASE_URL?key=$API_KEY';

      print('🔄 Sending request to Gemini API...');
      print('📍 URL: $url');
      print('🔑 API Key: ${API_KEY.substring(0, 10)}...');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': enhancedPrompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
          ],
        }),
      );

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('✅ Success! Parsing response...');

        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          String aiResponse =
              data['candidates'][0]['content']['parts'][0]['text'];
          print('✅ AI Response received!');
          return aiResponse;
        } else {
          print('⚠️ Unexpected response structure');
          return 'Sorry, I could not generate a response. Please try again.';
        }
      } else if (response.statusCode == 400) {
        print('❌ Error 400: Bad Request');
        print('Response body: ${response.body}');

        return '''❌ Error 400: Bad Request

This usually means your API key is incorrect or has wrong format.

How to fix:
1. Go to: https://aistudio.google.com/app/apikey
2. Check if your API key is still active
3. Create a NEW API key if needed
4. Make sure you copied the ENTIRE key
5. Check for extra spaces before/after the key
6. The key should look like: AIzaSyBxxxxx...

Your current key starts with: ${API_KEY.substring(0, 10)}...

Technical details:
${response.body}
''';
      } else if (response.statusCode == 403) {
        print('❌ Error 403: Forbidden');

        return '''❌ Error 403: Access Denied

Your API key might be:
• Invalid or expired
• Not activated yet (wait 1-2 minutes after creation)
• Doesn't have permission for Gemini API

Solution:
1. Go to: https://aistudio.google.com/app/apikey
2. Generate a NEW API key
3. Make sure "Generative Language API" is enabled
4. Wait 1-2 minutes for activation
5. Replace the old key in the code

If problem persists, check:
https://console.cloud.google.com/apis/library/generativelanguage.googleapis.com
''';
      } else if (response.statusCode == 404) {
        print('❌ Error 404: Not Found');

        return '''❌ Error 404: Endpoint Not Found

The API endpoint might have changed or is incorrect.

Current endpoint: $BASE_URL

Fixes to try:
1. Make sure you have internet connection
2. Check if you're using the latest code
3. The model "gemini-1.5-flash" should work
4. Try alternative models in gemini_service.dart

Alternative models to try:
• gemini-pro
• gemini-1.5-pro

If none work, check Google's latest API docs:
https://ai.google.dev/api/rest
''';
      } else if (response.statusCode == 429) {
        return '''⏳ Too Many Requests

You've hit the rate limit. Free tier limits:
• 15 requests per minute
• 1,500 requests per day

Please wait a minute and try again!
''';
      } else {
        print('❌ Error ${response.statusCode}');
        print('Response: ${response.body}');

        return '''❌ Error ${response.statusCode}: ${response.reasonPhrase}

Response:
${response.body}

Possible solutions:
1. Check your internet connection
2. Verify API key is correct
3. Wait a few seconds and try again
4. Check if Gemini API is down: https://status.cloud.google.com/
''';
      }
    } on http.ClientException catch (e) {
      print('❌ Network Error: $e');
      return '''🌐 Network Connection Error

Cannot reach Google's servers.

Please check:
• Your internet connection is working
• You're not behind a firewall blocking API calls
• Try switching between WiFi and mobile data

Error details: $e
''';
    } catch (e) {
      print('❌ Unexpected Error: $e');
      return '''⚠️ Unexpected Error

Something went wrong: $e

Please try:
1. Restart the app
2. Check internet connection
3. Update your API key
4. Contact support if issue persists
''';
    }
  }

  String _enhancePromptForLearning(String userMessage) {
    // Check if message contains Hindi characters
    bool containsHindi = RegExp(r'[\u0900-\u097F]').hasMatch(userMessage);

    if (containsHindi) {
      return '''You are an English learning assistant for Hindi speakers. The user said in Hindi: "$userMessage"

Please provide:
1. **English Translation**: [clear, simple translation]
2. **Grammar Breakdown**: [explain what grammar is used]
3. **Pronunciation Tips**: [how to pronounce key English words]
4. **Practice Examples**: [give 2-3 similar example sentences]

Keep your response simple, encouraging, and educational. Use easy language suitable for beginners.''';
    } else {
      return '''You are a helpful AI tutor for students from Class 1 to 12 in India.

Student's question: "$userMessage"

Please provide a clear, simple explanation suitable for their level. 
• If it's a math problem, show step-by-step solution
• If it's a science question, explain simply with examples
• If it's about concepts, break it down clearly
• Always be encouraging and supportive
• Keep answers concise and easy to understand

Focus on helping the student learn, not just giving answers.''';
    }
  }

  // Specific method for Hindi to English translation
  Future<String> translateAndTeach(String hindiSentence) async {
    String prompt =
        '''I want to learn English from Hindi. Please help me translate and learn from this sentence:

Hindi Sentence: "$hindiSentence"

Please provide:
1. **English Translation**: [accurate translation]
2. **Grammar Explanation**: [what grammar rule is used]
3. **Word-by-Word Breakdown**: 
   - [Hindi word] = [English word] (type of word)
4. **Pronunciation Guide**: [simple pronunciation tips in Hinglish]
5. **Practice Sentences**: [2 similar example sentences to practice]

Make it very simple and easy to understand for beginners learning English.''';

    return await sendMessage(prompt);
  }

  // Method to answer student questions
  Future<String> answerQuestion(String question) async {
    String prompt = '''Student Question: "$question"

Please answer clearly and simply for a school student (Class 1-12 in India).

• If it's math, show steps
• If it's science, explain simply
• If it's a concept, break it down
• Be encouraging!

Provide a helpful, educational answer.''';

    return await sendMessage(prompt);
  }
}

// ============================================================================
// TESTING YOUR API KEY
// ============================================================================
// 
// To test if your API key works, you can use this in your terminal:
// 
// curl \
//   -H 'Content-Type: application/json' \
//   -d '{"contents":[{"parts":[{"text":"Hello"}]}]}' \
//   -X POST 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=YOUR_API_KEY_HERE'
// 
// Replace YOUR_API_KEY_HERE with your actual key
// If it works, you'll get a JSON response with text
// ============================================================================