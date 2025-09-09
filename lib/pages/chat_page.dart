import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/chat_messages_list.dart';
import '../components/chat_input_bar.dart';
import '../components/custom_widgets.dart';
import '../components/language_selector.dart';
import '../theme/theme_provider.dart';
import '../providers/language_provider.dart';
import '../services/api_service.dart';

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

  void _sendMessage(String content, {String? imagePath}) async {
    if (content.trim().isEmpty && imagePath == null) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage.user(content, imagePath: imagePath));
      _isLoading = true;
    });

    // Scroll to bottom
    _scrollToBottom();

    // Call actual API
    await _sendToKrishiMithra(content, imagePath);
  }

  Future<void> _sendToKrishiMithra(
    String userMessage,
    String? imagePath,
  ) async {
    try {
      String botResponse;

      if (imagePath != null) {
        // Send message with image to API
        botResponse = await ApiService.sendMessageWithImage(
          userMessage,
          imagePath,
        );
      } else {
        // Send text message to API
        botResponse = await ApiService.sendMessage(userMessage);
      }

      setState(() {
        _messages.add(ChatMessage.bot(botResponse));
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors gracefully
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );

      String errorMessage;
      switch (languageProvider.currentLanguage) {
        case AppLanguage.english:
          errorMessage =
              'Sorry, I\'m having trouble connecting to KrishiMithra. Please check your internet connection and try again.';
          break;
        case AppLanguage.hindi:
          errorMessage =
              'माफ़ करें, मुझे कृषिमित्र से जुड़ने में समस्या हो रही है। कृपया अपना इंटरनेट कनेक्शन जांचें और फिर से कोशिश करें।';
          break;
        case AppLanguage.malayalam:
          errorMessage =
              'ക്ഷമിക്കണം, കൃഷിമിത്രയുമായി ബന്ധപ്പെടുന്നതിൽ എനിക്ക് പ്രശ്നമുണ്ട്. ദയവായി നിങ്ങളുടെ ഇന്റർനെറ്റ് കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കൂ।';
          break;
      }

      setState(() {
        _messages.add(ChatMessage.bot(errorMessage));
        _isLoading = false;
      });
    }

    // Scroll to bottom after response
    _scrollToBottom();
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
