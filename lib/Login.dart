import 'package:e_yoklama/KullaniciVeriTutucu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController noController = TextEditingController();
  TextEditingController sifreController = TextEditingController();

  bool hataGoster = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 130.0,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),

                  Container(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(right: 20,left: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, "/LoginPage");
                                  },
                                  child: Text("ÖĞRENCİ",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold),),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 7,horizontal: 60),
                                    primary: Colors.grey[300],
                                    textStyle: TextStyle(fontSize: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50)
                                      )
                                    ),   //radius şeklini ayarlar
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, "/Teacher");
                                  },

                                  child: Text("ÖĞRETMEN",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold),),
                                  style: ElevatedButton.styleFrom(

                                    padding: EdgeInsets.symmetric(vertical: 7,horizontal: 50),
                                    primary: Colors.grey[300],
                                    onPrimary: Colors.lightGreen,
                                    textStyle: TextStyle(fontSize: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(50),
                                            bottomRight: Radius.circular(50)
                                        )
                                    ),   //radius şeklini ayarlar
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Visibility(
                                  child: Text("Kullanıcı adı veya şifre hatalı",style: TextStyle(color: Colors.red),),
                                visible: hataGoster,

                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: noController,
                            decoration: InputDecoration(
                              hintText: "Öğrenci No",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color: Colors.blueAccent ),
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              prefixIcon: Icon(
                                Icons.account_circle,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          TextField(
                            obscureText: true,
                            controller: sifreController,
                            decoration: InputDecoration(
                              hintText: "Şifre",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color: Colors.blueAccent ),
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                              ),
                            ),
                          ),

                         /* Padding(
                            padding: const EdgeInsets.only(left: 220),
                            child: TextButton(onPressed:(){
                              Navigator.pushNamed(context, "/PasswordForgot");
                            },
                                child: Text("Şifremi Unuttum",
                                  style: TextStyle(decoration: TextDecoration.underline, ),
                                ),
                            ),
                          ),*/
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              onPressed: (){
                                
                               kullaniciKontrol(noController.text, sifreController.text)
                                    .then((sonuc) {
                                  if(sonuc)
                                    {
                                      setState((){
                                        hataGoster = false;
                                      });
                                      
                                      Navigator.pushNamed(context, "/MainPage");
                                    }
                                  else
                                    {
                                      setState((){
                                        hataGoster = true;
                                      });
                                    }
                                });

                                // 1- veri tabanından kullanıcı bilgilerini çek
                                // 2- kullanıcı adı kısmına yazılan veri, elde edilen listede var mı kontrol et
                                // 3- varsa -> kullanıcı şifresi kutusundaki veri ile bu kullanıcı adının şifresi eşit mi kontrol et
                                // 4- eşitse -> Navigator.pushNamed(context, "/MainPage");
                                // 5- değilse -> Hata Text'ini görünür yap

                              },
                              child: Text("Giriş Yap"),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(20.0),
                                fixedSize: Size(400, 60),           //boyutlar
                                textStyle: TextStyle(fontSize: 18,),
                                shape: StadiumBorder(),   //radius şeklini ayarlar
                              ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 100,
                                    child: Divider(
                                      height: 20,
                                      color: Colors.blueAccent,
                                      thickness: 1,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: GestureDetector(
                                        child: Center(
                                            child: Text(
                                              "Kayıt Ol",
                                              style: TextStyle(
                                                  fontSize: 15,color: Colors.blueAccent,
                                              ),
                                            ),
                                        ),
                                      onTap:(){
                                        Navigator.pushNamed(context, "/Register");
                                      }
                                    ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 150,
                                    child: Divider(
                                      height: 20,
                                      color: Colors.blueAccent,
                                      thickness: 1,
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }

  Future<bool> kullaniciKontrol(String ogrenciNo, String sifre)
  async {
    var db = FirebaseFirestore.instance;
    var dbRef = await db.collection("users").get();

    try
    {
      var ogrenci = dbRef.docs.firstWhere((element) => element.data()["login_id"] == ogrenciNo && element.data()["password"] == sifre );
      KullaniciVeriTutucu.setLoggedUser(ogrenci);
      return true;
    }
    catch (E)
    {
      //print("HATA, VERI BULUNAMADI $E");
      return false;
    }
  }
}
