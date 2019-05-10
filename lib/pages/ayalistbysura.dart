import 'dart:convert';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
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
  var arEng = false;
  var arBng = false;
  var onlyEng = false;
  var onlyBng = false;
  var onlyAr = false;
  var all = true;
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
  Widget arrowThumbs(ayaCount){
    ScrollController _arrowsController = ScrollController();
    return DraggableScrollbar.arrows(
      // labelTextBuilder: (double offset) => Text("${i}"),
      controller: _arrowsController,
      scrollbarAnimationDuration: Duration(seconds: 1),
      scrollbarTimeToFade: Duration(seconds: 2),
      backgroundColor: Colors.teal,
      child:
      ListView.builder(
        controller: _arrowsController,
        itemCount: ayaCount,
        itemBuilder: (context, i) {
          return
            Container(
              child: Material(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(4.0),
                child:
                Container(
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
                          Container(
                            padding: i == 0 ? EdgeInsets.only(bottom: 25) : EdgeInsets.only(bottom: 0),
                            child: Text(
                              getBismillah(
                                  i, AllSuraListArabic[0]["verse"]["verse_${i}"]),
                              style: TextStyle(color: Colors.teal, fontSize: 20),
                            ),
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
                                          style: TextStyle( color: Color(0xFF000000),
                                              fontWeight: FontWeight.w400, wordSpacing: 0.5,
                                              fontFamily: 'Lateef',
                                              fontSize: 40, letterSpacing: 0),
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
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.w200,
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
                                            fontWeight: FontWeight.w400,
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
              ),
            );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    ScrollController _arrowsController = ScrollController(initialScrollOffset: 50.0);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),

          child: AppBar(
            backgroundColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.tealAccent),
            title: Text( this.suranInfo["number"] + ": সূরা " + this.suranInfo["bangla_name"] +
                " (" +this.suranInfo["total_verses_b"]+ ")"
            , style: TextStyle(fontSize: 16),),
            centerTitle: true,
            actions: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.teal,
                ),
                child: InkWell(
                  onTap: (){},
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
                          this. arEng = true;
                          this. arBng = false;
                          this. onlyEng = false;
                          this. onlyBng = false;
                          this. onlyAr = false;
                          this. all = false;
                        });
                      } else if (value == 'arBng') {
                        setState(() {
                          this.onlyEnglish = false;
                          this.onlyBangla = true;
                          this.onlyArabic = true;
                          this. arEng = false;
                          this. arBng = true;
                          this. onlyEng = false;
                          this. onlyBng = false;
                          this. onlyAr = false;
                          this. all = false;
                        });
                      } else if (value == 'onlyEng') {
                        setState(() {
                          this.onlyEnglish = true;
                          this.onlyBangla = false;
                          this.onlyArabic = false;
                          this. arEng = false;
                          this. arBng = false;
                          this. onlyEng = true;
                          this. onlyBng = false;
                          this. onlyAr = false;
                          this. all = false;
                        });
                      } else if (value == 'onlyBng') {
                        setState(() {
                          this.onlyEnglish = false;
                          this.onlyBangla = true;
                          this.onlyArabic = false;
                          this. arEng = false;
                          this. arBng = false;
                          this. onlyEng = false;
                          this. onlyBng = true;
                          this. onlyAr = false;
                          this. all = false;
                        });
                      } else if (value == 'onlyAr') {
                        setState(() {
                          this.onlyEnglish = false;
                          this.onlyBangla = false;
                          this.onlyArabic = true;
                          this. arEng = false;
                          this. arBng = false;
                          this. onlyEng = false;
                          this. onlyBng = false;
                          this. onlyAr = true;
                          this. all = false;
                        });
                      } else if (value == 'all') {
                        setState(() {
                          this.onlyEnglish = true;
                          this.onlyBangla = true;
                          this.onlyArabic = true;
                          this.arEng = false;
                          this.arBng = false;
                          this.onlyEng = false;
                          this.onlyBng = false;
                          this.onlyAr = false;
                          this.all = true;
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
                          checked: this.arEng,
                          value: "arEng",
                        ),
                        CheckedPopupMenuItem(
                          child: Text("আরবি + বাংলা",
                              style: TextStyle(color: Colors.white)),
                          checked: this.arBng,
                          value: "arBng",
                        ),
                        CheckedPopupMenuItem(
                          child: Text("Only English",
                              style: TextStyle(color: Colors.white)),
                          checked: this.onlyEng,
                          value: "onlyEng",
                        ),
                        CheckedPopupMenuItem(
                          child: Text("শুধু বাংলা",
                              style: TextStyle(color: Colors.white)),
                          checked: this.onlyBng,
                          value: "onlyBng",
                        ),
                        CheckedPopupMenuItem(
                          child: Text("Only Arabic",
                              style: TextStyle(color: Colors.white)),
                          checked: this.onlyAr,
                          value: "onlyAr",
                        ),
                        CheckedPopupMenuItem(
                          child: Text("All",
                              style: TextStyle(color: Colors.white)),
                          checked: this.all,
                          value: "all",
                        ),
                      ];
                    },
                  ),
                ),
              ),
            ],
            titleSpacing: 0,
          )),
      body: Container(
        child: arrowThumbs(this.ayaCount)
        /*DraggableScrollbar.arrows(
            labelTextBuilder: (double offset) => Text("${offset ~/ this.ayaCount}"),
            //controller: _arrowsController.position.applyNewDimensions(),
            scrollbarAnimationDuration: Duration(seconds: 3),
            padding: EdgeInsets.all(2),
            alwaysVisibleScrollThumb: true,
            child:
            ListView.builder(
                itemCount: this.ayaCount,
                itemExtent: 10,
                itemBuilder: (BuildContext context, int i) => Container(
                    child: new

                    Container(
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
                              Container(
                                padding: i == 0 ? EdgeInsets.only(bottom: 25) : EdgeInsets.only(bottom: 0),
                                child: Text(
                                  getBismillah(
                                      i, AllSuraListArabic[0]["verse"]["verse_${i}"]),
                                  style: TextStyle(color: Colors.teal, fontSize: 20),
                                ),
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
                                              style: TextStyle( color: Color(0xFF000000),
                                                  fontWeight: FontWeight.w400, wordSpacing: 0.5,
                                                  fontFamily: 'Lateef',
                                                  fontSize: 40, letterSpacing: 0),
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
                                                    fontFamily: 'Kelly Slab',
                                                    fontWeight: FontWeight.w200,
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
                                                fontWeight: FontWeight.w400,
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

        )*/
      ),
    );
  }
}



