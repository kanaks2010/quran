import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AyaListBySura extends StatefulWidget {
  AyaListBytate createState() => AyaListBytate();
}

class AyaListBytate extends State<AyaListBySura> {
  TabController controller;

  List AllSuraListArabic = [];
  List AllSuraListbengali = [];

  loadAllSuraListData() async {
    var jsonString = await rootBundle.loadString("assets/quran_arabic.json");
    setState(() {
      this.AllSuraListArabic = json.decode(jsonString);
    });
    print(this.AllSuraListArabic.length);
  }

  loadAllSuraListAData() async {
    var jsonString = await rootBundle.loadString("assets/quran_bengali.json");
    setState(() {
      this.AllSuraListbengali = json.decode(jsonString);
    });
    print(this.AllSuraListbengali.length);
  }

  @override
  void initState() {
    loadAllSuraListAData();
    loadAllSuraListData();
    super.initState();
    controller = new TabController(vsync: null, length: 1, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            backgroundColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(""),
          )),
      body: Container(
        child: ListView.builder(
            itemCount: AllSuraListArabic.length,
            itemBuilder: (BuildContext contect, int i) => Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: EdgeInsets.all(5),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(AllSuraListArabic[i]["AyahTextAr"],
                          textAlign: TextAlign.right, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      new Text(AllSuraListbengali[i]['id'] + AllSuraListbengali[i]['text'],
                        textAlign: TextAlign.left, style: TextStyle(fontSize: 20),),
                    ],
                  ),
                  decoration: new BoxDecoration(
                      border: new Border(bottom: BorderSide(color: Colors.teal)))
                )),
      ),
    );
  }
}
