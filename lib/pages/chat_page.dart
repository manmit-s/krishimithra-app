import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/chat_messages_list.dart';
import '../components/chat_input_bar.dart';
import '../components/custom_widgets.dart';
import '../components/language_selector.dart';
import '../theme/theme_provider.dart';
import '../providers/language_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    setState(() {
      _messages.add(ChatMessage.bot(languageProvider.getGreeting()));
    });
  }

  void _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage.user(content));
      _isLoading = true;
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate bot response (replace this with actual API call later)
    await _simulateBotResponse(content);
  }

  Future<void> _simulateBotResponse(String userMessage) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

    // Generate a mock response based on user input
    final botResponse = _generateMockResponse(userMessage);

    setState(() {
      _messages.add(ChatMessage.bot(botResponse));
      _isLoading = false;
    });

    // Scroll to bottom after response
    _scrollToBottom();
  }

  String _generateMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // Simple keyword-based responses for testing
    if (lowerMessage.contains('crop') || lowerMessage.contains('plant')) {
      return 'Great question about crops! The best crops to plant depend on your soil type, climate, and season. What specific information are you looking for?';
    } else if (lowerMessage.contains('weather') ||
        lowerMessage.contains('rain')) {
      return 'Weather is crucial for farming! I can help you understand weather patterns and their impact on your crops. What weather concerns do you have?';
    } else if (lowerMessage.contains('pest') ||
        lowerMessage.contains('insect')) {
      return 'Pest management is important for healthy crops. I can help you identify common pests and suggest organic or chemical control methods. Can you describe the pest issue?';
    } else if (lowerMessage.contains('fertilizer') ||
        lowerMessage.contains('nutrient')) {
      return 'Proper fertilization is key to good yields! I can help you choose the right fertilizers based on your crop and soil conditions. What type of crop are you growing?';
    } else if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello there! I\'m here to help with all your farming questions. What would you like to know about agriculture today?';
    } else {
      return 'That\'s an interesting question! As your digital farming assistant, I\'m here to help with crops, weather, pests, fertilizers, and more. Could you provide more details about what you\'d like to know?';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  languageProvider.getSettingsTitle(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.brightness_6,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        languageProvider.getThemeSettingsText(),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DarkModeToggle(
                    isDarkMode: themeProvider.isDarkMode,
                    onToggle: (value) {
                      themeProvider.setTheme(value);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        languageProvider.getLanguageSettingsText(),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LanguageSelector(
                    currentLanguage: languageProvider.currentLanguage,
                    onLanguageChanged: (language) {
                      languageProvider.setLanguage(language);
                      // Refresh welcome message when language changes
                      setState(() {
                        _messages.clear();
                        _addWelcomeMessage();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: const Icon(Icons.clear_all),
                title: Text(
                  languageProvider.getClearChatText(),
                  style: GoogleFonts.poppins(),
                ),
                onTap: () {
                  setState(() {
                    _messages.clear();
                    _addWelcomeMessage();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.smart_toy,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.getAppBarTitle(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  languageProvider.getAppBarSubtitle(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Open drawer programmatically
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ChatMessagesList(
              messages: _messages,
              scrollController: _scrollController,
            ),
          ),
          // Input bar
          ChatInputBar(onSendMessage: _sendMessage, isLoading: _isLoading),
        ],
      ),
    );
  }
}
