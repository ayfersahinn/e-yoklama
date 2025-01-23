import 'package:cloud_firestore/cloud_firestore.dart';

class KullaniciVeriTutucu
{
  static QueryDocumentSnapshot<Map<String, dynamic>>? girisYapanKullanici;

  static void setLoggedUser(QueryDocumentSnapshot<Map<String, dynamic>> user)
  {
    girisYapanKullanici = user;
  }

  static QueryDocumentSnapshot<Map<String, dynamic>>? getLoggedUser()
  {
    return girisYapanKullanici;
  }
}