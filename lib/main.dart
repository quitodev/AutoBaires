import 'package:autobaires/core/app_router.dart';
import 'package:autobaires/core/constants.dart';
import 'package:autobaires/presentation/views/home/home_screen.dart';
import 'package:autobaires/presentation/views/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: FIREBASE_API_KEY,
        appId: FIREBASE_APP_ID,
        messagingSenderId: FIREBASE_MESSAGING_SENDER_ID,
        projectId: FIREBASE_PROJECT_ID,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await di.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Auto Baires",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomeScreen(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: SplashScreen.routeName,
    );
  }
}
