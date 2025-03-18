import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/home_page.dart';
import '../../components/my_textfield.dart';
import '../../components/my_button.dart';
import '../../components/square_tile.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // ✅ Check if email or password is empty
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email and password cannot be empty")),
      );
      return; // Stop execution
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      // ✅ Redirect to home after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again.";

      // ✅ Handle specific Firebase errors
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: const Color.fromARGB(255, 146, 112, 171)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                text: 'Sign In',
                onTap: () => signUserIn(context), // ✅ Pass context to show errors
              ),

              const SizedBox(height: 50),

            ],
          ),
        ),
      ),
    );
  }
}
