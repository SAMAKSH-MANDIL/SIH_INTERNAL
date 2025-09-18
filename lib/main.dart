import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/language_selection_screen.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('bn')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    });
  }

  _saveThemeMode(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', mode.index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tr("app_name"),
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: AuthWrapper(
        themeMode: _themeMode,
        onThemeChanged: (mode) {
          setState(() {
            _themeMode = mode;
          });
          _saveThemeMode(mode);
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;

  const AuthWrapper({
    Key? key,
    required this.themeMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasData) {
          return HomePage(
            themeMode: themeMode,
            onThemeChanged: onThemeChanged,
          );
        }
        
        return const LanguageSelectionScreen();
      },
    );
  }
}