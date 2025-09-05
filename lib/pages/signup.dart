import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishimithra_app/components/custom_widgets.dart';
import 'package:krishimithra_app/pages/chat_page.dart';
import '../components/background_curve.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light green background
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.3),
              ),
            ),
          ),
          // Main content with frosted glass effect
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FrostedGlassBox(
                  width: MediaQuery.of(context).size.width - 48,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(
                              fontSize: 45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Create your account",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          hintText: "Email",
                          controller: TextEditingController(),
                          obscureText: false,
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          hintText: "Password",
                          controller: TextEditingController(),
                          obscureText: true,
                          icon: Icons.lock_outlined,
                          isPasswordField: true,
                        ),
                        SizedBox(height: 16),
                        CustomButton(
                          text: "Sign Up",
                          onPressed: () {
                            // Handle sign up logic
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text("Or continue with"),
                            SizedBox(width: 4),
                            Expanded(
                              child: Divider(
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialButton(
                              assetPath: "assets/images/google_logo.png",
                              onPressed: () {
                                // Handle Google sign-in
                              },
                            ),
                            SizedBox(width: 16),
                            SocialButton(
                              assetPath: "assets/images/apple_logo.png",
                              onPressed: () {
                                // Handle Apple sign-in
                              },
                            ),
                            SizedBox(width: 16),
                            SocialButton(
                              assetPath: "assets/images/phone_icon.png",
                              onPressed: () {
                                // Handle Phone sign-in
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
