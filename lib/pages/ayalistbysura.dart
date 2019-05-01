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
    var jsonString = await rootBundle.loadString("assets/quran/104.json");
    setState(() {
      this.AllSuraListArabic = json.decode(jsonString);
    });
    print(this.AllSuraListArabic.length);
    print(this.AllSuraListArabic[0]["verse"].length);
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
            itemCount: 9,
            itemBuilder: (BuildContext contect, int i) => Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: EdgeInsets.all(5),
                child: new Container(

                  padding:
                  EdgeInsets.symmetric(horizontal: 5, vertical: 15),
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
                                    style: TextStyle(fontSize: 17, )),
                                foregroundColor: Colors.teal,
                                backgroundColor: Colors.transparent,
                                radius: 10,

                              ),
                            ],
                          ),
                          Expanded(
                              child: Text(
                                AllSuraListArabic[0]["verse"]["verse_${i + 1}"],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 30),
                                textAlign: TextAlign.right,
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
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
                      SizedBox(height: 15,),
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