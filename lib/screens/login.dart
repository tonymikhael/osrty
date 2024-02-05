// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:osrty/components/login_button.dart';
import 'package:osrty/components/text_form_field.dart';
import 'package:osrty/constants.dart';
import 'package:osrty/cubit/osrty_cubit.dart';
import 'package:osrty/screens/choose_screen.dart';
import 'package:osrty/screens/sign_up.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String password = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var myCubit = BlocProvider.of<OsrtyCubit>(context);
    final _formKey = GlobalKey<FormState>();
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
                  child:
                      Image(height: 150, image: AssetImage("assets/Group.png")),
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
                "LOG IN ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomizedTextFormField(
                      onChanged: (value) {
                        myCubit.email = value;
                      },
                      hintText: "E-mail",
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "email required ";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomizedTextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value.length < 6) {
                          return "password must grether than 6 character";
                        }
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      hintText: "password",
                      icon: Icons.password,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomizedButton(
                      hintText: "LOG IN",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: myCubit.email, password: password);
///////////////////////// //dont forget to add condition of the navigation if user is first time goto choose screen else go to home

                            if (FirebaseAuth
                                .instance.currentUser!.emailVerified) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChooseScreen();
                              }));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('please verify your email')),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('no user found for this email')),
                              );
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('wrong password, try again')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('email or password incorrect')),
                              );
                            }
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  Expanded(
                    child: Divider(),
                  ),
                  Text(
                    "OR",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "don't have an accout?",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SignUp();
                        }));
                      },
                      child: Text(
                        "Sign UP",
                        style: TextStyle(color: primaryColor, fontSize: 16),
                      ))
                ],
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
