import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../servicepayement.dart';

class Argent extends StatefulWidget {
  final Langue l;
  final int isboss;
  final int controled;
  final String numero;
  final String password;
  final int duree;
  Argent(
      {Key key,
      this.l,
      this.isboss,
      this.controled,
      this.numero,
      this.password,
      this.duree})
      : super(key: key);

  @override
  _ArgentState createState() => _ArgentState();
}

class _ArgentState extends State<Argent> {
  Timer _timer;
  bool delet = false;
  String etat = "1";
  StreamController<List> _streamcontroller1 = StreamController<List>();
  ScrollController _scrollcontroller = new ScrollController();
  bool ispop = true;
  @override
  void initState() {
    selectaptargent();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      selectaptargent();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    _streamcontroller1.close();
    argent.clear();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  static _isolate(String body) {
    return jsonDecode(body);
  }

  var argent = [];
  selectaptargent() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/ga/selectaptargent.php",
          body: {
            "nro": widget.numero,
          });
      var resultat = await compute(_isolate, response.body);
      setState(() {
        _streamcontroller1.add(resultat);
        argent = resultat;
      });
    } catch (e) {
      setState(() {
        argent = [];
      });
    }
  }

  deleteventeargant(String date) {
    setState(() {
      delet = false;
    });
    try {
      http.post("https://kakwetuburundifafanini.com/da/deleteventeargant.php",
          body: {
            "dat": date,
            "nro": widget.numero,
            "etat": etat,
          });
      setState(() {
        ispop = true;
      });
    } catch (e) {
      setState(() {
        ispop = true;
      });
    }
  }

  updateagtetatvue(String date) {
    setState(() {
      delet = false;
    });
    try {
      http.post("https://kakwetuburundifafanini.com/ua/updateagtetatvue.php",
          body: {
            "dat": date,
            "etat": etat,
            "nro": widget.numero,
          });
      setState(() {
        ispop = true;
      });
    } catch (e) {
      setState(() {
        ispop = true;
      });
    }
  }

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Votre paquet a expiré Vous Voulez payer encore ?",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Your Paquet has Finished Do you want to pay once again ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Mfuko wako Umeisha unataka kulipa tena ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center)
                  : Text(
                      "Umutekero wanyu Waheze Mushaka kuriha kandi ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
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
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Service(
                          l: widget.l,
                          numero: widget.numero,
                        )));
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
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

  snackabarfaux() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: widget.l.fra == 1
                ? Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 50, color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : widget.l.eng == 1
                    ? Text(
                        'Retry',
                        style: TextStyle(fontSize: 50, color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : widget.l.swa == 1
                        ? Text(
                            'binakatara',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'vyase',
                            style: TextStyle(fontSize: 20, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              Icons.warning,
              color: Colors.red,
              size: 50,
            ),
          )
        ],
      ),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {

      //   },
      // ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  bool tous = false;
  void messagevalidersuppression(String somme, String date, int i) {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text(
              "Vous Voulez Vraiment Supprimer Ce " +
                  somme +
                  " Qui a eté Vendu Le " +
                  date +
                  " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text(
                  "Do you Want to delete This " +
                      somme +
                      " wich has been sold the " +
                      date +
                      " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text(
                      "Unataka Kuondoa Kiasi ca " +
                          somme +
                          " Kilico Patikana tarehe " +
                          date +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka guhanagura Aya Mahera " +
                          somme +
                          " Yacurujwe Igenekerezo rya " +
                          date +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              delet = false;
            });
          },
          child: widget.l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          onPressed: () {
            if (widget.duree >= 0) {
              Navigator.pop(context);
              deleteventeargant(date);
            } else {
              Navigator.pop(context);
              if (widget.duree != -1002) {
                paspayemessage();
              } else {
                paspayemessageechec();
              }
            }
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
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

  void confimationvue(String somme, String date) {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text(
              "Vous Confimez que Vous avez cette Somme de " +
                  somme +
                  " Qui a eté Vendu Le " +
                  date +
                  " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text(
                  "Do you Agree That you have this Money " +
                      somme +
                      " wich has been sold the " +
                      date +
                      " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text(
                      "Unathibitisha kwamba Umesha Cukua Pesa hizi " +
                          somme +
                          " Zilizo Patikana tarehe " +
                          date +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Muremejeko Mwatoye Aya mahera " +
                          somme +
                          " Yacurujwe Igenekerezo rya " +
                          date +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              delet = false;
            });
          },
          child: widget.l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          onPressed: () {
            if (widget.duree >= 0) {
              Navigator.pop(context);
              updateagtetatvue(date);
            } else {
              Navigator.pop(context);
              if (widget.duree != -1002) {
                paspayemessage();
              } else {
                paspayemessageechec();
              }
            }
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
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

  paspayemessageechec() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Desolé Il y a un probleme,Réessayez plus tard",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Sorry We have a problem,Retry Later",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Samahani Kuko Tatizo,utajaribu Tena",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center)
                  : Text(
                      "Muradutunga Hari ikibazo,Muragerageza hanyuma",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
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
        duration: Duration(seconds: argent.isEmpty ? 1 : argent.length * 4),
        curve: Curves.easeOut);
    setState(() {
      _isontop = false;
    });
  }

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
              stream: _streamcontroller1.stream,
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
                                    onLongPress: () {
                                      if (widget.isboss == 1) {
                                        setState(() {
                                          delet = true;
                                        });
                                      } else {
                                        setState(() {
                                          delet = false;
                                        });
                                      }
                                    },
                                    onTap: () {
                                      setState(() {
                                        delet = false;
                                      });

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
                                      margin: EdgeInsets.all(2),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: widget.l.fra == 1
                                                  ? snap.data[i]['jour'].toString() ==
                                                          '1'
                                                      ? Text("Dimanche le " + snap.data[i]['dat'],
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              color:
                                                                  Colors.white))
                                                      : snap.data[i]['jour'].toString() ==
                                                              '2'
                                                          ? Text("Lundi le " + snap.data[i]['dat'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                          : snap.data[i]['jour'].toString() ==
                                                                  '3'
                                                              ? Text("Mardi le " + snap.data[i]['dat'],
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white))
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  tous == false
                                                      ? (double.parse(snap
                                                              .data[i]['sm']))
                                                          .toStringAsFixed(0)
                                                      : snap.data[i]['sm'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 30),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3.0),
                                                      child: Visibility(
                                                        visible: snap.data[i]
                                                                    ['etat'] ==
                                                                '1'
                                                            ? widget.isboss == 1
                                                                ? true
                                                                : delet
                                                            : delet,
                                                        child: IconButton(
                                                            splashColor:
                                                                Colors.white,
                                                            icon: Icon(
                                                              Icons.delete,
                                                              size: 30,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              try {
                                                                if (widget
                                                                        .controled ==
                                                                    0) {
                                                                  if (snap.data[
                                                                              i]
                                                                          [
                                                                          'etat'] ==
                                                                      "1") {
                                                                    deleteventeargant(
                                                                        snap.data[i]
                                                                            [
                                                                            'dat']);
                                                                  } else {
                                                                    Fluttertoast.showToast(
                                                                        msg: widget.l.fra == 1
                                                                            ? "Touchez d'abord sur ce symbole Rouge"
                                                                            : widget.l.eng == 1
                                                                                ? "Touch First on the red symbol"
                                                                                : widget.l.swa == 1
                                                                                    ? "Gusa kwanza kwenye hiyo harama nyekundu"
                                                                                    : "Banza ufyonde ako kamenyetso gatukura",
                                                                        backgroundColor: Colors.red,
                                                                        gravity: ToastGravity.CENTER,
                                                                        toastLength: Toast.LENGTH_LONG);
                                                                  }
                                                                } else if ((int.parse(snap.data[i]
                                                                            [
                                                                            'etat']) >
                                                                        0) &&
                                                                    (widget.controled ==
                                                                        1)) {
                                                                  messagevalidersuppression(
                                                                      snap.data[
                                                                              i]
                                                                          [
                                                                          'sm'],
                                                                      snap.data[
                                                                              i]
                                                                          [
                                                                          'dat'],
                                                                      i);
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      msg: widget.l.fra == 1
                                                                          ? "Confirmez d'abord votre travailleur que vous avez vue cette somme en appuyant sur le symbole rouge"
                                                                          : widget.l.eng == 1
                                                                              ? "conform first your worker that you have seen this money by pression that red symbol"
                                                                              : widget.l.swa == 1
                                                                                  ? "Thibitisha kwanza mufanyakazi wako kama umeona pesa hizi kwakubonyeza iyo harama nyekundu"
                                                                                  : "Boss Banza Mwemezeko Mwatoye ayo mahera Mukwemeza Komwatoye aya mahera Fyonda ako kamenyetso gatukura",
                                                                      backgroundColor: Colors.red,
                                                                      gravity: ToastGravity.CENTER,
                                                                      toastLength: Toast.LENGTH_LONG);
                                                                }
                                                              } catch (e) {
                                                                return;
                                                              }
                                                            }),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 3.0),
                                                      child: IconButton(
                                                          splashColor:
                                                              Colors.white,
                                                          icon: snap.data[i][
                                                                      'etat'] ==
                                                                  '1'
                                                              ? Icon(
                                                                  Icons
                                                                      .done_all,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 40,
                                                                )
                                                              : Icon(Icons.done,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 50),
                                                          onPressed: () {
                                                            if ((widget.isboss ==
                                                                    1) &&
                                                                (widget.controled ==
                                                                    0)) {
                                                              if (snap.data[i][
                                                                      'etat'] ==
                                                                  '0') {
                                                                updateagtetatvue(
                                                                    snap.data[i]
                                                                        [
                                                                        'dat']);
                                                              }
                                                            } else if (widget
                                                                    .controled ==
                                                                1) {
                                                              if (snap.data[i][
                                                                      'etat'] ==
                                                                  '0') {
                                                                confimationvue(
                                                                    snap.data[i]
                                                                        ['sm'],
                                                                    snap.data[i]
                                                                        [
                                                                        'dat']);
                                                              }
                                                            } else {
                                                              return;
                                                            }
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )),
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
