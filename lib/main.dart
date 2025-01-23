
import 'package:e_yoklama/DersEkle.dart';
import 'package:e_yoklama/DersIcerikleri.dart';
import 'package:e_yoklama/DersKayitlari.dart';
import 'package:e_yoklama/DersListeleri.dart';
import 'package:e_yoklama/Pictures.dart';
import 'package:e_yoklama/TeacherPassword.dart';
import 'package:e_yoklama/TeacherProfile.dart';
import 'package:e_yoklama/ogrenciEkle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Ayarlar.dart';
import 'Derslerim.dart';
import 'LogOut.dart';
import 'Login.dart';
import 'MainPage.dart';
import 'Notifications.dart';
import 'Password.dart';
import 'Profilim.dart';
import 'Register.dart';
import 'Teacher.dart';
import 'TeacherRegister.dart';
import 'TeacherMain.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/LoginPage",
      routes: {
        "/LoginPage":  (context) => LoginPage(),
        "/MainPage":   (context) => MainPage(),
        "/Profilim":   (context) => Profilim(),
        "/Derslerim":  (context) => Derslerim(),
        "/Ayarlar":    (context) => Ayarlar(),
        "LogOut":      (context) => LogOut(),
        "/Notifications": (context) => Notifications(),
        "/Register": (context) => Register(),
        "/Teacher": (context) => Teacher(),
        "/TeacherRegister":(context) => TeacherRegister(),
        "/Password": (context) => Password(),
        "/Pictures": (context) => Pictures(),
        "/TeacherMain": (context) => TeacherMain(),
        "/TeacherProfile":(context) => TeacherProfile(),
        "/TeacherPassword": (context) => TeacherPassword(),
        "/DersKayitlari": (context) => DersKayitlari(),
        "/DersEkle": (context) => DersEkle(),
        "/DersListeleri": (context) => DersListeleri(),
        "/DersIcerikleri": (context) => DersIcerikleri(),
        "/ogrenciEkle": (context) => ogrenciEkle(),
      },
    );
  }
}

