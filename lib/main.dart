import 'package:file_piker_storage_firebase/pages/dasbord_pages.dart';
import 'package:file_piker_storage_firebase/pages/login_pages.dart';
import 'package:file_piker_storage_firebase/tidak%20dipakai/home_pages.dart';
import 'package:file_piker_storage_firebase/tidak%20dipakai/tes_delete_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DasboardPages();
          } else {
            return const LoginPages();
          }
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}

/* 
StreamBuilder<User?>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DasboardPages();
          } else {
            return const LoginPages();
          }
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
 */
