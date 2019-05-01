import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/pages/ayalistbysura.dart';

class SuraList extends StatefulWidget {
  SuraListState createState() => SuraListState();
}

class SuraListState extends State<SuraList> {
  final suraBgc = const Color(0xFFbadc57);

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: null, length: 1, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Color(0xFF009484),
            iconTheme: IconThemeData(color: Colors.white),
            title:  Text(""),
          )),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          SuraItem(),
        ],
      ),
    );
  }
}

class SuraItem extends StatefulWidget {


  SuraItemState createState() => SuraItemState();
}

class SuraItemState extends State<SuraItem> {
  var suraBgc = const Color(0xFFA2D0C9);
  var suraBgc23 = const Color(0xFF2ecc72);
  var suraBgc2 = const Color(0xFF50A9B7);

  List QranListData = [];
  List AllSuraList = [];
  String imgUrl;

  loadQranListData() async {
    var jsonString = await rootBundle.loadString('assets/sura_list.json');
    setState(() {
      this.QranListData = json.decode(jsonString);
    });
  }
  @override
  void initState() {
    super.initState();
    loadQranListData();
  }

  String _setImage(String imgtext) {
    if (imgtext == "Meccan") {
      this.imgUrl = "assets/images/makka.png";
    } else {
      this.imgUrl = "assets/images/madina.png";
    }
    return this.imgUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Color(0xFF2C3335),
          child: ListView.builder(
              itemCount: QranListData.length,
              itemBuilder: (BuildContext context, int i) => Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: GestureDetector(
                    onTapUp: (val) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AyaListBySura(QranListData[i])),
                      );
                    },
                    child: Card(
                      color: suraBgc,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(

                        padding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.asset(
                                  _setImage(QranListData[i]["revelation_type"]),
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text("${QranListData[i]["number"]}",
                                    style: TextStyle(fontSize: 17, )),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  QranListData[i]["bangla_name"] +
                                      ""
                                          "(${QranListData[i]['total_verses_b']})",
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            Container(),
                            Text(QranListData[i]["name"],
                                style: TextStyle(
                                  fontSize: 17,fontWeight: FontWeight.bold
                                )),
                          ],
                        ),
                      ),
                    ),
                  ))),
        ),
      ),
    );
  }
}
