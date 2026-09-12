import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front_winbin/poviders/AuthProvider.dart';
import 'package:front_winbin/poviders/IaProvider.dart';
import 'package:front_winbin/poviders/RankingProvider.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => IaProvider()),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WinBin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
