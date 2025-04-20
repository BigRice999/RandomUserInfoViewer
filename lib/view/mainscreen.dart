import 'package:flutter/material.dart';
import 'package:random_user_info/view/displayscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) { // Gradient background of main screen
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 214, 198, 255),
              Color.fromARGB(255, 201, 255, 224),
            ],
          ),
        ),


        child: Center(
          child: Container( // Centered content with a pop-up card style layout
            padding: const EdgeInsets.all(40), 
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 244, 251, 255),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),


            child: Column( 
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan( // Welcome message 
                        text: "Welcome to the Main Screen\n \n",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),


                      TextSpan( // Instructional message
                        text: "Click to view Random User Info:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 62, 104, 255),
                        ),
                      ),
                    ],
                  ),
                ),

                
                const SizedBox(height: 30), 
                ElevatedButton.icon( // Button to load user data and navigate to the display screen
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 800),
                      pageBuilder: (_, __, ___) => DisplayScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ));
                  },

                  icon: const Icon(Icons.supervisor_account_rounded), 
                  label: const Text("Load user info"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 62, 104, 255),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
