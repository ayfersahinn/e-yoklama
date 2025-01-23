import 'package:e_yoklama/Models/OgrenciListModel.dart';
import 'package:e_yoklama/Util/FirebaseManager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_yoklama/KullaniciVeriTutucu.dart';

class DersIcerikleri extends StatefulWidget {
  const DersIcerikleri({Key? key}) : super(key: key);

  @override
  State<DersIcerikleri> createState() => _DersIcerikleriState();
}

class _DersIcerikleriState extends State<DersIcerikleri> {

  List<OgrenciListModel> ogrenciListesi = [];

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          title: Text(title, style: TextStyle(fontSize: 20,             //burası yanlış her dersin kendi adı yazmalı!!
              color: Colors.white,
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.bold)
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: buildContainer("No")),
                    Expanded(child: buildContainer("İsim-Soyisim")),
                    Expanded(child:  buildContainer("Devamsızlık"))
                  ],
                ),
                Expanded(
                  child: FutureBuilder(future: ogrenciListeAl(title),
                      builder: (context, snapshot) {
                        ListView children;
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: ogrenciListesi.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                      Expanded(child: maddeler(ogrenciListesi[index].no ?? "HATA")),
                                      Expanded(child: maddeler(ogrenciListesi[index].isimSoyisim ?? "HATA")),
                                      Expanded(child: maddeler(ogrenciListesi[index].devamsizlik ?? "HATA"))
                                      ],
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.grey,
                                    )
                                  ],
                                );
                              }
                          );
                        } else if(snapshot.hasError) {
                          return Text("ERROR");
                        }
                        return Text("WAITING");
                      }),
                ),
                /*Expanded(child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(child: maddeler("testNo")),
                        Expanded(child: maddeler("textIsim")),
                        Expanded(child: maddeler("testDevamsizlik"))
                      ],
                    );
                  },
                ))*/
              ],
            ),
          ),
        ),

      ),
    );
  }

  Widget buildContainer(String text) {
    return Container(
      width: double.infinity,
      color: Colors.red[900],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontFamily: "Comfortaa",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  Widget maddeler(String text) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<List<OgrenciListModel>> ogrenciListeAl(String title) {
    var sonuc = FirebaseManager.shared.dersOgrenciListesi(title);
    sonuc.then((value) => {
      ogrenciListesi = value
    });
    return sonuc;
  }


}
