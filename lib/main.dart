import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran/pages/ayalistbysura.dart';
import 'package:quran/pages/hadislist.dart';
import 'package:quran/pages/suralist.dart';

void main() {

  runApp(MaterialApp(title: 'Bangla Quran', home: BanglaQuran(), debugShowCheckedModeBanner: false,));
}

class BanglaQuran extends StatefulWidget {

  BanglaQuranState createState() => BanglaQuranState();
}

class BanglaQuranState extends State<BanglaQuran> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.teal,
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            // action button
            IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.chrome_reader_mode,
                size: 15,
              ),
              onPressed: () {
                print("Icon presed");
              },
            ),
          ],
          title: Text(
            "বাংলা কুরআন",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/bgImg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  borderOnForeground: true,
                  color: Colors.teal,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SuraList()),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Image.asset("assets/images/qlauncher.png", height: 100, width: 100,),
                      ],
                    ),
                  ),
                  elevation: 15,
                  margin: EdgeInsets.all(5),
                ),Card(
                  borderOnForeground: true,
                  color: Colors.teal,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HadisList()),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Image.asset("assets/images/hadith.png"),
                      ],
                    ),
                  ),
                  elevation: 15,
                  margin: EdgeInsets.all(5),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
