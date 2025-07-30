import 'package:flutter/material.dart';
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isPasswordVisible = true;

  void toggleVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          26,
          MediaQuery.of(context).size.height * 0.07,
          26,
          20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Welcome To \n Grocify!",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D4715),
                  ),
                ),
              ],
            ),
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Full Name",
                        style: TextStyle(
                          color: Color(0xff6B8A88),
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a name";
                      }
                    },
                    style: TextStyle(
                      color: Color(0xff0D4715),
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: InputDecoration(
                      fillColor: Color(0xffF1F0E9),
                      filled: true,
                      isDense: true,
                      prefixIcon: Icon(Icons.person_2_rounded, size: 20),
                      prefixIconColor: Color(0xff0D4715),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email address",
                        style: TextStyle(
                          color: Color(0xff6B8A88),
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter an email";
                      }
                    },
                    style: TextStyle(
                      color: Color(0xff0D4715),
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffF1F0E9),
                      isDense: true,
                      prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),
                      prefixIconColor: Color(0xff0D4715),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xff6B8A88),
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: isPasswordVisible,
                    controller: password,
                    validator: (value) {
                      if (value!.length < 6) {
                        return "Password length must be at least 6 characters";
                      }
                    },
                    style: TextStyle(
                      color: Color(0xff0D4715),
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Color(0xffF1F0E9),
                      prefixIcon: Icon(FontAwesomeIcons.lock, size: 20),
                      prefixIconColor: Color(0xff0D4715),
                      suffixIcon: IconButton(
                        onPressed: toggleVisibility,
                        icon: Icon(
                          isPasswordVisible
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                        ),
                      ),
                      suffixIconColor: Colors.lightGreen,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 33, 185, 96),
                      Color.fromARGB(255, 0, 255, 132),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Divider(
                      color: Color.fromARGB(255, 231, 229, 219),
                      thickness: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "or with",
                      style: TextStyle(
                        color: Color(0xff6B8A88),
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color.fromARGB(255, 231, 229, 219),
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffF1F0E9),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.facebook,
                        color: Color(0xFF1877F2),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffF1F0E9),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.apple,
                        color: Color(0xFF000000),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffF1F0E9),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.google,
                        color: Color(0xFF4285F4),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
