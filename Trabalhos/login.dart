// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(const LoginApp());

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.indigo,
        appBarTheme: const AppBarTheme(
          color: Colors.indigo,
          centerTitle: true,
          foregroundColor: Colors.white,
          //shadowColor: Colors.deepPurple,
        ),
      ),
      home: const MyHomePage(
        title: '',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://art.pixilart.com/84e41d824c52e3e.gif')),
                borderRadius: BorderRadius.all(Radius.circular(40))),
            height: 500,
            //width: 380,
            margin: const EdgeInsets.all(12),
            //color: Colors.red,
            foregroundDecoration: BoxDecoration(
                border: Border.all(color: Colors.black87),
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 75,
                  width: 280,
                  padding: const EdgeInsets.only(bottom: 45),
                  child: const DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent ,
                          boxShadow: [BoxShadow(color: Colors.black54)],
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        'Efetuar Login',textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ),
                const TextField(
                  decoration: InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)))),
                  style: TextStyle(color: Colors.white),
                ),
                const Padding(padding: EdgeInsets.all(5)),
                const TextField(
                  decoration: InputDecoration(
                      labelText: "Senha",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)))),
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  autofocus: false,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  height: 40,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.deepPurpleAccent,
                    onPressed: () {
                      setState(() {
                      });
                    },
                    tooltip: 'Fazer login',
                    enableFeedback: true,
                    splashColor: Colors.deepPurple,
                    label: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Fazer login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
