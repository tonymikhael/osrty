import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:osrty/components/login_button.dart';
import 'package:osrty/components/text_form_field.dart';
import 'package:osrty/constants.dart';
import 'package:osrty/screens/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "";
  String password = "";
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 70, bottom: 30),
                child: Align(
                  alignment: Alignment.center,
                  child: Image(
                    height: 150,
                    image: AssetImage(
                      "assets/Group2.png",
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "OSRTY APP",
                  style: GoogleFonts.abrilFatface(
                      textStyle: TextStyle(fontSize: 45, color: primaryColor)),
                ),
              ),
              Text(
                "SIGN UP ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomizedTextFormField(
                      hintText: "E-mail",
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "name required";
                        }
                      },
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomizedTextFormField(
                      icon: Icons.password,
                      hintText: "password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "password required ";
                        } else if (value.length < 6) {
                          return "must be gretare than 6 chracter";
                        }
                      },
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomizedButton(
                      hintText: "SIGN UP",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "success, please verify your email")),
                            );
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'The account already exists for that email.')),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('there is an error')),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Center(
                  child: Text(
                "@powerd by Tony mikhael",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
              )),
            ],
          )),
        ),
      ),
    );
  }
}
