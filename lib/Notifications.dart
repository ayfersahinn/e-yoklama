import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bildirimler",style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Comfortaa", fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(

        ),
      ),
    );
  }
}
