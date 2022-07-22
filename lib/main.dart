import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intargram/providers/user_provider.dart';
import 'package:intargram/responsive/mobile_app.dart';
import 'package:intargram/responsive/responsive_app.dart';
import 'package:intargram/responsive/web_app.dart';
import 'package:intargram/screens/login_screen.dart';
import 'package:intargram/untils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDLwCeTPC2OOAmwYZ9Gu5MegfWNS-dkVKg",
          appId: "1:31129991834:web:bfd6f3d1b36a1e07bf3d23",
          messagingSenderId: "31129991834",
          projectId: "flutter-intargram-app",
          storageBucket: 'flutter-intargram-app.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> UserProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blogger',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return const LoginScreen();
            },
          )
          // const ResponsiveLayout(
          //     mobileScreenLayout: MobileScreenLayout(),
          //     webScreenLayout: WebScreenLayout()),
          ),
    );
  }
}
