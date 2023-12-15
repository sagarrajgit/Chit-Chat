import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_text_field.dart';
import 'package:chatapp/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final emailController = TextEditingController();  
  final passwordController = TextEditingController();

  // sign in user
  Future<void> signIn() async {
    // get the auth service
    final authService=Provider.of<AuthService>(context, listen:false);

    try{
      await authService.signInWithEmailandPassword(
        emailController.text, 
        passwordController.text,
      );

      //
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Logged In successfully",
      //     ),
      //   ),
      // );
    }
    // if any error found
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.grey[800],
                ),

                //welcome back message
                const Text(
                  "Welcome back you've been missed!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height:50),

                //email text field
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                ),

                const SizedBox(height:20),

                //password
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                ),

                const SizedBox(height: 30),

                //signIn button
                MyButton(onTap: signIn, text: 'Sign In'),

                const SizedBox(height:20),

                //resister page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),

                    const SizedBox(width: 5),

                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register Now',
                        style: TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
