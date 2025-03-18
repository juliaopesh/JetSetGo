import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/home_page.dart';
import '../../components/my_textfield.dart';
import '../../components/my_button.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user in method
  void signUserUp(BuildContext context) async {
  // ✅ Show loading animation
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing manually
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    String errorMessage = "An error occurred. Please try again.";

    // ✅ Check if fields are empty
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Navigator.pop(context); // ✅ Remove loading screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email, password, and confirm password cannot be empty.")),
      );
      return;
    }

    // ✅ Check if passwords match
    if (password != confirmPassword) {
      Navigator.pop(context); // ✅ Remove loading screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords don't match.")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pop(context); // ✅ Remove loading screen before navigation

      // ✅ Redirect to home after successful signup
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // ✅ Remove loading screen before showing error

      // ✅ Handle specific Firebase errors
      if (e.code == 'email-already-in-use') {
        errorMessage = "Email is already in use.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password is too weak.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      }

      // ✅ Show error message in SnackBar
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
                'Let\'s create an account for you!',
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

               // password textfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 20),
              // sign in button
              MyButton(
                text: 'Sign up',
                onTap: () => signUserUp(context), // ✅ Pass context to show errors
              ),

              const SizedBox(height: 50),

            ],
          ),
        ),
      ),
    );
  }
}
