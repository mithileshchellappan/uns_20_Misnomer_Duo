import "package:flutter/material.dart";
import 'package:unscript_hackathon/adminpanel.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final formKey = GlobalKey<FormState>();
  String email = "", password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login as Admin")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: formKey,
                child: Column(
                  children: [
                    textformfield("Email"),
                    textformfield("Password"),
                    OutlineButton(
                        onPressed: () {
                          final form = formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminPanel()));
                          }
                        },
                        child: Text("Sign in"))
                  ],
                ))
          ],
        ));
  }

  textformfield(String label) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black, fontSize: 20),
        validator: (input) {
          if (label == "Email") {
            if (input != "admin@ad.com") {
              return "Invalid e-mail";
            }
          }
          if (label == "Password") {
            if (input != "admin") {
              return "Invalid Password";
            }
          }
          return null;
        },
        keyboardType:
            label == "Email" ? TextInputType.emailAddress : TextInputType.text,
        obscureText: label == "Password" ? true : false,
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
        onChanged: (value) {
          if (label == "Email") {
            setState(() {
              email = value;
            });
          } else {
            setState(() {
              password = value;
            });
          }
        },
      ),
    );
  }
}
