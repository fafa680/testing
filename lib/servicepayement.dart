import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakwetu/page3.dart';
import 'package:kakwetu/tabviews/encouragement.dart';

class Service extends StatefulWidget {
  final Langue l;
  final String numero;
  Service({Key key, this.l, this.numero}) : super(key: key);

  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Kakwetu",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.yellow),
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: Builder(builder: (context) {
          return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    child,
                    connected
                        ? Myform(
                            l: widget.l,
                            numero: widget.numero,
                          )
                        : Center(
                            child: widget.l.eng == 1
                                ? Text(
                                    "You are Offline",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 40),
                                    textAlign: TextAlign.center,
                                  )
                                : widget.l.fra == 1
                                    ? Text(
                                        "Connectez-Vous",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 40),
                                        textAlign: TextAlign.center,
                                      )
                                    : widget.l.swa == 1
                                        ? Text(
                                            "Fungua Internet",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 40),
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            "Ugurura Enterineti",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 40),
                                            textAlign: TextAlign.center,
                                          ),
                          )
                  ],
                );
              },
              child: Text(""));
        }));
  }
}

class Myform extends StatefulWidget {
  final Langue l;
  final String numero;
  Myform({Key key, this.l, this.numero}) : super(key: key);

  @override
  _MyformState createState() => _MyformState();
}

class _MyformState extends State<Myform> {
  TextEditingController droppays = new TextEditingController();
  List<String> pays = [];
  StreamController<List> _streamcontroller = StreamController<List>();
  @override
  void initState() {
    selectpays();
    super.initState();
  }

  @override
  void dispose() {
    _streamcontroller.close();
    pays.clear();
    super.dispose();
  }

  static _isolate(String body) {
    return jsonDecode(body);
  }

  selectpays() async {
    try {
      final response = await http
          .get("https://kakwetuburundifafanini.com/pays/selectpays.php");
      var resultat = await compute(_isolate, response.body);
      setState(() {
        for (int i = 0; i < resultat.length; i++) {
          setState(() {
            pays.add(resultat[i]['nom']);
          });
        }
        _streamcontroller.add(pays);
      });
    } catch (e) {
      setState(() {
        pays = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<List>(
            stream: _streamcontroller.stream,
            builder: (context, snap) {
              if (snap.hasError) {
                return null;
              } else if (snap.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Card(
                    color: Colors.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.red, width: 3),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonFormField(
                      autofocus: false,
                      autovalidate: false,
                      isDense: true,
                      isExpanded: true,
                      dropdownColor: Colors.black,
                      items: snap.data.map((e) {
                        return DropdownMenuItem(
                          child: Center(
                            child: new Text(
                              e,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (v) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Encouragement(
                                      l: widget.l,
                                      numero: widget.numero,
                                      pays: v,
                                    )));
                      },
                      hint: Center(
                        child: Text(
                          widget.l.fra == 1
                              ? "Dans quel Pays ?"
                              : widget.l.eng == 1
                                  ? "In Which Country ?"
                                  : widget.l.swa == 1
                                      ? "Nchi gani ?"
                                      : "Ikihe gihugu ?",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        Padding(
            padding: const EdgeInsets.all(2),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black26, width: 5),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  widget.l.fra == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Choisissez Le Pays Dans lequel vous Etes Maintenant",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : widget.l.eng == 1
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Choose A country Where you are now",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : widget.l.swa == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Chagua Nchi Ambayo ukoemwo Sasa hivi",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Hitamwo Igihugu Urimwo ubunyene",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.warning,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
