import 'package:e_yoklama/Util/FirebaseManager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ogrenciEkle extends StatefulWidget {
  const ogrenciEkle({Key? key}) : super(key: key);

  @override
  State<ogrenciEkle> createState() => _ogrenciEkleState();
}

class _ogrenciEkleState extends State<ogrenciEkle> {
  TextEditingController noController = TextEditingController();
  TextEditingController devamController = TextEditingController();
  TextEditingController dersController = TextEditingController();
  bool hataGoster = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Öğrenci Ekle",style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa", fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(

              children: [
                TextField(

                  controller: noController,
                  decoration: InputDecoration(
                    hintText: "Öğrenci no giriniz",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.blueAccent ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(

                  controller: dersController,
                  decoration: InputDecoration(
                    hintText: "Ders adı giriniz",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.blueAccent ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    prefixIcon: Icon(
                      Icons.menu_book,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                TextField(

                  controller: devamController,
                  decoration: InputDecoration(
                    hintText: "Devamsızlık bilgisi giriniz",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.blueAccent ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    prefixIcon: Icon(
                      Icons.text_snippet_rounded,
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      veriEkle();

                    },
                    child: Text("Kaydet"),

                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.all(20.0),
                      fixedSize: Size(400, 60),           //boyutlar
                      textStyle: TextStyle(fontSize: 18,),
                      shape: StadiumBorder(),   //radius şeklini ayarlar
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





  void veriEkle() async {

    if (noController.text.trim().isEmpty || devamController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Tüm alanları doldurunuz.", toastLength: Toast.LENGTH_LONG);
      return;
    }

    var sonuc = await FirebaseManager.shared.derseKaydet(noController.text, dersController.text, devamController.text);
    if (sonuc == FirebaseManagerError.success) {
      setState(() {
        hataGoster = false;
      });
      Fluttertoast.showToast(msg: "Bilgiler eklendi");
      Navigator.pushNamed(context, "/DersListeleri");
    } else if (sonuc == FirebaseManagerError.invalidStudentNumber) {
      setState(() {
        hataGoster = true;
      });
      Fluttertoast.showToast(msg: "Öğrenci no kayıtlı değil.");
    } else if (sonuc == FirebaseManagerError.invalidLessonName) {
      setState(() {
        hataGoster = true;
      });
      Fluttertoast.showToast(msg: "Girilen ders mevcut değil.");
    }
  }
}

