import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool showAlertDialog = true;
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
                      height: 200,
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
    });
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Fr.Conceicao Rodrigues College Bot",
          ),
          backgroundColor: Colors.deepOrange,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              // Visibility(
              //   child: dialogShow(),
              //   visible: showAlertDialog,
              // ),
              Flexible(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: messsages.length,
                      itemBuilder: (context, index) => chat(
                          messsages[index]["message"].toString(),
                          messsages[index]["data"]))),
              Divider(
                height: 5.0,
                color: Colors.deepOrange,
              ),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: TextField(
                      controller: messageInsert,
                      decoration: InputDecoration.collapsed(
                          hintText: "Send your message",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 30.0,
                            color: Colors.deepOrange,
                          ),
                          onPressed: () {
                            if (messageInsert.text.isEmpty) {
                              print("empty message");
                            } else {
                              setState(() {
                                messsages.insert(0,
                                    {"data": 1, "message": messageInsert.text});
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

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget chat(String message, int data) {
    bool hasALink = false;
    _launchURL() async {
      const url = 'https://flutter.dev';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    // String link;
    // RegExp exp =
    //     new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    // Iterable<RegExpMatch> matches = exp.allMatches(message);
    // matches.forEach((match) {
    //   Future.delayed(Duration.zero, () {
    //     // setState(() {
    //     //   hasALink = true;
    //     //   print(hasALink);
    //     // });
    //   });
    //   print(message.substring(match.start, match.end));
    //   link = message.substring(match.start, match.end);
    // });
    // print("hasMatch : " + exp.hasMatch(message).toString());
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Colors.deepOrange : Colors.orangeAccent,
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
                        text: message,
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
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                hasALink
                    ? Container(child: Text('HasLink'))
                    : Container(
                        width: 0,
                      )
              ],
            ),
          )),
    );
  }
}
