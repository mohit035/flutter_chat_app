import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterChat',
        theme: ThemeData().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 63, 17, 177)),
        ),
        home: StreamBuilder(
            //listening the event been emitted by firebase, will automatically switch
            //on logout it will emit the new event without the data,
            // no authentication token will exist anymore because firebase will clear or erase from device memory
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              //snapshot is the user data emitted by firebase
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData) {
                return const ChartScreen();
              }
              return const AuthScreen();
            }));
  }
}
//streamBuilder is simlar to futurebuilder
//futurebuilder was used to listen to a future and then render different widgets based on the state of their future,
// in the end, will be done one it resolved. so it will only produced one value or error,

// whereas stream is otherhand capable of producing a multiple value over a time

// connect BE via sdk use the firebase sdk and let it send the http requests.
//certain third-party backend services(like firebase) offer sdk packages that handle & simplify the http communication.
// the token received is managed and store on device by firebase sdk , firebase sdk did all that for us.
