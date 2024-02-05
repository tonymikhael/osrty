import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osrty/constants.dart';
import 'package:osrty/cubit/osrty_cubit.dart';
import 'package:osrty/screens/home_screen.dart';
import 'package:osrty/services/my_file_picker.dart';

class ChooseScreen extends StatefulWidget {
  ChooseScreen({super.key});

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  bool chooseOption1 = false;
  bool chooseOption2 = false;

  @override
  Widget build(BuildContext context) {
    var myCubit = BlocProvider.of<OsrtyCubit>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 150, left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "choose option",
                style: GoogleFonts.abrilFatface(
                    textStyle: TextStyle(fontSize: 35, color: primaryColor)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    chooseOption1 = !chooseOption1;
                    chooseOption2 = false;
                    print(chooseOption1);
                    print(chooseOption2);
                    setState(() {});
                  },
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width * 0.38,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        border: chooseOption1
                            ? Border.all(color: primaryColor, width: 3)
                            : null),
                    child: Column(
                      children: [
                        Image(
                            height: 100,
                            image: AssetImage(
                              'assets/csvLogo.png',
                            )),
                        Spacer(),
                        Text(
                          "ضيف القايمة بتاعتك من csv شييت موجود بالفعل",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    chooseOption2 = !chooseOption2;
                    chooseOption1 = false;
                    print(chooseOption1);
                    print(chooseOption2);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width * 0.38,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        border: chooseOption2
                            ? Border.all(color: primaryColor, width: 3)
                            : null),
                    child: Column(
                      children: [
                        Image(
                            // height: 100,
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'assets/manually.jpg',
                            )),
                        Text(
                          " ضيف القايمة بتاعتك بنفسك ",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                fixedSize: Size(150, 54),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: primaryColor,
              ),
              onPressed: chooseOption1 == true || chooseOption2 == true
                  ? () {
                      if (chooseOption2 == true) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                      } else if (chooseOption1 == true) {
                        print(myCubit.email);
                        pickFileService().selectFile("${myCubit.email}");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                      } else {}
                    }
                  : null,
              child: Text("submit"),
            ),
          ],
        ),
      ),
    );
  }
}
