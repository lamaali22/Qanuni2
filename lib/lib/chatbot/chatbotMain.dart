import 'package:flutter/material.dart';
import 'providers/active_theme_provider.dart';
import 'screens/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/themes.dart';

void main() {
  runApp(const ProviderScope(child: chatbotMain()));
}

class chatbotMain extends ConsumerWidget {
  const chatbotMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: lightTheme,
      debugShowCheckedModeBanner: false,
      themeMode: activeTheme == Themes.light ? ThemeMode.light : ThemeMode.light,
      home: const ChatScreen(),
    );
  }
}