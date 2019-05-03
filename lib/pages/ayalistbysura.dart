import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AyaListBySura extends StatefulWidget {
  var suraInfo;

  AyaListBySura(this.suraInfo);

  AyaListBytate createState() => AyaListBytate(this.suraInfo);
}

class AyaListBytate extends State<AyaListBySura> {
  var suranInfo;

  AyaListBytate(this.suranInfo);

  TabController controller;

  List AllSuraListArabic = [];
  List AllSuraListbengali = [];
  var ayaCount = 0;
  var ayaNumberBn;

  loadAllSuraListData() async {
    print("${this.suranInfo['id']}");
    var jsonString = await rootBundle
        .loadString("assets/quran/${this.suranInfo['id']}.json");
    setState(() {
      this.AllSuraListArabic = json.decode(jsonString);
      this.ayaCount = int.parse("${this.suranInfo['total_verses']}");
      print("Aya count '${this.ayaCount}'");

    });
  }

  loadAllSuraListAData() async {
    var jsonString = await rootBundle.loadString("assets/quran_bengali.json");
    setState(() {
      this.AllSuraListbengali = json.decode(jsonString);
    });
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
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("সূরা " + this.suranInfo["bangla_name"]),
            centerTitle: true,
          )),
      body: Container(
        child: ListView.builder(
            itemCount: this.ayaCount,
            itemBuilder: (BuildContext contect, int i) => Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: EdgeInsets.all(5),
                child: new Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircleAvatar(
                                child: Text("${i + 1}",
                                    style: TextStyle(
                                      fontSize: 17,
                                    )),
                                foregroundColor: Colors.teal,
                                backgroundColor: Colors.transparent,
                                radius: 10,
                              ),
                            ],
                          ),
                          Expanded(
                              child: Text(
                            AllSuraListArabic[0]["verse"]["verse_${i+1}"],
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 30),
                            textAlign: TextAlign.right,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    AllSuraListArabic[0]["verse_en"]
                                        ["verse_${i + 1}"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    AllSuraListArabic[0]["verse_bn"]
                                        ["verse_${i + 1}"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: new BoxDecoration(
                    border:
                        new Border(bottom: BorderSide(color: Colors.teal))))),
      ),
    );
  }
}
