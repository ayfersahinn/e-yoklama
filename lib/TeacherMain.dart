
import 'package:e_yoklama/KullaniciVeriTutucu.dart';
import 'package:flutter/material.dart';
class TeacherMain extends StatefulWidget {
  const TeacherMain({Key? key}) : super(key: key);

  @override
  State<TeacherMain> createState() => _TeacherMain();
}

class _TeacherMain extends State<TeacherMain> {
  @override
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(

          actions:[
            GestureDetector(
              child: IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, "/Notifications");
                },
                icon: Icon(Icons.notifications_active_rounded),

              ),
            ),
          ],
          title: Text("e-Yoklama",style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa",fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              Container(
                height: 200,
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.grey[800],
                child: DrawerHeader(
                  child: Image.asset("assets/images/harran.png",width: 250,),
                ),
              ),

              myDrawerItem(Icons.account_circle, "Öğretmen Profil", "/TeacherProfile"),
              myDrawerItem(Icons.menu_book_rounded, "Ders Kayıtları", "/DersKayitlari"),
              myDrawerItem(Icons.settings, "Ayarlar", "/Ayarlar"),
              myDrawerItem(Icons.logout_rounded, "Çıkış", "/LoginPage")

            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only( left: 10,top: 30, bottom: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Hoş Geldin, " + (KullaniciVeriTutucu.getLoggedUser() != null  // kullanici bilgisi null değilse ->
                        ? KullaniciVeriTutucu.getLoggedUser()!["name"].toString()      // giris yapan kullanicinin ismini yaz
                        : "HATALI ISIM"),   // null ise hata mesajı koy
                      style: TextStyle(fontSize: 25, color: Colors.grey[800],fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      mainItems("assets/images/user.png", "/TeacherProfile", "Öğretmen Profil"),
                      SizedBox(
                        width: 15,
                      ),
                      mainItems("assets/images/favorite.png", "/DersKayitlari", "Ders Kayıtları"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      mainItems("assets/images/setting.png", "/Ayarlar", "Ayarlar"),
                      SizedBox(
                        width: 15,
                      ),
                      mainItems("assets/images/log-out.png", "/LoginPage", "Çıkış"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget myDrawerItem(IconData icon, String title, String routeName ) =>

      Card(
        child: ListTile(
          leading: Icon(
            icon,
            size: 28,
          ),

          title: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.grey[800],fontFamily: "Comfortaa"),
          ),
          onTap: (){
            _scaffoldKey.currentState!.openEndDrawer();
            Navigator.pushNamed(context, routeName);
          },
        ),
      );

  Widget mainItems(String image , String routeName, String title) =>
      Expanded(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[300]
          ),
          child: GestureDetector(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
                  child: Image.asset(image),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,
                    style: TextStyle(fontSize: 15, color: Colors.grey[800],fontFamily: "Comfortaa",fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            onTap: (){
              Navigator.pushNamed(context, routeName);
            },
          ),
        ),
      );
}

