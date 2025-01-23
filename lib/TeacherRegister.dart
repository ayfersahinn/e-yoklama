import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';



class TeacherRegister extends StatefulWidget {
  const TeacherRegister({Key? key}) : super(key: key);

  @override
  State<TeacherRegister> createState() => _TeacherRegisterState();
}

class _TeacherRegisterState extends State<TeacherRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  bool hataGoster = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 110.0, horizontal: 30),
                child: Container(

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
                          child: Text("Kullanıcı Adı",style: TextStyle(fontSize: 14, color: Colors.white),),
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              hintText: "Kullanıcı Adı",
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
                          child: Text("E-mail",style: TextStyle(fontSize: 14, color: Colors.white),),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: "E-mail",
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
                          controller: sifreController,
                          obscureText: true,
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
              ),

            ],
          ),

        ),
      ),
    );
  }


  void veriEkle()async{
    if(nameController.text.trim().isEmpty
        || sifreController.text.trim().isEmpty
        || emailController.text.trim().isEmpty)
    {
      Fluttertoast.showToast(msg: "Tüm alanları doldurunuz.", toastLength: Toast.LENGTH_LONG);
      return;
    }
    var kullaniciKoleksiyonu = await FirebaseFirestore.instance.collection("users");
    var sonuc = await kullaniciKontrol(emailController.text);

    if(sonuc)
    {
      setState((){
        hataGoster = true;
      });
      Fluttertoast.showToast(msg: "Bu kullanıcı zaten kayıtlı.");

    }

    else
    {
      setState((){
        hataGoster = false;
      });
      var yeniKullanici = await kullaniciKoleksiyonu.add({


        'name':nameController.text,
        'login_id':emailController.text,
        'password':sifreController.text,
        'type': "teacher"
      });

      Fluttertoast.showToast(msg: "Bilgiler eklendi");
      Navigator.pushNamed(context, "/Teacher");
    }
  }

  Future<bool> kullaniciKontrol(String email)
  async {

    var db = FirebaseFirestore.instance;
    var dbRef = await db.collection("users").get();

    try
    {
      dbRef.docs.firstWhere((ogretmen) => ogretmen.data()["login_id"] == email);
      return true;
    }
    catch(E) // bulamazsa hata veriyor, hata verirse catch bloğuna düşüp false dönüyor
        {
      return false;
    }
  }
}
