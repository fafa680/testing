import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:kakwetu/servicepayement.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Nostock extends StatefulWidget {
  final Langue l;
  final String numero;
  final int isboss;
  final int duree;
  final String worker;
  final int controled;
  Nostock(
      {Key key,
      this.l,
      this.numero,
      this.duree,
      this.isboss,
      this.worker,
      this.controled})
      : super(key: key);

  @override
  _NostockState createState() => _NostockState();
}

class _NostockState extends State<Nostock> {
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
                            duree: widget.duree,
                            isboss: widget.isboss,
                            worker: widget.worker,
                            controled: widget.controled,
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

//dedinition du formulaireq

class Myform extends StatefulWidget {
  final Langue l;
  final String numero;
  final int isboss;
  final int duree;
  final String worker;
  final int controled;
  Myform(
      {Key key,
      this.l,
      this.numero,
      this.duree,
      this.isboss,
      this.worker,
      this.controled})
      : super(key: key);

  @override
  _MyformState createState() => _MyformState();
}

class _MyformState extends State<Myform> {
  var argent = [];
  Timer _timer;
  bool delet = false;
  TextEditingController qte = new TextEditingController();
  StreamController<List> _streamcontroller1 = StreamController<List>();
  ScrollController _scrollcontroller = new ScrollController();
  FocusNode focusnode;
  @override
  void initState() {
    focusnode = FocusNode();
    focusnode.addListener(() {});
    selectnostock();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      selectnostock();
    });
    super.initState();
  }

  dismisskeyboard() {
    focusnode.unfocus();
  }

  @override
  void dispose() {
    focusnode.dispose();
    qte.dispose();
    _scrollcontroller.dispose();
    _streamcontroller1.close();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  static _isolate(String body) {
    return jsonDecode(body);
  }

  selectnostock() async {
    try {
      final response = await http
          .post("https://kakwetuburundifafanini.com/nstok/gnstok.php", body: {
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

  firstchecknostock() {
    setState(() {
      visible1 = true;
      ispop = false;
    });
    try {
      if ((double.parse(qte.text) > 0)) {
        http.post("https://kakwetuburundifafanini.com/nstok/fchenostok.php",
            body: {
              "nro": widget.numero,
              "px": qte.text.replaceAll(' ', '').trim(),
              "etat": "0",
            }).then((value) {
          if (value.statusCode == 200) {
            Fluttertoast.showToast(
                msg: widget.l.fra == 1
                    ? "Bien Fait"
                    : widget.l.eng == 1
                        ? "Done"
                        : widget.l.swa == 1
                            ? "Umeweza"
                            : "Vyakunze",
                backgroundColor: Colors.black,
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG);
            selectnostock();
          } else {
            Fluttertoast.showToast(
                msg: widget.l.fra == 1
                    ? "Operation Echouée"
                    : widget.l.eng == 1
                        ? "Failed"
                        : widget.l.swa == 1
                            ? "Bimekatala"
                            : "Ntivyakunze",
                backgroundColor: Colors.red,
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG);
          }
        });
        setState(() {
          visible1 = false;
          ispop = true;
          qte.text = "";
          dismisskeyboard();
        });
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Operation Echouée"
                  : widget.l.eng == 1
                      ? "Failed"
                      : widget.l.swa == 1
                          ? "Bimekatala"
                          : "Ntivyakunze",
              backgroundColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          dismisskeyboard();
          visible1 = false;
          ispop = true;
        });
      }
    } catch (e) {
      setState(() {
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Operation Echouée"
                : widget.l.eng == 1
                    ? "Failed"
                    : widget.l.swa == 1
                        ? "Bimekatala"
                        : "Ntivyakunze",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        dismisskeyboard();
        visible1 = false;
        ispop = true;
      });
      return;
    }
  }

  deleteventeargant(String date) {
    setState(() {
      delet = false;
    });
    try {
      http.post("https://kakwetuburundifafanini.com/nstok/denostok.php", body: {
        "dat": date,
        "nro": widget.numero,
        "etat": "1",
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
      ispop = false;
    });
    try {
      http.post("https://kakwetuburundifafanini.com/nstok/vuenostok.php",
          body: {
            "dat": date,
            "etat": "1",
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

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Votre paquet a expiré Vous Voulez payer encore",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Your Packet has Finished Do you want to pay once again ?",
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
          splashColor: Colors.white,
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
          splashColor: Colors.white,
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
          splashColor: Colors.white,
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

  void messagevalidation() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("C'est " + qte.text + " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("It is " + qte.text + " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Ni " + qte.text + " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Ni " + qte.text + " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            setState(() {
              qte.text = "";
            });

            Navigator.pop(context);
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
            try {
              if (double.parse(qte.text.trim()) > 0) {
                Navigator.pop(context);
                if (widget.isboss == 0) {
                  if (widget.worker == "y") {
                    firstchecknostock();
                  } else if (widget.worker == "n") {
                    setState(() {
                      Fluttertoast.showToast(
                          msg: widget.l.fra == 1
                              ? "Desolé,Vous n'avez pas L'autorisation d'enregistrer,Contacter Votre Boss"
                              : widget.l.eng == 1
                                  ? "Sorry,You don't have a permission of registering,please Contact your Boss"
                                  : widget.l.swa == 1
                                      ? "Samahani,Umenyanganywa Ruhusa Rwakuingiza Bidhaa,Wasiriana kwanza na Boss wako"
                                      : "Muradutunga,Mwatswe Uburenganzira,Nimubaze Boss Wanyu",
                          backgroundColor: Colors.red,
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_LONG);
                      visible1 = false;
                      ispop = true;
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  } else {
                    setState(() {
                      Fluttertoast.showToast(
                          msg: widget.l.fra == 1
                              ? "Reessayez encore"
                              : widget.l.eng == 1
                                  ? "Retry"
                                  : widget.l.swa == 1
                                      ? "Bonyeza tena"
                                      : "Subira Wemeze",
                          backgroundColor: Colors.red,
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_LONG);
                      visible1 = false;
                      ispop = true;
                    });
                  }
                } else {
                  firstchecknostock();
                }
              } else {
                Fluttertoast.showToast(
                    msg: widget.l.fra == 1
                        ? "Soyez Serieux!!!!! Cette Valeur est Invalide"
                        : widget.l.eng == 1
                            ? "Be Serious!!!!! That value is not valid"
                            : widget.l.swa == 1
                                ? "Samahani!!!! Kiasi hico Hatukikubari"
                                : "Muradutunga!!! Ico gitigiri Nticemewe",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.CENTER,
                    toastLength: Toast.LENGTH_LONG);
              }
            } catch (e) {
              Fluttertoast.showToast(
                  msg: widget.l.fra == 1
                      ? "utilisez . comme virgule"
                      : widget.l.eng == 1
                          ? "use . for double"
                          : widget.l.swa == 1
                              ? "Tumia . kama mkato"
                              : "Nimukoreshe . Mukwandika igitigiri kirimwo ibice",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG);
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

  bool visible1 = false;
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
        duration: Duration(seconds: argent.isEmpty ? 1 : (argent.length * 2)),
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

  bool ispop = true;
  Future<bool> _willpop() async {
    return Future.value(ispop);
  }

  bool tous = false;
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
                                                              left: 3),
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
          Visibility(
            visible: widget.controled == 1 ? false : true,
            child: Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 3),
                  child: Container(
                    width: 175,
                    child: Card(
                      color: Colors.white30,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                    focusNode: focusnode,
                                    controller: qte,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    inputFormatters: [
                                      new FilteringTextInputFormatter.allow(
                                          RegExp("[0-9.]"))
                                    ],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                        labelText: widget.l.fra == 1
                                            ? "Somme"
                                            : widget.l.eng == 1
                                                ? "Amount"
                                                : widget.l.swa == 1
                                                    ? "Kiasi"
                                                    : "Ikiguzi",
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    validator: (value) {
                                      if ((value.isEmpty) ||
                                          (qte.text == "0")) {
                                        return widget.l.fra == 1
                                            ? 'Entrez le Montant'
                                            : widget.l.eng == 1
                                                ? 'Enter an Amount'
                                                : widget.l.swa == 1
                                                    ? 'Andika kiasi'
                                                    : 'Shiramwo ikiguzi';
                                      } else if (qte.text.contains(",")) {
                                        return widget.l.fra == 1
                                            ? 'Utilisez .'
                                            : widget.l.eng == 1
                                                ? 'Use .'
                                                : widget.l.swa == 1
                                                    ? 'Tumiya .'
                                                    : 'Koresha .';
                                      } else if (qte.text.contains("-")) {
                                        return widget.l.fra == 1
                                            ? 'Enlevez -'
                                            : widget.l.eng == 1
                                                ? 'remove -'
                                                : widget.l.swa == 1
                                                    ? 'tosha -'
                                                    : 'kuramwo -';
                                      } else if (qte.text.contains(" ")) {
                                        return widget.l.fra == 1
                                            ? "Enlevez l'espace"
                                            : widget.l.eng == 1
                                                ? 'remove a space'
                                                : widget.l.swa == 1
                                                    ? 'ambatanisha'
                                                    : 'Fatanya';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  if (widget.duree >= 0) {
                                    if (_formKey.currentState.validate()) {
                                      dismisskeyboard();
                                      messagevalidation();
                                    }
                                  } else {
                                    if (widget.duree != -1002) {
                                      paspayemessage();
                                    } else {
                                      paspayemessageechec();
                                    }
                                  }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 5),
                                    child: Container(
                                        color: Colors.lightBlueAccent,
                                        alignment: Alignment.center,
                                        child: widget.l.eng == 1
                                            ? Text(
                                                'Accept',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : widget.l.swa == 1
                                                ? Text(
                                                    'Kubali',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : widget.l.fra == 1
                                                    ? Text(
                                                        'Accepter',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        'Emeza',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Visibility(
                                    visible: visible1,
                                    child: Center(
                                        child: LinearProgressIndicator(
                                      backgroundColor: Colors.cyanAccent,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.red),
                                    ))),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.black26, width: 5),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        widget.l.fra == 1
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Acceptez quand vous avez l'snap.data",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            : widget.l.eng == 1
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Accept when you have money",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                : widget.l.swa == 1
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Kubali ukiwa na pesa",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Emeza wamaze gutora amahera",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                          textAlign:
                                                              TextAlign.center,
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
                          )),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
