import 'package:firebase_core/firebase_core.dart';
import 'package:front_travelbuddy/change_notifiers/user_data_capture_notifier.dart';
//import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => Spinner()),
        ChangeNotifierProvider(create: (context) => UserDataCaptureNotifier()),
        Provider(create: (context) => AuthService(spinner: context.read<Spinner>(), userModel: context.read<UserModel>())),
      ],
      child: MaterialApp(
        home: WelcomeScreen(),
      ),
    ),
  );
}
