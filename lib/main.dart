import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran/pages/ayalistbysura.dart';
import 'package:quran/pages/hadislist.dart';
import 'package:quran/pages/suralist.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(
    title: 'Bangla Quran',
    home: BanglaQuran(),
    debugShowCheckedModeBanner: false,
  ));
}

class BanglaQuran extends StatefulWidget {
  BanglaQuranState createState() => BanglaQuranState();
}

class BanglaQuranState extends State<BanglaQuran> {
  @override
  void initState() {
    super.initState();
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

  _showDialog() {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Feedback"),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Enter your name'),
                  ),TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Enter your email'),
                  ),TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Enter your commet'),
                  ),
                  SizedBox(height: 5,),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.teal,
                    textColor: Colors.white,
                    child: Text("Submit"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showToast();
                    },
                  )
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
                  _showDialog();
                },
              ),
            ],
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SuraList()),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/qlauncher.png",
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    elevation: 15,
                    margin: EdgeInsets.all(5),
                  ),
                  Card(
                    borderOnForeground: true,
                    color: Colors.teal,
                    child: InkWell(
                      onTap: () {
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
        ));
  }
}
