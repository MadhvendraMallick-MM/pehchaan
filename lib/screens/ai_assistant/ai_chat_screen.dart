import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../services/gemini_service.dart';

class AIChatScreen extends StatefulWidget {
  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final GeminiService _geminiService = GeminiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundDark,
              AppColors.darkGreen,
              AppColors.emeraldGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'AI Explorer',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
              // Messages
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Text(
                          'Start chatting with AI Explorer!',
                          style: TextStyle(color: AppColors.textGray),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isUser = message['role'] == 'user';
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? AppColors.neonGreen
                                    : AppColors.cardDarker,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message['message']!,
                                style: TextStyle(
                                  color: isUser
                                      ? AppColors.primaryBlack
                                      : AppColors.textWhite,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // Input
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: AppColors.textWhite),
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: TextStyle(color: AppColors.textGray),
                          filled: true,
                          fillColor: AppColors.cardDarker,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: _isLoading ? null : _sendMessage,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.neonGreen,
                          shape: BoxShape.circle,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.send, color: AppColors.primaryBlack),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add({'role': 'user', 'message': userMessage});
      _isLoading = true;
    });

    // Get AI response from Gemini
    final aiResponse = await _geminiService.sendMessage(userMessage);

    setState(() {
      _messages.add({'role': 'assistant', 'message': aiResponse});
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
