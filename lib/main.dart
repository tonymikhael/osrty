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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
//for notification

  //for hive box
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  Box box = await Hive.openBox<Map<dynamic, dynamic>>('users2');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');

    if (message.notification != null) {
      print('Message data: ${message.notification!.title.toString()}');
      print('Message data: ${message.notification!.body.toString()}');
    }
  });
//-background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
