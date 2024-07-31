import 'package:flutter/material.dart';
import 'package:nfc_app/presentation/screens/history/history_screen.dart';
import 'package:nfc_app/presentation/screens/settings/settings_screen.dart';
import 'package:nfc_app/presentation/screens/write-nfc/text_record_screen.dart';
import 'package:nfc_app/presentation/widgets/app_bottom_nav.dart';
import 'package:provider/provider.dart';

import '../../notifier/bottom_nav.dart';
import 'read-nfc/read_nfc_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  final List<Widget> _screens = const [
    ReadNFCScreen(),
    TextRecordScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavigationProvider()..setIndex(initialIndex),
      child: Scaffold(body: Consumer<BottomNavigationProvider>(
        builder: (context, provider, child) {
          return _screens[provider.currentIndex];
        },
      ), bottomNavigationBar: Consumer<BottomNavigationProvider>(
          builder: (context, provider, child) {
        return AppBottomNav(selectedindex: provider.currentIndex);
      })),
    );
  }
}
