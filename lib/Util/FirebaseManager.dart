import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/OgrenciListModel.dart';

enum FirebaseManagerError {
  success,
  invalidStudentNumber,
  invalidLessonName
}

class FirebaseManager {

  static FirebaseManager shared = FirebaseManager();

  FirebaseManager();

  Future<FirebaseManagerError> derseKaydet(String ogrenciNo, String dersAdi, String devamsizlik) async {
    var kullaniciKoleksiyonu = FirebaseFirestore.instance.collection("users");
    var dersKoleksiyonu = FirebaseFirestore.instance.collection("lessons");

    var dersRef = dersKoleksiyonu.where("name", isEqualTo: dersAdi);
    var dersSnapshot = await dersRef.get();

    var ogrenciRef = kullaniciKoleksiyonu
        .where("login_id", isEqualTo: ogrenciNo)
        .where("type", isEqualTo: "student");

    var ogrenciSnapshot = await ogrenciRef.get();


    if (ogrenciSnapshot.docs.isEmpty) {
      return FirebaseManagerError.invalidStudentNumber;
    } else if (dersSnapshot.docs.isEmpty) {
      return FirebaseManagerError.invalidLessonName;
    }
    var ogrenciDoc = ogrenciSnapshot.docs.first;
    var dersDoc = dersSnapshot.docs.first;

    var ogrenciDersKoleksiyonu = ogrenciDoc.reference.collection("lessons");
    await ogrenciDersKoleksiyonu.doc(dersDoc.id).set({
      "devamsizlik": devamsizlik
    });

    var dersOgrenciKoleksiyonu = dersDoc.reference.collection("students");
    dersOgrenciKoleksiyonu.doc(ogrenciDoc.id).set({
      "devamsizlik": devamsizlik
    });

    return FirebaseManagerError.success;
  }

  Future<List<OgrenciListModel>> dersOgrenciListesi(String dersAdi) async {
    var dersKoleksiyonu = FirebaseFirestore.instance.collection("lessons");
    var dersRef = dersKoleksiyonu.where("name", isEqualTo: dersAdi);
    var dersSnapshot = await dersRef.get();

    if (dersSnapshot.docs.isEmpty) {
      return [];
    }

    var kullaniciKoleksiyonu = FirebaseFirestore.instance.collection("users");
    var ogrenciRef = kullaniciKoleksiyonu
        .where("type", isEqualTo: "student");

    var ogrenciSnapshot = await ogrenciRef.get();

    var dersDoc = dersSnapshot.docs.first;
    var dersOgrenciKoleksiyonu = dersDoc.reference.collection("students");

    List<OgrenciListModel> sonuc = [];

    await dersOgrenciKoleksiyonu.get().then(
            (value) async => {
          value.docs.forEach((element) {
            sonuc.add(ogrenciOlustur(element, ogrenciSnapshot));
          })
      });
    return sonuc;
  }

  OgrenciListModel ogrenciOlustur(QueryDocumentSnapshot<Map<String, dynamic>> devamsizlikSnapshot, QuerySnapshot<Map<String, dynamic>> ogrenciSnapshot) {
    var sonuc = OgrenciListModel();

    var ogrenciDoc = ogrenciSnapshot.docs.firstWhere((element) => element.id == devamsizlikSnapshot.id);

    sonuc.isimSoyisim = ogrenciDoc.data()["name"];
    sonuc.no = ogrenciDoc.data()["login_id"];
    sonuc.devamsizlik = devamsizlikSnapshot.data()["devamsizlik"];

    return sonuc;
  }
}