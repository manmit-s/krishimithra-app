import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/message_bubble.dart';

class ChatMessagesList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const ChatMessagesList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Start a conversation',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask KrishiMithra anything about farming',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageBubble(
          message: message.content,
          isFromUser: message.isFromUser,
          timestamp: message.timestamp,
          imagePath: message.imagePath,
        );
      },
    );
  }
}

// Data model for chat messages
class ChatMessage {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final String? imagePath; // Added image path support

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.imagePath, // Optional image path
  });

  // Factory constructor for creating a user message
  factory ChatMessage.user(String content, {String? imagePath}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isFromUser: true,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );
  }

  // Factory constructor for creating a bot message
  factory ChatMessage.bot(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isFromUser: false,
      timestamp: DateTime.now(),
    );
  }
}
