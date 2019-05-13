import 'dart:convert';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

class HadisList extends StatefulWidget {
  var suraInfo;

  HadisList();

  HadisListState createState() => HadisListState();
}

class HadisListState extends State<HadisList> {
  var suranInfo;

  HadisListState();

  TabController controller;
  List AllSuraListArabic = [];
  List AllSuraListbengali = [];
  var ayaCount = 0;
  var ayaNumberBn;
  var shareText;
  var onlyArabic = true;
  var onlyBangla = true;
  var arBng = true;
  var onlyBng = false;
  var onlyAr = false;
  final snackBarkey = new GlobalKey<ScaffoldState>();

  loadAllSuraListData() async {
    var jsonString = await rootBundle.loadString("assets/40hadis/40.json");
    setState(() {
      this.AllSuraListArabic = json.decode(jsonString);
      this.ayaCount = 42;
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

  getHadisErMan(i) {
    if (i != null && i == 30) {
      return "হাদিসের মানঃ নির্নিত নয়";
    } else {
      return "হাদিসের মানঃ সহিহ হাদিস";
    }
  }

  showToast() {
    Fluttertoast.showToast(
        msg: "হাদিস টি কপি সম্পন্ন হয়েছে",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _showDialog(
      context, String ayaNum, String arabicTxt, String bnTxt) {
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
                                text: "${bnTxt}"));
                            Navigator.of(context).pop();
                            showToast();
                          },
                        ),
                        Text("বাংলা কপি"),
                      ],
                    ),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(
                          text:"${bnTxt}"));
                      Navigator.of(context).pop();
                      showToast( );
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
                                text: " ${arabicTxt} \n ${bnTxt}"));
                            Navigator.of(context).pop();
                            showToast( );
                          },
                        ),
                        Text("আরবি + বাংলা কপি"),
                      ],
                    ),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(
                          text: "${arabicTxt} \n ${bnTxt}"));
                      Navigator.of(context).pop();
                      showToast( );
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[],
          );
        });
  }

  Widget arrowThumbs(ayaCount) {
    ScrollController _arrowsController = ScrollController();
    return DraggableScrollbar.arrows(
      // labelTextBuilder: (double offset) => Text("${i}"),
      controller: _arrowsController,
      scrollbarAnimationDuration: Duration(seconds: 1),
      scrollbarTimeToFade: Duration(seconds: 2),
      backgroundColor: Colors.teal,
      child: ListView.builder(
        controller: _arrowsController,
        itemCount: ayaCount,
        itemBuilder: (context, i) {
          return Container(
            child: Material(
              elevation: 0.0,
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: GestureDetector(
                    onLongPress: () {
                      _showDialog(
                          context,
                          "${i + 1}",
                          AllSuraListArabic[0]["verse"]["verse_${i + 1}"],
                          AllSuraListArabic[0]["verse_bn"]["verse_${i + 1}"]);
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: i == 0
                              ? EdgeInsets.only(bottom: 25)
                              : EdgeInsets.only(bottom: 0),
                          child: Text(
                            getBismillah(
                                i, AllSuraListArabic[0]["verse"]["verse_${i}"]),
                            style: TextStyle(color: Colors.teal, fontSize: 25),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          shareText = AllSuraListArabic[0]
                                                  ["verse"]["verse_${i + 1}"] +
                                              ",\n" +
                                              AllSuraListArabic[0]["verse_bn"]
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
                                            color: Color(0xFF000000),
                                            fontWeight: FontWeight.w400,
                                            wordSpacing: 0.5,
                                            fontFamily: 'Lateef',
                                            fontSize: 40,
                                            letterSpacing: 0),
                                        textAlign: TextAlign.right,
                                      ))),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                getHadisErMan(i),
                                style: TextStyle(
                                  color: i == 30 ? Colors.deepOrange : Colors.green, fontSize: 16, fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
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
    ScrollController _arrowsController =
        ScrollController(initialScrollOffset: 50.0);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.tealAccent),
            title: Text(
              "৪০ হাদিস",
              style: TextStyle(fontSize: 16),
            ),
            centerTitle: true,
            actions: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.teal,
                ),
                child: InkWell(
                  onTap: () {},
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    offset: Offset(0, 35),
                    elevation: 10,
                    onSelected: (value) {
                      if (value == 'arBng') {
                        setState(() {
                          this.onlyBangla = true;
                          this.onlyArabic = true;
                          this.arBng = true;
                          this.onlyBng = false;
                          this.onlyAr = false;
                        });
                      } else if (value == 'onlyBng') {
                        setState(() {
                          this.onlyBangla = true;
                          this.onlyArabic = false;
                          this.arBng = false;
                          this.onlyBng = true;
                          this.onlyAr = false;
                        });
                      } else if (value == 'onlyAr') {
                        setState(() {
                          this.onlyBangla = false;
                          this.onlyArabic = true;
                          this.arBng = false;
                          this.onlyBng = false;
                          this.onlyAr = true;
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        CheckedPopupMenuItem(
                          child: Text("আরবি + বাংলা",
                              style: TextStyle(color: Colors.white)),
                          checked: this.arBng,
                          value: "arBng",
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
                      ];
                    },
                  ),
                ),
              ),
            ],
            titleSpacing: 0,
          )),
      body: Container(child: arrowThumbs(this.ayaCount)),
    );
  }
}
