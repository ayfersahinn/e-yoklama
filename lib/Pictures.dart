
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_yoklama/ResimKaresi.dart';

import 'KullaniciVeriTutucu.dart';

class Pictures extends StatefulWidget {
  const Pictures({Key? key}) : super(key: key);
  @override
  State<Pictures> createState() => _PicturesState();
}

class _PicturesState extends State<Pictures> {


  static List<ResimKaresi>? resimKareleri;

  List<ResimKaresi> listeOlustur(int sayi)
  {
    List<ResimKaresi> sonuc = [];
    for(int i = 0; i < sayi; i++)
    {
      sonuc.add(ResimKaresi());
    }

    return sonuc;
  }
  Widget satirOlustur(int elemanSayisi, double width)
  {
    List<Widget> liste = [];

    for (int i = 0; i < elemanSayisi-1; i++)
    {

        resimKareleri?.add(ResimKaresi());
        liste.add(resimKareleri!.last);
        liste.add(SizedBox(width: width,));
    }
    resimKareleri?.add(ResimKaresi());
    liste.add(resimKareleri!.last);
    return Row(
      children: liste,
    );
  }

  Widget tabloOlustur(int satir, int sutun, double sutunArasiBosluk, double satirArasiBosluk)
  {
    List<Widget> sonuc = [];
    for(int i = 0; i < satir; i++)
    {
        sonuc.add(satirOlustur(sutun, sutunArasiBosluk));
        sonuc.add(SizedBox(height: satirArasiBosluk));
    }
    return Column(
      children: sonuc,
    );
  }
  @override
  Widget build(BuildContext context) {
    resimKareleri = [];
    return WillPopScope(
      onWillPop: () async{
        resimKareleri = null;
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Fotoğraf Yükle",style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa", fontWeight: FontWeight.bold),),
            centerTitle: true,
            backgroundColor: Colors.grey[800],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(

                children: [
                  tabloOlustur(3, 3, 15, 30),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context, resimKareleri);
                    },
                    child: Text("Kaydet"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
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
      ),
    );
  }
}
