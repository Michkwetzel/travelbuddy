import 'package:firebase_core/firebase_core.dart';
import 'package:front_travelbuddy/change_notifiers/chat_history_provider.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/screens/chatbot_screen.dart';
import 'package:front_travelbuddy/screens/log_in_screen.dart';
import 'package:front_travelbuddy/screens/welcome_screen.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:front_travelbuddy/services/firestore_service.dart';
import 'package:front_travelbuddy/services/http_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatStateProvider()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => Spinner()),
        ChangeNotifierProvider(create: (context) => ChatHistoryProvider()),
        Provider(
          create: (context) => HttpService(),
        ),
        Provider(
            create: (context) => FireStoreService(
                  userModel: context.read<UserModel>(),
                  chatStateProvider: context.read<ChatStateProvider>(),
                )),
        Provider(
            create: (context) => BackEndService(
                  chatHistoryProvider: context.read<ChatHistoryProvider>(),
                  chatStateProvider: context.read<ChatStateProvider>(),
                  userModel: context.read<UserModel>(),
                  http: context.read<HttpService>(),
                  fireStoreService: context.read<FireStoreService>(),
                  spinner: context.read<Spinner>(),
                )),
        ChangeNotifierProvider(
            create: (context) => FireStoreStreamProvider(
                  userModel: context.read<UserModel>(),
                  fireStoreService: context.read<FireStoreService>(),
                  chatStateProvider: context.read<ChatStateProvider>(),
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
        title: 'TravelBuddy',
        theme: ThemeData(fontFamily: 'Roboto',),
        home: WelcomeScreen(),
      ),
    ),
  );
}
