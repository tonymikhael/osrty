import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:osrty/cubit/osrty_cubit.dart';
import 'package:osrty/screens/introduction_screen.dart';
import 'package:osrty/screens/login.dart';
// Import the generated file
import 'package:osrty/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setBool('opened', false);

  Box box = await Hive.openBox<Map<dynamic, dynamic>>('users2');
  Box box2 = await Hive.openBox<bool>('intro');

  box2.add(false);

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
  var box = Hive.box<bool>("intro");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OsrtyCubit(),
      child: MaterialApp(
        title: 'App Title',
        debugShowCheckedModeBanner: false,
        home: box.getAt(0)! ? LoginScreen() : IntroductionScreen(),
      ),
    );
  }
}
