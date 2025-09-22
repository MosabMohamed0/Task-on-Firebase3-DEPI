import 'package:firebase/firebase_task2.dart/screens/expense_tracker.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return HomeScrean(user: snapshot.data!);
            return HomeScreen();
          } else {
            return SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(
                  clientId:
                      "1087276421697-ar5nbcqn8ab2nvqni7fb1cptv634c27g.apps.googleusercontent.com",
                ),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Icon(
                    Icons.flutter_dash,
                    size: constraints.maxHeight * 0.3,
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to MyApp! Please sign in to continue.'
                        : 'Welcome to MyApp! Please create an account to continue.',
                  ),
                );
              },
              // بتظهر في land scale
              sideBuilder: (context, constraints) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Welcome to MyApp! Please sign in to continue.',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
