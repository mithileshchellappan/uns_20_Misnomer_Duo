import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';
import "package:fzregex/fzregex.dart";
import 'package:fzregex/utils/pattern.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool showAlertDialog = true, hasLink = false;
  String res = "";
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

  @override
  Widget build(BuildContext context) {
    return showAlertDialog
        ? alertDialog()
        : WillPopScope(
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
                    Flexible(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            itemCount: messsages.length,
                            itemBuilder: (context, index) {
                              return chat(
                                  messsages[index]["message"].toString(),
                                  messsages[index]["data"]);
                            })),
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0)),
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
    return Scaffold(
      body: Visibility(
          visible: showAlertDialog,
          child: Center(
            child: AlertDialog(
              content: Text("hi"),
              actions: [
                FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      setState(() {
                        showAlertDialog = false;
                      });
                    })
              ],
            ),
          )),
    );
  }

  Widget chat(String message, int data) {
    // print("message - $message");
    RegExp regExp = new RegExp(
      r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})",
      caseSensitive: false,
      multiLine: true,
    );
    

    // speak(res);
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
                      child: Text(
                        message,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(regExp.hasMatch(message)?"has link":"no link")
              ],
            ),
          )),
    );
  }
}
