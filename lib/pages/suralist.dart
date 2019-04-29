import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:color/color.dart';
import 'package:quran/pages/ayalistbysura.dart';

class SuraList extends StatefulWidget {
  SuraListState createState() => SuraListState();
}

class SuraListState extends State<SuraList> {
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
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            backgroundColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.black),
            title: TabBar(
                indicator: UnderlineTabIndicator(
                  insets: EdgeInsets.symmetric(horizontal: 5),
                ),
                onTap: (val) {},
                controller: controller,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.home),
                  )
                ]),
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

  List QranListData = [];
  List AllSuraList = [];
  loadQranListData() async {
    var jsonString = await rootBundle.loadString("assets/sura_list.json");
    setState(() {
      this.QranListData = json.decode(jsonString);
    });
  }
  loadAllSuraListData() async {
    var jsonString = await rootBundle.loadString("assets/quran_bengali.json");
    setState(() {
      this.AllSuraList = json.decode(jsonString);
    });
    print(this.AllSuraList.length);
  }

  @override
  void initState() {
    super.initState();
    loadQranListData();
    loadAllSuraListData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
            itemCount: QranListData.length,
            itemBuilder: (BuildContext context, int i) => Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: GestureDetector(
                    onTap: (){
                      print("Card Tapped");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AyaListBySura()),
                      );
                    },
                    child: Card(
                      color :  Colors.green,
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.home, size: 18, color:  Colors.white,),
                                SizedBox(width: 5,),
                                Text("${QranListData[i]["number"]}"),
                                SizedBox(width: 5,),
                                Text(QranListData[i]["bangla_name"]+" ( ${QranListData[i]['total_verses_b']} )", style: TextStyle(fontSize: 15,),),
                              ],
                            ),
                            Container(),
                            Text(QranListData[i]["name"], style: TextStyle(fontSize: 15,)),
                          ],
                        ),
                      ),
                    ),
                  )

                )),
      ),
    );
  }
}
