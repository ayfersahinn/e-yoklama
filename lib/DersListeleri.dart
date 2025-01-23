import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DersListeleri extends StatefulWidget {
  const DersListeleri({Key? key}) : super(key: key);

  @override
  State<DersListeleri> createState() => _DersListeleriState();
}

class _DersListeleriState extends State<DersListeleri> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          title: Text("Ders Listesi", style: TextStyle(fontSize: 20,
        color: Colors.white,
        fontFamily: "Comfortaa",
        fontWeight: FontWeight.bold)
        ),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0,left: 10,right: 10),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("lessons")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data!.docs;

                      return Flexible(
                        child: ListView.builder(
                          itemCount: listOfDocumentSnap.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: FlatButton(
                                onPressed: (){
                                  Navigator.pushNamed(context, "/DersIcerikleri", arguments: '${listOfDocumentSnap[index]["name"]}');
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.green, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(

                                    title: Column(
                                      children: [

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(

                                            '${listOfDocumentSnap[index]["name"]}',
                                            style: TextStyle(fontSize: 20,fontFamily: "Comfortaa",),

                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${listOfDocumentSnap[index]["teacher"]}',
                                            style: TextStyle(fontSize: 13,fontFamily: "Comfortaa",),

                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        await listOfDocumentSnap[index]
                                            .reference
                                            .delete();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );

                          },
                        ),
                      );
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, "/ogrenciEkle");
      },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      ),
    );

  }

}
