import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(), //
      },
      theme: ThemeData(
        useMaterial3: true, //
      ),
      darkTheme: ThemeData(
        useMaterial3: true, //
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
