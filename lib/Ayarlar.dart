import 'package:flutter/material.dart';

class Ayarlar extends StatefulWidget {
  const Ayarlar({Key? key}) : super(key: key);

  @override
  State<Ayarlar> createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar",style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa", fontWeight: FontWeight.bold),),
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
                      Navigator.pushNamed(context, "/Password");
                    },
                    child: Text("Şifre Değiştir"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20.0),
                      textStyle: TextStyle(fontSize: 18, color: Colors.grey[700],fontFamily: "Comfortaa",),
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
