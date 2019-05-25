import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran/pages/hadislist.dart';
import 'package:quran/pages/suralist.dart';
import 'package:device_info/device_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review/launch_review.dart';
import 'package:connectivity/connectivity.dart';


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
  var formKey = GlobalKey<FormState>();
  var usrName = TextEditingController();
  var usrEmail = TextEditingController();
  var usrComments = TextEditingController();
  var name, email, comments;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();


  @override
  void initState() {
    super.initState();
  }


  DateTime createTime = DateTime.now();

  deviceInformation() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    var data = {
      "model": '${androidInfo.model}',
      "androidId": '${androidInfo.androidId}',
      "manufacturer": '${androidInfo.manufacturer}',
      "id": '${androidInfo.id}',
      "board": '${androidInfo.board}',
      "bootloader": '${androidInfo.bootloader}',
      "brand": '${androidInfo.brand}',
      "version_release": '${androidInfo.version.release}',
      "version_baseOS": '${androidInfo.version.baseOS}',
      "version_codename": '${androidInfo.version.codename}',
      "device": '${androidInfo.device}',
      "display": '${androidInfo.display}',
      "fingerprint": '${androidInfo.fingerprint}',
      "host": '${androidInfo.host}',
      "hashCode": '${androidInfo.hashCode}',
      'created_at': '${createTime}'
    };
    var db = FirebaseDatabase.instance.reference().child(
        "user_device_information")
        .child('${androidInfo.androidId}')
        .reference();
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) {
        reference.child('user_device_information').child(
            '${androidInfo.androidId}').set(data);
      }
    });
  }

  void hanfleSubmit() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (name != null && email != null) {
        DatabaseReference reference = FirebaseDatabase.instance.reference();
        var data = {
          "name": name,
          "email": email,
          "comments": comments,
          'created_at': '${createTime}'
        };

        var db = FirebaseDatabase.instance.reference().child("feedback").child(
            '${androidInfo.androidId}').reference();
        db.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          if (values == null) {
            reference.child('feedback').child('${androidInfo.androidId}').set(
                data).then((onValue) {
              hanfleReset();
              showToast("Thank you for your valueable feedback");
            });
          } else {
            hanfleReset();
            showToast('Thank you. You have already done');
          }
        });
      }
    }
  }

  void hanfleReset() {
    Navigator.of(context).pop();
    usrName.clear();
    usrEmail.clear();
    usrComments.clear();
  }

  showToast(txt) {
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String validateEmail(String value) {
    if (value.length == 0) {
      return ("Email is required");
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }
  }

  review() {
    LaunchReview.launch();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {});
  }

  showRateDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Rate 5 Start for Holy Quran"),
            content: Text("Please rate now"),
            actions: <Widget>[
          RaisedButton(
          color: Colors.deepOrange,
            onPressed: () {
            SystemNavigator.pop();
            },
            child: Text('Later', style: TextStyle(color: Colors.white),),
          ),
          RaisedButton(
            color: Colors.teal,
            onPressed: () {
              this.review();
            },
            child: Text('Rate Now', style: TextStyle(color: Colors.white),),
          )
          ]
          ,
          );
        }
    );
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: usrName,
                          decoration: InputDecoration(labelText: "Your name"),
                          validator: (value) {
                            if (value.length == 0) return ("Name is required");
                          },
                          onSaved: (value) {
                            this.name = value;
                          },
                        ),
                        TextFormField(
                          controller: usrEmail,
                          decoration:
                          InputDecoration(labelText: "Your email address"),
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            this.email = value;
                          },
                        ),
                        TextField(
                          controller: usrComments,
                          decoration:
                          InputDecoration(labelText: "Your Comments"),
                          minLines: 1,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            this.comments = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              child: Text("Cancel"),
                              onPressed: () {
                                hanfleReset();
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              color: Colors.teal,
                              textColor: Colors.white,
                              child: Text("Submit"),
                              onPressed: () {
                                // hanfleSubmit();

                                // showToast();
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[],
          );
        });
  }

  _launchURL() async {
    const url = 'https://sites.google.com/view/banglaquran/home';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          this.showRateDialog();
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.mobile) {
            this.deviceInformation();
          } else if (connectivityResult == ConnectivityResult.wifi) {
            this.deviceInformation();
          }
        },
        child: Scaffold(
            backgroundColor: Colors.cyan,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: AppBar(
                title: Text("বাংলা কুরআন"),
                centerTitle: true,
                backgroundColor: Colors.teal,
                iconTheme: IconThemeData(color: Colors.tealAccent),
                actions: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                        cardColor: Colors.teal,
                        buttonColor: Colors.white
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: PopupMenuButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        offset: Offset(0, 40),
                        elevation: 10,
                        onSelected: (value) {
                          if (value == 'Feedback') {
                            _showDialog();
                          } else if (value == 'privacy') {
                            _launchURL();
                          } else if (value == 'Rate_App') {
                            review();
                          }
                          print(value);
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: "privacy",
                              child: Text("Privacy policy",
                                style: TextStyle(color: Colors.white),),
                            ),
                            PopupMenuItem(
                              value: "Feedback",
                              child: Text("Feedback",
                                style: TextStyle(color: Colors.white),),
                            ),
                            PopupMenuItem(
                              value: "Rate_App",
                              child: Text("Rate App",
                                style: TextStyle(color: Colors.white),),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                  /*IconButton(
                color: Colors.white,
                icon: Icon(
                  Icons.feedback,
                  size: 15,
                ),
                onPressed: () {
                  _showDialog();
                },
              ),*/
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
                              MaterialPageRoute(
                                  builder: (context) => SuraList()),
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
                              MaterialPageRoute(
                                  builder: (context) => HadisList()),
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
            ))
    );
  }
}
