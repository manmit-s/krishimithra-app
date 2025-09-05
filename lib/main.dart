import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krishimithra_app/pages/get_started.dart';
import 'package:krishimithra_app/theme/theme_provider.dart';
import 'package:krishimithra_app/theme/app_theme.dart';
import 'package:krishimithra_app/providers/language_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'KrishiMithra',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const GetStartedPage(),
          );
        },
      ),
    );
  }
}
