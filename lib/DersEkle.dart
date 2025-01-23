import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DersEkle extends StatefulWidget {
  const DersEkle({Key? key}) : super(key: key);

  @override
  State<DersEkle> createState() => _DersEkleState();
}

class _DersEkleState extends State<DersEkle> {
  TextEditingController dersController = TextEditingController();
  TextEditingController ogretmenController = TextEditingController();

  bool hataGoster = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Ekle", style: TextStyle(fontSize: 20,
            color: Colors.white,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: dersController,
                  decoration: InputDecoration(
                    hintText: "Ders Adı",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blueAccent),
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
                  controller: ogretmenController,
                  decoration: InputDecoration(
                    hintText: "Öğretmen Adı",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    prefixIcon: Icon(
                      Icons.account_circle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      veriEkle();
                    },

                    child: Text("Kaydet"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.all(20.0),
                      textStyle: TextStyle(fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Comfortaa",
                          fontWeight: FontWeight.bold),
                      shape: StadiumBorder(), //radius şeklini ayarlar
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
    if (dersController.text
        .trim()
        .isEmpty
        || ogretmenController.text
            .trim()
            .isEmpty
    ) {
      Fluttertoast.showToast(
          msg: "Tüm alanları doldurunuz.", toastLength: Toast.LENGTH_LONG);
      return;
    }
    var kullaniciKoleksiyonu = await FirebaseFirestore.instance.collection(
        "lessons");
    var sonuc = await kullaniciKontrol(dersController.text);

    if (sonuc) {
      setState(() {
        hataGoster = true;
      });
      Fluttertoast.showToast(msg: "Bu ders zaten kayıtlı.");
    }

    else {
      setState(() {
        hataGoster = false;
      });
      var yeniKullanici = await kullaniciKoleksiyonu.add({


        'name': dersController.text,
        'teacher': ogretmenController.text,

      });

      Fluttertoast.showToast(msg: "Bilgiler eklendi");
      Navigator.pushNamed(context, "/DersListeleri");
    }
  }

  Future<bool> kullaniciKontrol(String dersAdi) async {
    var db = FirebaseFirestore.instance;
    var dbRef = await db.collection("lessons").get();

    try {
      dbRef.docs.firstWhere((ders) => ders.data()["name"] == dersAdi);
      return true;
    }
    catch (E) // bulamazsa hata veriyor, hata verirse catch bloğuna düşüp false dönüyor
        {
      return false;
    }
  }
}
