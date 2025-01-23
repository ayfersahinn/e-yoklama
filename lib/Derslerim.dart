import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_yoklama/KullaniciVeriTutucu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main.dart';



class Derslerim extends StatefulWidget {
  const Derslerim({Key? key}) : super(key: key);

  @override
  State<Derslerim> createState() => _DerslerimState();
}


class _DerslerimState extends State<Derslerim> {
  
  String? seciliId;
  String icerik = "";
  String dersAdi = "Ders Adı: ";
  bool selectedOnce = false;
  List<DropdownMenuItem<String>>? _dersListesi;
  QueryDocumentSnapshot<Map<String, dynamic>>? _seciliDers;
  QueryDocumentSnapshot<Map<String, dynamic>>? _ogrenciDers;

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> dersBul(String dersId) async
  {
    var dersler = await FirebaseFirestore.instance.collection("lessons").get();

    try
    {
      return dersler.docs.firstWhere((iterasyonDers) => iterasyonDers.id == dersId);
    }
    catch (E)
    {
      return null;
    }
  }


  Future<List<DropdownMenuItem<String>>>? dersleriAl() async
  {
    var ogrenci = KullaniciVeriTutucu.getLoggedUser();
    var derslerKoleksiyonu = await ogrenci!.reference.collection("lessons").get();


    List<DropdownMenuItem<String>>? dersler = [];
    derslerKoleksiyonu.docs.forEach((element) {
      dersBul(element.id).then((bulunanDers) {
        if(bulunanDers != null)
          {
            dersler.add(DropdownMenuItem(child: Text(bulunanDers.data()["name"],style: TextStyle(fontSize: 15, color: Colors.grey[800],fontFamily: "Comfortaa",),), value: bulunanDers.id,),);
            try
            {
              setState((){
               _dersListesi = dersler;
              });
            }
            catch (E)
            {
              print("setState HATA: $E");
            }
          }
      });
    });

    return dersler;
  }
  @override
  Widget build(BuildContext context) {
    dersleriAl();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Derslerim",style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa",fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Center(
              child: Column(
                children:[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.only(left: 16,right: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 2,),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text("Bir Ders Seçiniz",style:TextStyle(fontSize: 15, color: Colors.grey[700],fontFamily: "Comfortaa",),),
                            items: _dersListesi,
                            value: seciliId,
                            onChanged: (value) async{
                              seciliId = value as String;
                              await dersBul(seciliId == null ? "" : seciliId!).then((value) {
                                _seciliDers = value;
                              });
                              var ogrenci = KullaniciVeriTutucu.getLoggedUser();
                              var collection = await ogrenci!.reference.collection("lessons").get();
                              _ogrenciDers = collection.docs.firstWhere((element) => element.id == _seciliDers?.id);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey[300],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Ders Adı : ",style:TextStyle(fontSize: 15, color: Colors.grey[800],fontFamily: "Comfortaa",)),
                                Text(_seciliDers == null ? "" : _seciliDers?.data()["name"] as String,style: TextStyle(fontSize: 15, color: Colors.grey[800],fontFamily: "Comfortaa",),),
                              ],
                            ),
                            SizedBox(height: 30,),
                            Row(
                              children:[
                                Text("Öğretim Üyesi : ",style:TextStyle(fontSize: 15, color: Colors.grey[800],fontFamily: "Comfortaa",)),
                                Text(_seciliDers == null ? "" : _seciliDers?.data()["teacher"] as String,style: TextStyle(fontSize: 15, color: Colors.grey[800],fontFamily: "Comfortaa",),),
                              ]
                            ),
                            SizedBox(height: 30,),
                            Row(
                              children:[
                                Text("Devamsızlık Bilgisi : ",style:TextStyle(fontSize: 15, color: Colors.grey[800],fontFamily: "Comfortaa",)),
                                Text(_ogrenciDers == null ? "" : _ogrenciDers!.data()["devamsizlik"].toString(),style: TextStyle(fontSize: 15, color: Colors.grey[800],fontFamily: "Comfortaa",),),
                              ]
                            ),
                            SizedBox(height: 30,),

                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
        ),
      ),
    );
  }
}
