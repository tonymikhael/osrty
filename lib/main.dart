import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:osrty/cubit/osrty_cubit.dart';
import 'package:osrty/screens/add.dart';
import 'package:osrty/screens/attendance.dart';
import 'package:osrty/screens/choose_screen.dart';
import 'package:osrty/screens/home_screen.dart';
import 'package:osrty/screens/login.dart';
import 'package:osrty/screens/sign_up.dart';
import 'package:osrty/screens/splash_screen.dart';
// Import the generated file
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osrty/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  Box box = await Hive.openBox<Map<dynamic, dynamic>>('users2');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? token = await FirebaseMessaging.instance.getToken();
  print("===========================");
  print(token);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OsrtyCubit(),
      child: MaterialApp(
        title: 'App Title',
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
