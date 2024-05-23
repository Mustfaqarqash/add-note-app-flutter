import 'package:flutter/material.dart';
import 'package:php_flutter/auth/log_in.dart';
import 'package:php_flutter/screen/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: sharedPref.getString("id") == null
          ? const LoginPage()
          : const HomePage(),
      routes: {
        "HomePage": (context) => const HomePage(),
      },
    );
  }
}
