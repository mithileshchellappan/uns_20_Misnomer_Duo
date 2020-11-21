import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';


import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class Role {
  String role;
  Role(this.role);
}

class POV {
  String pov;
  POV(this.pov);
}

class _ChatPageState extends State<ChatPage> {
  bool showAlertDialog = true, hasLink = false;
  String res = "";
  final userForm = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  dialogShow() {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                      // height: 200,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            'label',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: "Montserrat"),
                          )),
                        ],
                      ));
                },
              ),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    setState(() {
                      showAlertDialog = false;
                    });
                  },
                ),
              ],
            ));
  }

  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson: "assets/cupcakesbot-qlrcih-9c82160e9e70.json")
        .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
      res = aiResponse.getListMessage()[0]["text"]["text"][0].toString();
    });
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();
  String startPageText =
      'Hi, I\'m here to assist you \n with your queries on our college. \n Ask me questions or \n tap on one of these:';
  String prompt1 = 'Where is the college located?';
  String prompt2 = 'What are the UG courses offered?';
  String prompt3 = 'Who is the principal of the college?';

  List<Role> roles = [
    Role("Parent"),
    Role('Student'),
    Role("Faculty"),
    Role("Other")
  ];
  Role selectedRole;

  List<POV> pov = [
    POV("Know about FRCRCE"),
    POV("Know about our Courses"),
    POV("Know about Placements")
  ];
  POV selectedPOV;
  @override
  Widget build(BuildContext context) {
    return showAlertDialog
        ? alertDialog()
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Color(0xFFfafafa),
              appBar: AppBar(
                title: Text(
                  "Fr.Conceicao Rodrigues College Bot",
                ),
                backgroundColor: Color.fromARGB(255, 253, 188, 51),
                automaticallyImplyLeading: false,
              ),
              body: Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                        child: messsages.isEmpty
                            ? Container(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage('assets/bot.png'),
                                    width: 130.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    startPageText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  GestureDetector(
                                    child: Text(prompt1,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue)),
                                    onTap: () {
                                      setState(() {
                                        messageInsert.text = prompt1;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  GestureDetector(
                                    child: Text(prompt2,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue)),
                                    onTap: () {
                                      setState(() {
                                        prompt1 =
                                            'Where is the college located?';
                                        print("setstate - $prompt1");
                                        messageInsert.text = prompt2;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  GestureDetector(
                                    child: Text(prompt3,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue)),
                                    onTap: () {
                                      print('tap');
                                      setState(() {
                                        messageInsert.text = prompt3;
                                      });
                                    },
                                  )
                                ],
                              ))
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                reverse: true,
                                itemCount: messsages.length,
                                itemBuilder: (context, index) {
                                  
                                  return chat(
                                      messsages[index]["message"].toString(),
                                      messsages[index]["data"]);
                                })),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: messageInsert,
                            decoration: InputDecoration(
                                fillColor: Colors.black,
                                focusColor: Colors.black,
                                hoverColor: Colors.black,
                                border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                hintText: 'Type your message',
                                hintStyle: TextStyle(fontSize: 16.0)),
                          )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: 30.0,
                                  color: Color.fromARGB(255, 253, 188, 51),
                                ),
                                onPressed: () {
                                  if (messageInsert.text.isEmpty) {
                                    print("empty message");
                                  } else {
                                    setState(() {
                                      messsages.insert(0, {
                                        "data": 1,
                                        "message": messageInsert.text
                                      });
                                    });
                                    response(messageInsert.text);
                                    messageInsert.clear();
                                  }
                                }),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    )
                  ],
                ),
              ),
            ),
          );
  }

  alertDialog() {
    return Visibility(
        visible: showAlertDialog,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.all(8),
            child: FloatingActionButton.extended(
                onPressed: () {
                  final form = userForm.currentState;
                  if (form.validate()) {
                    form.save();
                    if (!(selectedPOV == null || selectedRole == null)) {
                      setState(() {
                        showAlertDialog = false;
                      });
                    }
                  }
                },
                label: Icon(Icons.arrow_right)),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome"),
              Form(
                key: userForm,
                child: Column(
                  children: [
                    textField("Name"),
                    textField("Phone"),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButton<Role>(
                          isExpanded: true,
                          hint: Text("Choose Role"),
                          value: selectedRole,
                          onChanged: (Role val) {
                            setState(() {
                              selectedRole = val;
                            });
                          },
                          items: roles.map((Role role) {
                            return DropdownMenuItem<Role>(
                                value: role,
                                child: Row(
                                  children: [Text(role.role)],
                                ));
                          }).toList()),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: DropdownButton<POV>(
                          isExpanded: true,
                          hint: Text("Choose Purpose of Visit"),
                          value: selectedPOV,
                          onChanged: (POV val) {
                            setState(() {
                              selectedPOV = val;
                            });
                          },
                          items: pov.map((POV pov) {
                            return DropdownMenuItem<POV>(
                                value: pov,
                                child: Row(
                                  children: [Text(pov.pov)],
                                ));
                          }).toList()),
                    )
                  ],
                ),
              )
            ],
          )),
        ));
  }

  textField(String label) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black, fontSize: 20),
        validator: (input) {
          if (input == "") {
            return "Cannot be empty";
          }
          return null;
        },
        keyboardType:
            label == "Phone" ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: label,
            errorStyle: TextStyle(color: Colors.red, fontSize: 15),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hoverColor: Colors.black,
            floatingLabelBehavior: FloatingLabelBehavior.never),
        // onSaved: (value) => _email = value,
        onChanged: (value) {},
      ),
    );
  }

  
  Widget chat(String message, int data) {
    print("message - $message");
    RegExp regExp = new RegExp(
      r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})",
      caseSensitive: false,
      multiLine: true,
    );
    String remMes = message;
    if (regExp.hasMatch(message)) {
      String link2 = regExp.firstMatch(message).group(0);
      remMes = message.replaceFirst(link2, '');
      print('remmes $remMes');
      print('link2' + link2);
    }

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Color(0xFFe8eaf6) : Color(0xFFe8f3fc),
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          data == 0 ? "assets/bot.png" : "assets/user.png"),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: ParsedText(
                        text: remMes,
                        parse: [
                          MatchText(
                              type: ParsedType.URL,
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              onTap: (url) async {
                                print('url ${url.toString()}');
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  await launch("mailto:" + url);
                                }

                                print('launch');
                              }),
                          MatchText(
                              type: ParsedType.PHONE,
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              onTap: (url) async {
                                print('mob' + url.toString());

                                await launch("tel:" + url);

                                print(url);
                              }),
                          MatchText(
                              type: ParsedType.EMAIL,
                              onTap: (url) async {
                                await launch("mailto:" + url);
                              })
                        ],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    child: regExp.hasMatch(message)
                        ? Column(
                            children: [
                              Divider(),
                              GestureDetector(
                                onTap: () async {
                                  await launch(
                                      regExp.firstMatch(message).group(0));
                                },
                                child: FlutterLinkPreview(
                                  url: regExp.firstMatch(message).group(0),
                                  titleStyle: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 0,
                          ))
              ],
            ),
          )),
    );
  }
}
