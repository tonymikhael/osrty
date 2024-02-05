import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:osrty/screens/login.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      const ContentConfig(
        title: "Sign up & login",
        description:
            "انشاء حساب لكل فصل \n يرجي التاكد من فتح الحساب لتفعيله من جوجل",
        pathImage: "assets/screenshoots/screen1.jpg",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "CSV",
        description:
            "هام : يجب ان يكون ترتيب القايمة ك الات رقم تسلسل, اسم ,تليفون1, تليفون 2, تاريخ ميلاد , عنوان ",
        pathImage: "assets/screenshoots/screen2.jpg",
        backgroundColor: Color(0xff9932CC),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Manual add & favourite list",
        description:
            "اضافة يدوية \n قائمة مفضلة لكل خادم \n امين الاسرة يقدر يتابع الافتقاد",
        pathImage: "assets/screenshoots/screen3.jpg",
        backgroundColor: Color(0xff203152),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Attendance system",
        description: "نظام حضور وغياب  سهل جدا",
        pathImage: "assets/screenshoots/screen4.jpg",
        backgroundColor: Color.fromARGB(255, 53, 174, 152),
      ),
    );
  }

  void onDonePress() {
    print("end of slides");
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      onDonePress: () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }), (route) => false);
      },
    );
  }
}
