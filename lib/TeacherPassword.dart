import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'KullaniciVeriTutucu.dart';

class TeacherPassword extends StatefulWidget {
  const TeacherPassword({Key? key}) : super(key: key);

  @override
  State<TeacherPassword> createState() => _TeacherPassword();
}

class _TeacherPassword extends State<TeacherPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController sifreController = TextEditingController();

  @override
  bool hataGoster = false;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Şifre Yenile",style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa", fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  obscureText: true,
                  controller: sifreController,
                  decoration: InputDecoration(
                    hintText: "Mevcut şifrenizi giriniz",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.blueAccent ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Yeni şifre oluşturun",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.blueAccent ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
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



  void veriEkle()async{
    if(sifreController.text.trim().isEmpty
        || passwordController.text.trim().isEmpty)
    {
      Fluttertoast.showToast(msg: "Tüm alanları doldurunuz.", toastLength: Toast.LENGTH_LONG);
      return;
    }
    var kullanici = KullaniciVeriTutucu.getLoggedUser();

    kullaniciKontrol(sifreController.text)
        .then((sonuc) {
      if(sonuc)
      {
        setState((){
          hataGoster = true;
        });
        kullanici?.reference.update({'password': passwordController.text});
        Fluttertoast.showToast(msg: "Şifre Değiştirildi.");
      }
      else
      {
        setState((){
          hataGoster = false;
        });

        Fluttertoast.showToast(msg: "Şifreniz bulunamadı.");

      }
    });


  }

  Future<bool> kullaniciKontrol(String ogretmenSifre)
  async {

    var db = FirebaseFirestore.instance;
    bool bulundu = false;
    var testRef = await db.collection("users").get();


    testRef.docs.forEach((ogretmen) {
      if(ogretmen["password"] == ogretmenSifre)
      {
        KullaniciVeriTutucu.setLoggedUser(ogretmen);

        bulundu = true;
        return;
      }
    });

    return bulundu;
  }
}
