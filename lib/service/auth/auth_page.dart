// I am using this page to check user is signed in or not,
// if he or she is signed In then it will show home page o/w it will show login page 
// import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/service/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          // user loged in
          if(snapshot.hasData){
            return const HomePage();
          }
          // user not logged in
          else{
            return const LoginOrRegister();
          }
        }
      ),
    );
  }
}