import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:share/share.dart';

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
  var shareText;
  var onlyArabic = true;
  var onlyBangla = true;
  var onlyEnglish = true;
  final snackBarkey = new GlobalKey<ScaffoldState>();

  loadAllSuraListData() async {
    var jsonString = await rootBundle
        .loadString("assets/quran/${this.suranInfo['id']}.json");
    setState(() {
      this.AllSuraListArabic = json.decode(jsonString);
      this.ayaCount = int.parse("${this.suranInfo['total_verses']}");
    });
  }

  @override
  void initState() {
    loadAllSuraListData();
    super.initState();
    controller = new TabController(vsync: null, length: 1, initialIndex: 0);
  }

  getBismillah(i, j) {
    if (i != null && i == 0) {
      return j;
    } else {
      return "";
    }
  }

  showToast(String txt) {
    Fluttertoast.showToast(
        msg: " ${txt} কপি সম্পন্ন হয়েছে ",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _showDialog(
      context, String ayaNum, String arabicTxt, String bnTxt, String enTxt) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.teal,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.content_copy),
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(
                                text:
                                    "সূরা ${this.suranInfo['bangla_name']}: (${this.suranInfo['id']}:${ayaNum}): \n ${bnTxt}"));
                            Navigator.of(context).pop();
                            showToast("${this.suranInfo['id']}:${ayaNum}");
                          },
                        ),
                        Text("বাংলা কপি"),
                      ],
                    ),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(
                          text:
                              "সূরা ${this.suranInfo['bangla_name']}: (${this.suranInfo['id']}:${ayaNum}): \n ${bnTxt}"));
                      Navigator.of(context).pop();
                      showToast("${this.suranInfo['id']}:${ayaNum}");
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.teal,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.content_copy),
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(
                                text:
                                    "সূরা ${this.suranInfo['bangla_name']}: (${this.suranInfo['id']}:${ayaNum}): \n ${arabicTxt} \n ${bnTxt}"));
                            Navigator.of(context).pop();
                            showToast("${this.suranInfo['id']}:${ayaNum}");
                          },
                        ),
                        Text("আরবি + বাংলা কপি"),
                      ],
                    ),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(
                          text:
                              "সূরা ${this.suranInfo['bangla_name']}: (${this.suranInfo['id']}:${ayaNum}): \n ${arabicTxt} \n ${bnTxt}"));
                      Navigator.of(context).pop();
                      showToast("${this.suranInfo['id']}:${ayaNum}");
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.teal,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.content_copy),
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(
                                text:
                                    "${this.suranInfo['transliteration_en']}: (${this.suranInfo['id']}:${ayaNum}): \n ${arabicTxt} \n ${enTxt}"));
                            Navigator.of(context).pop();
                            showToast("${this.suranInfo['id']}:${ayaNum}");
                          },
                        ),
                        Text("আরবি + ইংরেজি কপি"),
                      ],
                    ),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(
                          text:
                              "${this.suranInfo['transliteration_en']}: (${this.suranInfo['id']}:${ayaNum}): \n ${arabicTxt} \n ${enTxt}"));
                      Navigator.of(context).pop();
                      showToast("${this.suranInfo['id']}:${ayaNum}");
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.tealAccent),
            title: Text("সূরা " + this.suranInfo["bangla_name"]),
            centerTitle: true,
            actions: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.teal,
                ),
                child: PopupMenuButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  offset: Offset(0, 35),
                  elevation: 10,
                  onSelected: (value) {
                    if (value == 'arEng') {
                      setState(() {
                        this.onlyEnglish = true;
                        this.onlyBangla = false;
                        this.onlyArabic = true;
                      });
                    } else if (value == 'arBng') {
                      setState(() {
                        this.onlyEnglish = false;
                        this.onlyBangla = true;
                        this.onlyArabic = true;
                      });
                    } else if (value == 'onlyEng') {
                      setState(() {
                        this.onlyEnglish = true;
                        this.onlyBangla = false;
                        this.onlyArabic = false;
                      });
                    } else if (value == 'onlyBng') {
                      setState(() {
                        this.onlyEnglish = false;
                        this.onlyBangla = true;
                        this.onlyArabic = false;
                      });
                    } else if (value == 'onlyAr') {
                      setState(() {
                        this.onlyEnglish = false;
                        this.onlyBangla = false;
                        this.onlyArabic = true;
                      });
                    } else if (value == 'all') {
                      setState(() {
                        this.onlyEnglish = true;
                        this.onlyBangla = true;
                        this.onlyArabic = true;
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      CheckedPopupMenuItem(
                        child: ListTileTheme(
                          iconColor: Colors.white,
                          child: Text("Arbic + English",
                              style: TextStyle(color: Colors.white)),
                        ),
                        checked: false,
                        value: "arEng",
                      ),
                      CheckedPopupMenuItem(
                        child: Text("আরবি + বাংলা",
                            style: TextStyle(color: Colors.white)),
                        checked: false,
                        value: "arBng",
                      ),
                      CheckedPopupMenuItem(
                        child: Text("Only English",
                            style: TextStyle(color: Colors.white)),
                        checked: false,
                        value: "onlyEng",
                      ),
                      CheckedPopupMenuItem(
                        child: Text("শুধু বাংলা",
                            style: TextStyle(color: Colors.white)),
                        checked: false,
                        value: "onlyBng",
                      ),
                      CheckedPopupMenuItem(
                        child: Text("Only Arabic",
                            style: TextStyle(color: Colors.white)),
                        checked: false,
                        value: "onlyAr",
                      ),
                      CheckedPopupMenuItem(
                        child: Text("All",
                            style: TextStyle(color: Colors.white)),
                        checked: true,
                        value: "all",
                      ),
                    ];
                  },
                ),
              )
            ],
          )),
      body: Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: this.ayaCount,
            itemBuilder: (BuildContext context, int i) => Container(
                child: new Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    child: GestureDetector(
                      onLongPress: () {
                        _showDialog(
                            context,
                            "${i + 1}",
                            AllSuraListArabic[0]["verse"]["verse_${i + 1}"],
                            AllSuraListArabic[0]["verse_bn"]["verse_${i + 1}"],
                            AllSuraListArabic[0]["verse_en"]["verse_${i + 1}"]);
                      },
                      child: Column(
                        children: <Widget>[
                          Text(
                            getBismillah(
                                i, AllSuraListArabic[0]["verse"]["verse_${i}"]),
                            style: TextStyle(color: Colors.teal, fontSize: 20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        child: Text("${i + 1}",
                                            style: TextStyle(
                                              fontSize: 17,
                                            )),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.teal,
                                        radius: 20,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            shareText =
                                                "সূরা ${this.suranInfo['bangla_name']}: (${this.suranInfo['id']} : " +
                                                    "${i + 1})\n" +
                                                    AllSuraListArabic[0]
                                                            ["verse"]
                                                        ["verse_${i + 1}"] +
                                                    ",\n" +
                                                    AllSuraListArabic[0]
                                                            ["verse_bn"]
                                                        ["verse_${i + 1}"];
                                          });
                                          Share.share(shareText);
                                        },
                                        icon: Icon(Icons.share),
                                        color: Colors.blueGrey,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    child: Visibility(
                                        visible: onlyArabic,
                                        //Default is true,
                                        child: Text(
                                          AllSuraListArabic[0]["verse"]
                                              ["verse_${i + 1}"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Scheherazade',
                                              fontSize: 30),
                                          textAlign: TextAlign.right,
                                        ))),
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
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      child: Visibility(
                                        visible: onlyEnglish,
                                        //Default is true,
                                        child: Text(
                                            AllSuraListArabic[0]["verse_en"]
                                                ["verse_${i + 1}"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 20),
                                            textAlign: TextAlign.start),
                                      ),
                                    ),
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
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      child: Visibility(
                                        visible: onlyBangla,
                                        //Default is true,
                                        child: Text(
                                          AllSuraListArabic[0]["verse_bn"]
                                              ["verse_${i + 1}"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
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
                    )),
                decoration: new BoxDecoration(
                    border:
                        new Border(bottom: BorderSide(color: Colors.teal))))),
      ),
    );
  }
}
