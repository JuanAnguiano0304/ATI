import 'package:ati/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCk3t1ipTmSFIGEf_Rlq-8EfOcmeh6CMIs",
          authDomain: "singin-20d15.firebaseapp.com",
          projectId: "singin-20d15",
          storageBucket: "singin-20d15.appspot.com",
          messagingSenderId: "429719789896",
          appId: "1:429719789896:web:eb06bcd8a5a37d58b3537d",
          measurementId: "G-N823GCC6FL"));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATI Buscador',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
