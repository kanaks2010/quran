import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran/pages/hadislist.dart';
import 'package:quran/pages/suralist.dart';

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

  @override
  void initState() {
    super.initState();
  }

  void hanfleSubmit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (name != null && email != null) {
        DatabaseReference reference = FirebaseDatabase.instance.reference();
        var data = {"name": name, "email": email, "comments": comments};
        reference.child('feedback').push().set(data).then((onValue) {
          print('${data} ' + ' data saved');
          hanfleReset();
          showToast();
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

  showToast() {
    Fluttertoast.showToast(
        msg: "Thank you for your valueable feedback",
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
                                hanfleSubmit();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            title: Text("বাংলা কুরআন"),
            centerTitle: true,
            backgroundColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.black),
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(
                  Icons.feedback,
                  size: 15,
                ),
                onPressed: () {
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
