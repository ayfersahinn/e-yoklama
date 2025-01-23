
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:e_yoklama/KullaniciVeriTutucu.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ResimKaresi extends StatefulWidget{

  ResimKaresi(
      {
    super.key,
        this.secilenDosya
  });

  File? secilenDosya;

  @override
  State<ResimKaresi> createState() => ResimNesnesi();

}

class ResimNesnesi extends State<ResimKaresi>
{
  Widget decideImage(){
    if(widget.secilenDosya == null)
    {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Icon(Icons.add_a_photo_rounded,size: 50,color: Colors.grey[700],),
      );
    }
    else
    {
      return Image.file(widget.secilenDosya!);
    }

  }


  void resimYukle(ImageSource source)async{
    var kullanici = KullaniciVeriTutucu.getLoggedUser();
    final picker = ImagePicker();
    final secilen = await picker.getImage(source: source);



    setState((){
      if(secilen != null)
      {
        widget.secilenDosya = File(secilen.path);
      }
    });

    Navigator.pop(context);
    return;

    UploadTask uploadTask;
    String indirmeBaglantisi;
    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("Pictures")
        .child(kullanici!.id)
        .child("profile");


    //uploadTask = referansYol.putFile(secilenDosya!);
    String link = await referansYol.getDownloadURL();
    setState((){
      indirmeBaglantisi=link;
    });
    /*await Clipboard.setData(
      ClipboardData(
        text: link,
      ),
    );*/
    Navigator.pop(context);
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
  @override
  Widget build(BuildContext context)
  {
    return  Expanded(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[300]
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      secimGoster(context);
                    },
                    child: Stack(children: [
                      decideImage() ,
                      Align(alignment: Alignment.topRight,
                        child:Visibility(
                            visible: widget.secilenDosya != null,
                            child: FloatingActionButton.small(
                              backgroundColor: Colors.grey,
                              onPressed: (){
                              setState(() => widget.secilenDosya = null);
                              widget.secilenDosya = null;
                            },
                              child: Icon(Icons.cancel_rounded,),

                            ),
                        ),
                      ),
                    ],),

                    // icon: Icon(Icons.add_a_photo_rounded,size: 50,color: Colors.grey[700],),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}