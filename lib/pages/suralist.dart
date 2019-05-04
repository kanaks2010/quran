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
            title: Text(
              "সূরাসমূহ",
              textAlign: TextAlign.right,
            ),
            centerTitle: true,
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
  var suraBgc3 ;

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

  int _selectedIndex = null;

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
      suraBgc3 = const Color(0xFF009484);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, i) {
              return GestureDetector(
                  onTapDown: (val) {
                    _onSelected(i);
                  },
                  onTapUp: (val){
                    setState(() {
                      _selectedIndex = null;
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AyaListBySura(QranListData[i])),
                    );
                  },
                  child: Card(
                    child: Container(
                        color: _selectedIndex != null && _selectedIndex == i
                            ? suraBgc3
                            : Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text("${QranListData[i]["number"]}",
                                          style: TextStyle(
                                            fontSize: 17,color: _selectedIndex != null && _selectedIndex == i
                                              ? Colors.white
                                              : Colors.black,
                                          )),
                                      Text(
                                        "সূরা " +
                                            QranListData[i]["bangla_name"] +
                                            ""
                                            "(${QranListData[i]['total_verses_b']})",
                                        style: TextStyle(
                                          fontSize: 17,color: _selectedIndex != null && _selectedIndex == i
                                            ? Colors.white
                                            : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 0),
                                      child: Text(QranListData[i]["name"],
                                          style: TextStyle(
                                              fontSize: 17,color: _selectedIndex != null && _selectedIndex == i
                                              ? Colors.white
                                              : Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 0),
                                      child: Image.asset(
                                        _setImage(
                                            QranListData[i]["revelation_type"]),
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              height: 2.0,
                              color: Colors.teal,
                            )
                          ],
                        )),
                  ));
            },
            itemCount: QranListData.length,
          ),
        ),
      ),
    );
  }
}

/*

Widget bacS() {
  return ListView.builder(
      itemCount: _listViewData.length,
      itemBuilder: (context, index)
  =>
      Container(
        color: _selectedIndex != null && _selectedIndex == index
            ? Colors.red
            : Colors.white,
        child: ListTile(
          title: Text(_listViewData[index]),
          onTap: () => _onSelected(index),
        ),
      )
  ,
}*/
