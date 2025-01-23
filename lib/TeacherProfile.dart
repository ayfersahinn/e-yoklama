import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_yoklama/KullaniciVeriTutucu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({Key? key}) : super(key: key);

  @override
  State<TeacherProfile> createState() => _TeacherProfile();
}

class _TeacherProfile extends State<TeacherProfile> {
  @override
  File? _secilenDosya;
  var profil = Image.asset("assets/images/user.png");
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          /*automaticallyImplyLeading: false,
          leading: GestureDetector(                   //appbara ikon ve buton ekleme

            child: Icon(Icons.menu_rounded),
          ),*/
          title: Text("Öğretmen Profil", style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa",fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    /*Padding(
                      padding: const EdgeInsets.only(left: 120,top: 40.0),
                      child: Container(
                          child: Image.asset("assets/images/user.png", width: 160,height: 160,),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.white,
                        child: decideImage(),
                        //backgroundImage: _secilenDosya != null ? FileImage(_secilenDosya!):null,

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(
                        child: GestureDetector(
                          child: Image.asset("assets/images/pencil (1).png",width: 40,height: 40,),
                          onTap: (){
                            secimGoster(context);
                          },
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text( (KullaniciVeriTutucu.getLoggedUser() != null  // kullanici bilgisi null değilse ->
                    ? KullaniciVeriTutucu.getLoggedUser()!["name"].toString()      // giris yapan kullanicinin ismini yaz
                    : "HATALI ISIM"),   // null ise hata mesajı koy
                  style: TextStyle(fontSize: 25, color: Colors.grey[800],fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                ),
                Text( (KullaniciVeriTutucu.getLoggedUser() != null  // kullanici bilgisi null değilse ->
                    ? KullaniciVeriTutucu.getLoggedUser()!["login_id"].toString()      // giris yapan kullanicinin ismini yaz
                    : "HATALI NO"),   // null ise hata mesajı koy
                  style: TextStyle(fontSize: 20, color: Colors.grey[800],fontFamily: "Comfortaa", ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/TeacherPassword");
                  },
                  child: Text("Şifre Değiştir"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20.0),
                    fixedSize: Size(400, 60),           //boyutlar
                    textStyle: TextStyle(fontSize: 18, color: Colors.grey[700],fontFamily: "Comfortaa",),
                    shape: StadiumBorder(),   //radius şeklini ayarlar
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );

  }
  void secimGoster(BuildContext context){
    showDialog(context: context,
        builder:(context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Galeriden Fotoğraf Seç"),
                onTap: (){
                  resimYukle(ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text("Kameradan Fotoğraf Çek"),
                onTap: (){
                  resimYukle(ImageSource.camera);
                },
              ),
            ],
          ),
        )
    );
  }
  String? indirmeBaglantisi;
  var kullanici = KullaniciVeriTutucu.getLoggedUser();
  void initState(){                //sayfa yeniden yüklendiğinde profil resmi tekrar gelecek
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>baglantiAl());
  }
  void baglantiAl() async
  {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("TeacherPictures")
        .child(kullanici!.id)
        .child("TeacherProfile").getDownloadURL();
    setState((){
      indirmeBaglantisi=baglanti;
    });
  }
  void resimYukle(ImageSource source)async{
    final dbRef = await FirebaseFirestore.instance.collection("users").doc().collection("teacherPhotos");
    final picker = ImagePicker();
    final secilen = await picker.getImage(source: source);
    setState((){
      if(secilen != null)
      {
        _secilenDosya = File(secilen.path);
      }
    });
    UploadTask uploadTask;

    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("TeacherPictures")
        .child(kullanici!.id)
        .child("TeacherProfile");

    uploadTask = referansYol.putFile(_secilenDosya!);
    String link = await referansYol.getDownloadURL();
    setState((){
      indirmeBaglantisi=link;
    });

    kullanici!.reference.collection('pictures').add({'link': indirmeBaglantisi});

    //collection('photos').add({'link':indirmeBaglantisi});
    Navigator.pop(context);
  }
  Widget decideImage(){
    if(indirmeBaglantisi == null)
    {
      return Image.asset("assets/images/user.png", width: 160,height: 160,);
    }
    else
    {
      return ClipOval(child: Image.network(indirmeBaglantisi!,fit: BoxFit.cover,width: 160,height: 160,));
    }

  }
}
