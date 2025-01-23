import 'dart:ffi';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'KullaniciVeriTutucu.dart';
import 'ResimKaresi.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  @override
  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();
  //TextEditingController emailController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  bool hataGoster = false;

  List<ResimKaresi>? _sonucResimleri;

  Future<List<ResimKaresi>?> sayfayaYonlendir(String sayfa) async
  {
    return await Navigator.pushNamed(context, "/Pictures") as List<ResimKaresi>?;
  }
  
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  SizedBox(
                    height: 15,
                  ),
                  Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                       color: Colors.lightBlue[800],

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0,bottom: 10),
                            child: Text("Ad Soyad",style: TextStyle(fontSize: 14, color: Colors.white),),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Ad Soyad",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color: Colors.blue),
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              filled: true,
                              fillColor: Colors.white
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0,bottom: 10),
                            child: Text("Öğrenci No",style: TextStyle(fontSize: 14, color: Colors.white),),
                          ),
                          TextField(
                            controller: noController,
                            decoration: InputDecoration(
                                hintText: "Öğrenci No",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,color: Colors.white),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                filled: true,
                                fillColor: Colors.white
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0,bottom: 10),
                            child: Text("Şifre",style: TextStyle(fontSize: 14, color: Colors.white),),
                          ),
                          TextField(
                            obscureText: true,
                            controller: sifreController,
                            decoration: InputDecoration(
                                hintText: "Şifre",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,color: Colors.white),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                filled: true,
                                fillColor: Colors.white
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                sayfayaYonlendir("/Pictures").then(
                                    (sonuc)
                                {
                                  _sonucResimleri = sonuc;
                                  print("Sayfa kapandı\nSonuc = $_sonucResimleri");
                                });
                              },
                              child: Text("Fotoğraf Yükle"),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 18),
                                primary: Colors.lightBlue,
                                textStyle: TextStyle(fontSize: 20,),
                                shape: StadiumBorder(),   //radius şeklini ayarlar
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){
                                veriEkle();
                              },
                              child: Text("Kaydet"),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 18),
                                primary: Colors.lightGreen,
                                textStyle: TextStyle(fontSize: 20,),
                                shape: StadiumBorder(),   //radius şeklini ayarlar
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ),
      ),
    );
  }

  bool resimKontrol()
  {
    if (_sonucResimleri == null)
      {
        return false;
      }

    for(int i = 0; i < _sonucResimleri!.length; i++)
      {
        if(_sonucResimleri![i].secilenDosya == null)
          {
            return false;
          }
      }
    return true;
  }

  void veriEkle()async{
    if(nameController.text.trim().isEmpty
    || sifreController.text.trim().isEmpty
    || noController.text.trim().isEmpty)
      {
        Fluttertoast.showToast(msg: "Tüm alanları doldurunuz.", toastLength: Toast.LENGTH_LONG);
        return;
      }
    var kullaniciKoleksiyonu = await FirebaseFirestore.instance.collection("users");
    var sonuc = await kullaniciKontrol(noController.text);

    if(sonuc)
    {
      setState((){
        hataGoster = true;
      });
      Fluttertoast.showToast(msg: "Öğrenci No zaten kayıtlı.");
      //Navigator.pushNamed(context, "/Register");
    }
   /* else if(!resimKontrol())
    {
      setState((){
        hataGoster = true;
      });
      Fluttertoast.showToast(msg: "Yeterli sayıda resim yüklemediniz");
    }*/
    else
    {
      setState((){
        hataGoster = false;
      });
      var yeniKullanici = await kullaniciKoleksiyonu.add({
        //'e_mail':emailController.text,

        'name':nameController.text,
        'login_id':noController.text,
        'password':sifreController.text,
        'type': "student"
      });
      resimYukle(yeniKullanici);
      Fluttertoast.showToast(msg: "Bilgiler eklendi");
      Navigator.pushNamed(context, "/LoginPage");
    }
  }

  void resimYukle(DocumentReference<Map<String, dynamic>> kullanici)async{

    UploadTask uploadTask;

    Reference referansYol = await FirebaseStorage.instance
        .ref()
        .child("Pictures")
        .child(kullanici.id)
        .child("profile");
    try
    {
      for(int i = 0; i < _sonucResimleri!.length; i++)
      {
        uploadTask = referansYol.putFile(_sonucResimleri![i].secilenDosya!);
        await uploadTask;
        String link = await referansYol.getDownloadURL();
        kullanici.collection('pictures').add({'link': link});
      }
    }
    catch(E)
    {
      var id = kullanici.id;
      print("HATA RESIM YUKLENEMEDI: $id\n$E");
    }
  }

  Future<bool> kullaniciKontrol(String ogrenciNo)
  async {

    var db = FirebaseFirestore.instance;
    var dbRef = await db.collection("users").get();

    try
    {
      dbRef.docs.firstWhere((ogrenci) => ogrenci.data()["login_id"] == ogrenciNo);
      return true;
    }
    catch(E) // bulamazsa hata veriyor, hata verirse catch bloğuna düşüp false dönüyor
    {
      return false;
    }
  }
}
