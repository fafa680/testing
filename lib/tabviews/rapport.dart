import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;

class Rapport extends StatefulWidget {
  final Langue l;
  final int isboss;
  final int controled;
  final String numero;
  final String password;
  final int duree;
  Rapport(
      {Key key,
      this.l,
      this.isboss,
      this.controled,
      this.numero,
      this.password,
      this.duree})
      : super(key: key);

  @override
  _RapportState createState() => _RapportState();
}

class _RapportState extends State<Rapport> {
  Timer _timer;
  bool tous = false;
  ScrollController _scrollcontroller = new ScrollController();
  StreamController<List> _streamcontroller = StreamController<List>();
  @override
  void initState() {
    selectrapport();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      selectrapport();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    _streamcontroller.close();
    rapport.clear();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  var rapport = [];
  selectrapport() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/gra/selectrapport.php",
          body: {
            "nro": widget.numero,
          });
      var resultat = await compute(_isolate, response.body);
      setState(() {
        _streamcontroller.add(resultat);
        rapport = resultat;
      });
    } catch (e) {
      setState(() {
        rapport = [];
      });
    }
  }

  static _isolate(String body) {
    return jsonDecode(body);
  }

  bool _isontop = true;
  _scrolltop() {
    _scrollcontroller.animateTo(_scrollcontroller.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() {
      _isontop = true;
    });
  }

  _scrolldown() {
    _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,
        duration: Duration(seconds: rapport.isEmpty ? 1 : (rapport.length * 4)),
        curve: Curves.easeOut);
    setState(() {
      _isontop = false;
    });
  }

  bool ispop = true;
  void messagevalidation1() {
    AlertDialog alerte = new AlertDialog(
      content: widget.l.fra == 1
          ? Text("Vous Voulez Fermer Tout ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Do you want to Close All ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Unataka Kufunga vyote ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka Kwugara Vyose ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: widget.l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.center),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alerte;
        });
    //return;
  }

  Future<bool> _willpop() async {
    return Future.value(ispop);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (ispop) {
          messagevalidation1();
        } else {
          return _willpop();
        }
        return null;
      },
      child: Column(
        children: [
          StreamBuilder<List>(
              stream: _streamcontroller.stream,
              builder: (context, snap) {
                if (snap.hasError) {
                } else if (snap.hasData) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                              child: Scrollbar(
                                  child: ListView.builder(
                                      controller: _scrollcontroller,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: snap.data.length,
                                      itemBuilder: (context, i) {
                                        return InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            if (tous) {
                                              setState(() {
                                                tous = false;
                                              });
                                            } else {
                                              setState(() {
                                                tous = true;
                                              });
                                            }
                                          },
                                          child: Card(
                                            color: Colors.black45,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.lightBlue,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Column(
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: widget.l.fra == 1
                                                        ? snap.data[i]['jour']
                                                                    .toString() ==
                                                                '1'
                                                            ? Text(
                                                                "Dimanche le " +
                                                                    snap.data[i]
                                                                        ['dat'],
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .white))
                                                            : snap.data[i]['jour'].toString() ==
                                                                    '2'
                                                                ? Text("Lundi le " + snap.data[i]['dat'],
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white))
                                                                : snap.data[i]['jour'].toString() == '3'
                                                                    ? Text("Mardi le " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                    : snap.data[i]['jour'].toString() == '4'
                                                                        ? Text("Mercredi le " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                        : snap.data[i]['jour'].toString() == '5'
                                                                            ? Text("Jeudi le " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : snap.data[i]['jour'].toString() == '6'
                                                                                ? Text("Vendredi le " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                : Text("Samedi le " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                        : widget.l.eng == 1
                                                            ? snap.data[i]['jour'].toString() == '1'
                                                                ? Text("Sunday The " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                : snap.data[i]['jour'].toString() == '2'
                                                                    ? Text("Monday The " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                    : snap.data[i]['jour'].toString() == '3'
                                                                        ? Text("Tuesday The " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                        : snap.data[i]['jour'].toString() == '4'
                                                                            ? Text("Wednesday The " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : snap.data[i]['jour'].toString() == '5'
                                                                                ? Text("Thursday The " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                : snap.data[i]['jour'].toString() == '6'
                                                                                    ? Text("Friday The " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                    : Text("Saturday " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                            : widget.l.swa == 1
                                                                ? snap.data[i]['jour'].toString() == '1'
                                                                    ? Text("Jumapili Tarehe " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                    : snap.data[i]['jour'].toString() == '2'
                                                                        ? Text("Jumatatu Tarehe " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                        : snap.data[i]['jour'].toString() == '3'
                                                                            ? Text("Jumanne Tarehe " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : snap.data[i]['jour'].toString() == '4'
                                                                                ? Text("Jumatano Tarehe " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                : snap.data[i]['jour'].toString() == '5'
                                                                                    ? Text("Alhamisi Tarehe " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                    : snap.data[i]['jour'].toString() == '6'
                                                                                        ? Text("Ijumaa Tarehe " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                        : Text("Jumamosi Tarehe " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                : snap.data[i]['jour'].toString() == '1'
                                                                    ? Text("Kuw'Imana Igenekerezo rya " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                    : snap.data[i]['jour'].toString() == '2'
                                                                        ? Text("Kuwambere Igenekerezo rya " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                        : snap.data[i]['jour'].toString() == '3'
                                                                            ? Text("Kuwakabiri Igenekerezo rya " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : snap.data[i]['jour'].toString() == '4'
                                                                                ? Text("Kuwagatatu Igenekerezo rya " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                : snap.data[i]['jour'].toString() == '5'
                                                                                    ? Text("Kuwakane Igenekerezo rya " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                    : snap.data[i]['jour'].toString() == '6'
                                                                                        ? Text("Kuwagatanu Igenekerezo rya " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                        : Text("Kuwagatandatu Igenekerezo rya " + snap.data[i]['dat'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    snap.data[i]['nom'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 40),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    tous == false
                                                        ? snap.data[i]['qte'] +
                                                            "/" +
                                                            (double.parse(
                                                                    snap.data[i]
                                                                        ['px']))
                                                                .toStringAsFixed(
                                                                    0)
                                                        : snap.data[i]['qte'] +
                                                            " / " +
                                                            snap.data[i]['px'],
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: widget.l.fra == 1
                                                      ? Text(
                                                          tous == false
                                                              ? "Total: " +
                                                                  (double.parse(
                                                                          snap.data[i]
                                                                              [
                                                                              'total']))
                                                                      .toStringAsFixed(
                                                                          0)
                                                              : "Total: " +
                                                                  snap.data[i]
                                                                      ['total'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      : widget.l.eng == 1
                                                          ? Text(
                                                              tous == false
                                                                  ? "Total: " +
                                                                      (double.parse(snap.data[i]
                                                                              [
                                                                              'total']))
                                                                          .toStringAsFixed(
                                                                              0)
                                                                  : "Total: " +
                                                                      snap.data[
                                                                              i]
                                                                          [
                                                                          'total'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : widget.l.swa == 1
                                                              ? Text(
                                                                  tous == false
                                                                      ? "Kiasi: " +
                                                                          (double.parse(snap.data[i]['total'])).toStringAsFixed(
                                                                              0)
                                                                      : "Kiasi: " +
                                                                          snap.data[i]
                                                                              [
                                                                              'total'],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          30,
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              : Text(
                                                                  tous == false
                                                                      ? "Yose: " +
                                                                          (double.parse(snap.data[i]['total'])).toStringAsFixed(
                                                                              0)
                                                                      : "Yose: " +
                                                                          snap.data[i]
                                                                              [
                                                                              'total'],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          30,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }))),
                          FloatingActionButton(
                            onPressed: _isontop ? _scrolldown : _scrolltop,
                            child: Icon(_isontop
                                ? Icons.arrow_downward
                                : Icons.arrow_upward),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black)),
                    ),
                  );
                }
                return null;
              }),
        ],
      ),
    );
  }
}
