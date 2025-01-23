import 'package:flutter/material.dart';

class DersKayitlari extends StatefulWidget {
  const DersKayitlari({Key? key}) : super(key: key);

  @override
  State<DersKayitlari> createState() => _DersKayitlariState();
}

class _DersKayitlariState extends State<DersKayitlari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Kayıtları",style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa", fontWeight: FontWeight.bold),),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, "/DersEkle");
                    },

                    child: Text("Ders Ekle"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.all(20.0),
                      textStyle: TextStyle(fontSize: 18, color: Colors.white,fontFamily: "Comfortaa",fontWeight: FontWeight.bold),
                      shape: StadiumBorder(),   //radius şeklini ayarlar
                    ),

                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                onPressed: (){
                Navigator.pushNamed(context, "/DersListeleri");
                },

                child: Text("Ders Listeleri"),
                style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.all(20.0),
                textStyle: TextStyle(fontSize: 18, color: Colors.white,fontFamily: "Comfortaa",fontWeight: FontWeight.bold),
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
}
