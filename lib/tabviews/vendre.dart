import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../servicepayement.dart';
import 'travailleurs/nostock.dart';

class Vendre extends StatefulWidget {
  final Langue l;
  final String numero;
  final String password;
  final int isboss;
  final int duree;
  final String worker;
  final int controled;
  Vendre(
      {Key key,
      this.l,
      this.numero,
      this.password,
      this.isboss,
      this.duree,
      this.worker,
      this.controled})
      : super(key: key);

  @override
  _VendreState createState() => _VendreState();
}

class _VendreState extends State<Vendre> {
  TextEditingController name = new TextEditingController();
  TextEditingController prix = new TextEditingController();
  TextEditingController qte = new TextEditingController();
  TextEditingController namecl = new TextEditingController();
  TextEditingController prenomcl = new TextEditingController();
  TextEditingController total = new TextEditingController();
  TextEditingController resultat1 = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String etat = "0";
  var stock = [];
  Timer _timer;
  ScrollController _scrollcontroller = new ScrollController();
  StreamController<List> _streamcontroller = StreamController<List>();
  FocusNode focusnode;
  FocusNode focusnode1;
  @override
  void initState() {
    focusnode = FocusNode();
    focusnode1 = FocusNode();
    focusnode.addListener(() {});
    focusnode1.addListener(() {});
    selectstock();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      selectstock();
    });
    super.initState();
  }

  dismisskeyboard() {
    focusnode.unfocus();
    focusnode1.unfocus();
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    focusnode1.dispose();
    focusnode.dispose();
    _scrollcontroller.dispose();
    _streamcontroller.close();
    name.dispose();
    stock.clear();
    prix.dispose();
    qte.dispose();
    resultat1.dispose();
    namecl.dispose();
    total.dispose();
    prenomcl.dispose();
    super.dispose();
  }

  selectstock() async {
    try {
      final response = await http.post(
        "https://kakwetuburundifafanini.com/gs/selectstock.php",
        body: {
          "nro": widget.numero,
        },
      );
      var resultat = await compute(_isolate, response.body);
      setState(() {
        _streamcontroller.add(resultat);
        stock = resultat;
      });
    } catch (e) {
      setState(() {
        stock = [];
      });
    }
  }

  static _isolate(String body) {
    return jsonDecode(body);
  }

  bool visible1 = false;
  addvante() async {
    setState(() {
      visible1 = true;
      ispop = false;
    });
    try {
      if (name.text.isNotEmpty &&
          (double.parse(prix.text) > 0) &&
          (double.parse(qte.text) > 0) &&
          (double.parse(resultat1.text) >= double.parse(qte.text))) {
        http.post(
          "https://kakwetuburundifafanini.com/av/addventep.php",
          body: {
            "nom": name.text.toUpperCase().trim(),
            "nro": widget.numero,
            "px": prix.text.replaceAll(' ', '').trim(),
            "qte": qte.text.replaceAll(' ', '').trim(),
            "etat": etat,
            "q_encien": qte.text.replaceAll(' ', '').trim(),
          },
        ).then((value) {
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
            selectstock();
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
          prix.text = "";
          qte.text = "";
          name.text = "";
          total.text = "";
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
          visible1 = false;
          ispop = true;
          dismisskeyboard();
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
        visible1 = false;
        ispop = true;
        dismisskeyboard();
      });
      return;
    }
  }

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Votre paquet a expiré,Vous Voulez payer pour un autre ?",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Your Packet has Finished,Do you want to pay once again ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Mfuko wako Umeisha,Munataka kulipa tena ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center)
                  : Text(
                      "Umutekero wanyu Waheze,Mushaka kuriha kandi ?",
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
              ? Text(
                  "Non",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
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

  paspayemessageechec() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Desolé Il y a un probleme,Réessayez plus tard",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Sorry There is a problem,Retry Later",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Samahani Kuko Tatizo,jaribu Tena",
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              color: Colors.white,
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

  void messagevalidation() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Vous Voulez Vendre " + qte.text + " " + name.text + " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Do you want to sell " + qte.text + " " + name.text + " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text(
                      "Unataka kuuzisha " + name.text + " " + qte.text + " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka gucuruza " + name.text + " " + qte.text + " ?",
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
              prix.text = "";
              name.text = "";
              qte.text = "";
              prix.text = "";
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
            dismisskeyboard();
            try {
              if (double.parse(qte.text.trim()) > 0 &&
                  double.parse(prix.text.trim()) > 0) {
                Navigator.pop(context);
                if (double.parse(resultat1.text) >=
                    double.parse(qte.text.trim().replaceAll(' ', ''))) {
                  if (widget.isboss == 0) {
                    if (widget.worker == "y") {
                      addvante();
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
                    addvante();
                  }
                } else {
                  setState(() {
                    Fluttertoast.showToast(
                        msg: widget.l.fra == 1
                            ? "Verifiez Votre Stock"
                            : widget.l.eng == 1
                                ? "Check your stock"
                                : widget.l.swa == 1
                                    ? "Cunguza Hisa yako"
                                    : "Suzuma Sitoke yawe",
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_LONG);
                    visible1 = false;
                    ispop = true;
                  });
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
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              fontSize: 25,
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

  bool ispop = true;
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
        duration: Duration(seconds: stock.isEmpty ? 1 : (stock.length * 2)),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StreamBuilder<List>(
              stream: _streamcontroller.stream,
              builder: (context, snap) {
                if (snap.hasError) {
                } else if (snap.hasData) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        child: Column(
                          children: [
                            Expanded(
                                child: Scrollbar(
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  controller: _scrollcontroller,
                                  itemCount: snap.data.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      splashColor: Colors.white,
                                      onLongPress: () {
                                        setState(() {
                                          name.text = "";
                                        });
                                      },
                                      onTap: () {
                                        if (name.text.isEmpty) {
                                          setState(() {
                                            name.text = snap.data[i]['nom'];
                                            resultat1.text = (snap.data[i]
                                                    ['q_encien'])
                                                .toString();
                                          });
                                        } else {
                                          setState(() {
                                            name.text = "";
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                snap.data[i]['nom'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: widget.l.fra == 1
                                                  ? Text(
                                                      "Stock:" +
                                                          snap.data[i]
                                                              ['q_encien'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )
                                                  : widget.l.eng == 1
                                                      ? Text(
                                                          "Stock:" +
                                                              snap.data[i]
                                                                  ['q_encien'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      : widget.l.swa == 1
                                                          ? Text(
                                                              "Hisa:" +
                                                                  snap.data[i][
                                                                      'q_encien'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : Text(
                                                              "Sitoke:" +
                                                                  snap.data[i][
                                                                      'q_encien'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
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
          Expanded(
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
                            Card(
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.grey, width: 0),
                                  borderRadius: BorderRadius.circular(30)),
                              color: Colors.white24,
                              child: InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  showSearch(
                                      context: context,
                                      delegate: DataSearch1(name, context,
                                          widget.l, stock, resultat1));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    widget.l.fra == 1
                                        ? Text(
                                            "Chercher",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )
                                        : widget.l.eng == 1
                                            ? Text(
                                                "Search",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                            : widget.l.swa == 1
                                                ? Text(
                                                    "Tafuta",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    "Higa",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.search),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            widget.l.fra == 1
                                ? Text(
                                    "Facture",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  )
                                : widget.l.eng == 1
                                    ? Text(
                                        "Invoice",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      )
                                    : widget.l.swa == 1
                                        ? Text(
                                            "Bili",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          )
                                        : Text(
                                            "Fagitire",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                            Container(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: TextFormField(
                                    enabled: false,
                                    controller: name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        labelText: widget.l.fra == 1
                                            ? "Produit"
                                            : widget.l.eng == 1
                                                ? "Product"
                                                : widget.l.swa == 1
                                                    ? "Bidhaa"
                                                    : "Ikidandazwa",
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return widget.l.fra == 1
                                            ? 'Choisissez le produit'
                                            : widget.l.eng == 1
                                                ? 'choose a product'
                                                : widget.l.swa == 1
                                                    ? 'Chagua bidhaa'
                                                    : 'Hitamwo Igicuruzwa';
                                      }
                                      return null;
                                    }),
                              ),
                            ),
                            Container(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: TextFormField(
                                  focusNode: focusnode,
                                  autofocus: false,
                                  onChanged: (v) {
                                    try {
                                      setState(() {
                                        total.text = (double.parse(prix.text) *
                                                double.parse(v))
                                            .toString();
                                      });
                                    } catch (e) {
                                      setState(() {
                                        total.text = "";
                                      });
                                    }
                                  },
                                  controller: qte,
                                  inputFormatters: [
                                    new FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                      labelText: widget.l.fra == 1
                                          ? "Quantite"
                                          : widget.l.eng == 1
                                              ? "Quantity"
                                              : widget.l.swa == 1
                                                  ? "Wingi"
                                                  : "Igitigiri",
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  validator: (value) {
                                    if ((value.isEmpty) || (qte.text == "0")) {
                                      return widget.l.fra == 1
                                          ? 'Entrez la Quantite'
                                          : widget.l.eng == 1
                                              ? 'Enter a Quantity'
                                              : widget.l.swa == 1
                                                  ? 'Andika wingi wake'
                                                  : 'Shiramwo uko bingana';
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
                                              ? 'remove space'
                                              : widget.l.swa == 1
                                                  ? 'ambatanisha wingi'
                                                  : 'Fatanya';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: TextFormField(
                                  focusNode: focusnode1,
                                  autofocus: false,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (v) {
                                    try {
                                      setState(() {
                                        total.text = (double.parse(qte.text) *
                                                double.parse(v))
                                            .toString();
                                      });
                                    } catch (e) {
                                      setState(() {
                                        total.text = "";
                                      });
                                    }
                                  },
                                  controller: prix,
                                  inputFormatters: [
                                    new FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                      labelText: widget.l.fra == 1
                                          ? "Prix"
                                          : widget.l.eng == 1
                                              ? "Price"
                                              : widget.l.swa == 1
                                                  ? "Bei"
                                                  : "Igiciro",
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  validator: (value) {
                                    if ((value.isEmpty) || (prix.text == "0")) {
                                      return widget.l.fra == 1
                                          ? 'Entrez Le prix'
                                          : widget.l.eng == 1
                                              ? 'Enter a price'
                                              : widget.l.swa == 1
                                                  ? 'Andika bei'
                                                  : "Andika Igiciro";
                                    } else if (prix.text.contains(",")) {
                                      return widget.l.fra == 1
                                          ? 'Utilisez .'
                                          : widget.l.eng == 1
                                              ? 'Use .'
                                              : widget.l.swa == 1
                                                  ? 'Tumiya .'
                                                  : 'Koresha .';
                                    } else if (prix.text.contains("-")) {
                                      return widget.l.fra == 1
                                          ? 'Enlevez -'
                                          : widget.l.eng == 1
                                              ? 'remove -'
                                              : widget.l.swa == 1
                                                  ? 'tosha -'
                                                  : 'kuramwo -';
                                    } else if (prix.text.contains(" ")) {
                                      return widget.l.fra == 1
                                          ? "Enlevez l'espace"
                                          : widget.l.eng == 1
                                              ? 'remove a space'
                                              : widget.l.swa == 1
                                                  ? 'ambatanisha wingi'
                                                  : 'Fatanya';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: TextFormField(
                                  controller: total,
                                  enabled: false,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                  maxLength: 30,
                                  decoration: InputDecoration(
                                      labelText: widget.l.fra == 1
                                          ? "Total"
                                          : widget.l.eng == 1
                                              ? "Total"
                                              : widget.l.swa == 1
                                                  ? "Jumla"
                                                  : "Yose",
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return widget.l.fra == 1
                                          ? 'le prix ou la quantite'
                                          : widget.l.eng == 1
                                              ? 'Price or quantity'
                                              : widget.l.swa == 1
                                                  ? 'bei au wingi'
                                                  : "Ikiguzi canke igitigiri";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: TextFormField(
                                controller: resultat1,
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.white,
                              onTap: () {
                                if (widget.duree >= 0) {
                                  if (_formKey.currentState.validate()) {
                                    dismisskeyboard();
                                    if (name.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: widget.l.fra == 1
                                              ? "chosissez le produit"
                                              : widget.l.eng == 1
                                                  ? "Choose a product"
                                                  : widget.l.swa == 1
                                                      ? "Bidhaa inaitajika"
                                                      : "Mucagure igicuruzwa",
                                          backgroundColor: Colors.red,
                                          gravity: ToastGravity.CENTER,
                                          toastLength: Toast.LENGTH_LONG);
                                    } else if (total.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: widget.l.fra == 1
                                              ? "Ecrivez la quatité et le prix"
                                              : widget.l.eng == 1
                                                  ? "Write a quantity and a price"
                                                  : widget.l.swa == 1
                                                      ? "Andika kiasi na bei"
                                                      : "Mwandike igiciro n'igitigiri",
                                          backgroundColor: Colors.red,
                                          gravity: ToastGravity.CENTER,
                                          toastLength: Toast.LENGTH_LONG);
                                    } else {
                                      messagevalidation();
                                    }
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
                                                  fontWeight: FontWeight.bold),
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
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      'Emeza',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                    ),
                                  ),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(2),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black26, width: 5),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      widget.l.fra == 1
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Ecrivez La facture quand Tu as L'argent",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : widget.l.eng == 1
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Write Invoice When You have money",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : widget.l.swa == 1
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Andika Bili Kama Umelipisha pesa",
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Andika Fagitire Bakurishe",
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Nostock(
                                                l: widget.l,
                                                numero: widget.numero,
                                                duree: widget.duree,
                                                isboss: widget.isboss,
                                                worker: widget.worker,
                                                controled: widget.controled,
                                              )));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 5),
                                    child: Container(
                                        color: Colors.lightBlueAccent,
                                        alignment: Alignment.center,
                                        child: widget.l.eng == 1
                                            ? Text(
                                                'No stock',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : widget.l.swa == 1
                                                ? Text(
                                                    'Hakuna hisa',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : widget.l.fra == 1
                                                    ? Text(
                                                        'Pas de stock',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        'Nta sitoke',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))),
                              ),
                            ),
                          ],
                        )),
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

class DataSearch1 extends SearchDelegate<String> {
  TextEditingController nom = new TextEditingController();
  TextEditingController resultat1 = new TextEditingController();
  BuildContext context;
  Langue l;
  var noms;
  String numero;
  DataSearch1(this.nom, this.context, this.l, this.noms, this.resultat1);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.red,
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugest = query.isEmpty
        ? this.noms
        : this
            .noms
            .where((element) =>
                element['nom']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element['nom']
                    .toString()
                    .toUpperCase()
                    .contains(query.toUpperCase()))
            .toList();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: sugest.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        nom.text = sugest[index]['nom'];
                        resultat1.text = (sugest[index]['q_encien']).toString();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 3),
                        child: Column(
                          children: [
                            Card(
                              elevation: 0,
                              margin: EdgeInsets.all(2),
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.grey, width: 5),
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.blueGrey,
                              child: ListTile(
                                subtitle: this.l.fra == 1
                                    ? Text("Stock:" + sugest[index]['q_encien'],
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white))
                                    : this.l.eng == 1
                                        ? Text(
                                            "Stock:" +
                                                sugest[index]['q_encien'],
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white))
                                        : this.l.swa == 1
                                            ? Text(
                                                "Hisa:" +
                                                    sugest[index]['q_encien'],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white))
                                            : Text(
                                                "Sitoke:" +
                                                    sugest[index]['q_encien'],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white)),
                                title: RichText(
                                  text: TextSpan(
                                      text: sugest[index]['nom']
                                          .substring(0, query.length),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                      children: [
                                        TextSpan(
                                            text: sugest[index]['nom']
                                                .substring(query.length),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 30)),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
