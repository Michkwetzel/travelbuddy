import 'package:firebase_core/firebase_core.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:front_travelbuddy/services/firestore_service.dart';
import 'package:front_travelbuddy/services/http_service.dart';
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
        Provider(
          create: (context) => HttpService(),
        ),
        Provider(
            create: (context) => FireStoreService(
                  userModel: context.read<UserModel>(),
                )),
        Provider(
            create: (context) => BackEndService(
                  userModel: context.read<UserModel>(),
                  http: context.read<HttpService>(),
                )),
        ChangeNotifierProvider(
            create: (context) => FireStoreStreamProvider(
                  userModel: context.read<UserModel>(),
                  fireStoreService: context.read<FireStoreService>(),
                )),
        Provider(
            create: (context) => AuthService(
                  spinner: context.read<Spinner>(),
                  backEndService: context.read<BackEndService>(),
                  userModel: context.read<UserModel>(),
                  fireStoreStreamProvider: context.read<FireStoreStreamProvider>(),
                  fireStoreService: context.read<FireStoreService>(),
                ))
      ],
      child: MaterialApp(
        home: WelcomeScreen(),
      ),
    ),
  );
}
