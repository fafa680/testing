import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../servicepayement.dart';
import 'travailleurs/peyementdette.dart';
import 'package:flutter/foundation.dart';

class Dette extends StatefulWidget {
  final Langue l;
  final int isboss;
  final int controled;
  final String numero;
  final String password;
  final int duree;
  final String worker;
  Dette(
      {Key key,
      this.l,
      this.isboss,
      this.controled,
      this.numero,
      this.password,
      this.duree,
      this.worker})
      : super(key: key);

  @override
  _DetteState createState() => _DetteState();
}

class _DetteState extends State<Dette> {
  TextEditingController name = new TextEditingController();
  TextEditingController prix = new TextEditingController();
  TextEditingController qte = new TextEditingController();
  TextEditingController namecl = new TextEditingController();
  TextEditingController prenomcl = new TextEditingController();
  TextEditingController telcl = new TextEditingController();
  TextEditingController total = new TextEditingController();
  TextEditingController resultat1 = new TextEditingController();
  Timer _timer;
  StreamController<List> _streamcontroller1 = StreamController<List>();
  StreamController<List> _streamcontroller = StreamController<List>();
  ScrollController _scrollcontroller = new ScrollController();
  ScrollController _scrollcontroller1 = new ScrollController();
  bool ispop = true;
  FocusNode focusnode;
  FocusNode focusnode1;
  FocusNode focusnode2;
  FocusNode focusnode3;
  FocusNode focusnode4;
  @override
  void initState() {
    focusnode = FocusNode();
    focusnode1 = FocusNode();
    focusnode2 = FocusNode();
    focusnode3 = FocusNode();
    focusnode4 = FocusNode();
    focusnode.addListener(() {});
    focusnode1.addListener(() {});
    focusnode2.addListener(() {});
    focusnode3.addListener(() {});
    focusnode4.addListener(() {});
    selectdette();
    selectstock();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      selectdette();
      selectstock();
    });
    super.initState();
  }

  dismisskeyboard() {
    focusnode.unfocus();
    focusnode1.unfocus();
    focusnode2.unfocus();
    focusnode3.unfocus();
    focusnode4.unfocus();
  }

  @override
  void dispose() {
    focusnode1.dispose();
    focusnode.dispose();
    focusnode2.dispose();
    focusnode3.dispose();
    focusnode4.dispose();
    _streamcontroller.close();
    _streamcontroller1.close();
    _scrollcontroller.dispose();
    _scrollcontroller1.dispose();
    name.dispose();
    prix.dispose();
    if (_timer.isActive) _timer.cancel();
    qte.dispose();
    namecl.dispose();
    prenomcl.dispose();
    resultat1.dispose();
    telcl.dispose();
    stock.clear();
    probleme.clear();
    total.clear();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  var stock = [];
  var probleme = [];
  selectstock() async {
    try {
      final response = await http
          .post("https://kakwetuburundifafanini.com/gs/selectstock.php", body: {
        "nro": widget.numero,
      });
      var resultat = await compute(_isolate, response.body);
      setState(() {
        _streamcontroller1.add(resultat);
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

  selectdette() async {
    try {
      final response = await http
          .post("https://kakwetuburundifafanini.com/gd/selectdette.php", body: {
        "nro": widget.numero,
      });
      var resultat = await compute(_isolate, response.body);
      setState(() {
        _streamcontroller.add(resultat);
        probleme = resultat;
      });
    } catch (e) {
      setState(() {
        probleme = [];
      });
    }
  }

  firstcheckdette() {
    setState(() {
      ispop = false;
      visible1 = true;
    });
    try {
      if (name.text.isNotEmpty &&
          namecl.text.isNotEmpty &&
          prenomcl.text.isNotEmpty &&
          telcl.text.isNotEmpty &&
          (double.parse(prix.text) > 0) &&
          (double.parse(qte.text) > 0) &&
          double.parse(resultat1.text) >= double.parse(qte.text)) {
        http.post("https://kakwetuburundifafanini.com/fd/firstcheckdette1.php",
            body: {
              "nom": name.text.trim().toUpperCase().replaceAll(' ', ''),
              "nom_client":
                  namecl.text.trim().toUpperCase().replaceAll(' ', ''),
              "prenom_client":
                  prenomcl.text.trim().toUpperCase().replaceAll(' ', ''),
              "telephone_client": telcl.text.trim().replaceAll(' ', ''),
              "nro": widget.numero,
              "px": prix.text.trim().replaceAll(' ', ''),
              "qte": qte.text.trim().replaceAll(' ', ''),
              "q_encien": qte.text.trim().replaceAll(' ', ''),
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
            selectdette();
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
          name.text = "";
          qte.text = "";
          prix.text = "";
          namecl.text = "";
          prenomcl.text = "";
          telcl.text = "";
          total.text = "";
          ispop = true;
          visible1 = false;
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
    }
  }

  paspayemessageechec() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Desolé Il y a un snap.data,Réessayez plus tard",
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

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Votre paquet a expiré Vous Voulez payer encore ?",
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

  bool visible1 = false;

  void messagevalidation() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text(
              "Vous Voulez Enregistrer Une dette de " +
                  qte.text +
                  " " +
                  name.text +
                  "?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text(
                  "Do you want to Register a debt of " +
                      qte.text +
                      "  " +
                      name.text +
                      " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text(
                      "Unataka kupana deni la " +
                          name.text +
                          "  " +
                          qte.text +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka gutanga ideni rya " +
                          name.text +
                          "  " +
                          qte.text +
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
            setState(() {
              name.text = "";
              qte.text = "";
              namecl.text = "";
              prenomcl.text = "";
              prix.text = "";
              telcl.text = "";
              total.text = "";
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
              if ((double.parse(qte.text.trim()) > 0) &&
                  (double.parse(prix.text.trim()) > 0)) {
                Navigator.pop(context);
                if (double.parse(resultat1.text) >= double.parse(qte.text)) {
                  if (widget.isboss == 0) {
                    if (widget.worker == "y") {
                      firstcheckdette();
                    } else if (widget.worker == "n") {
                      setState(() {
                        Fluttertoast.showToast(
                            msg: widget.l.fra == 1
                                ? "Desolé,Vous Avez pas L'autorisation d'enregistrer,Contacter Votre Boss"
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
                                ? "Réessayez encore"
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
                    firstcheckdette();
                  }
                } else {
                  setState(() {
                    Fluttertoast.showToast(
                        msg: widget.l.fra == 1
                            ? "Vérifier Votre snap.data"
                            : widget.l.eng == 1
                                ? "Check your snap.data"
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
                      ? "utilisez . comme virgule(pour les decimaux)"
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
        duration: Duration(seconds: probleme.isEmpty ? 1 : probleme.length * 2),
        curve: Curves.easeOut);
    setState(() {
      _isontop = false;
    });
  }

  bool _isontop1 = true;
  _scrolltop1() {
    _scrollcontroller1.animateTo(_scrollcontroller1.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() {
      _isontop1 = true;
    });
  }

  _scrolldown1() {
    _scrollcontroller1.animateTo(_scrollcontroller1.position.maxScrollExtent,
        duration: Duration(seconds: stock.isEmpty ? 1 : stock.length * 2),
        curve: Curves.easeOut);
    setState(() {
      _isontop1 = false;
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
          Visibility(
            visible: widget.controled == 1 ? true : false,
            child: StreamBuilder<List>(
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 20),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.grey, width: 0),
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.white24,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      showSearch(
                                          context: context,
                                          delegate: DataSearch2(
                                              context,
                                              widget.l,
                                              widget.numero,
                                              widget.worker,
                                              widget.duree,
                                              widget.controled,
                                              widget.isboss,
                                              snap.data,
                                              namecl,
                                              prenomcl,
                                              telcl));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )
                                                : widget.l.swa == 1
                                                    ? Text(
                                                        "Tafuta",
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        "Higa",
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.search),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Scrollbar(
                                child: ListView.builder(
                                    controller: _scrollcontroller,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snap.data.length,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        splashColor: Colors.white,
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
                                                  child: widget.l.fra == 1
                                                      ? snap.data[i]['jour']
                                                                  .toString() ==
                                                              '1'
                                                          ? Text(
                                                              "Dimanche le " +
                                                                  snap.data[i]
                                                                      ['dat'] +
                                                                  " : ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                          : snap.data[i]['jour']
                                                                      .toString() ==
                                                                  '2'
                                                              ? Text("Lundi le " + snap.data[i]['dat'] + " : ",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white))
                                                              : snap.data[i]['jour'].toString() == '3'
                                                                  ? Text("Mardi le " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                  : snap.data[i]['jour'].toString() == '4'
                                                                      ? Text("Mercredi le " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                      : snap.data[i]['jour'].toString() == '5'
                                                                          ? Text("Jeudi le " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                          : snap.data[i]['jour'].toString() == '6'
                                                                              ? Text("Vendredi le " + snap.data[i]['dat'] + ":", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                              : Text("Samedi le " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                      : widget.l.eng == 1
                                                          ? snap.data[i]['jour'].toString() == '1'
                                                              ? Text("Sunday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                              : snap.data[i]['jour'].toString() == '2'
                                                                  ? Text("Monday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                  : snap.data[i]['jour'].toString() == '3'
                                                                      ? Text("Tuesday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                      : snap.data[i]['jour'].toString() == '4'
                                                                          ? Text("Wednesday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                          : snap.data[i]['jour'].toString() == '5'
                                                                              ? Text("Thursday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                              : snap.data[i]['jour'].toString() == '6'
                                                                                  ? Text("Friday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                  : Text("Saturday the " + snap.data[i]['dat'] + ":", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                          : widget.l.swa == 1
                                                              ? snap.data[i]['jour'].toString() == '1'
                                                                  ? Text("Jumapili tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                  : snap.data[i]['jour'].toString() == '2'
                                                                      ? Text("Jumatatu tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                      : snap.data[i]['jour'].toString() == '3'
                                                                          ? Text("Jumanne tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                          : snap.data[i]['jour'].toString() == '4'
                                                                              ? Text("Jumatano tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                              : snap.data[i]['jour'].toString() == '5'
                                                                                  ? Text("Alhamisi tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                  : snap.data[i]['jour'].toString() == '6'
                                                                                      ? Text("Ijumaa tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                      : Text("Jumamosi tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                              : snap.data[i]['jour'].toString() == '1'
                                                                  ? Text("Kuw'Imana itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                  : snap.data[i]['jour'].toString() == '2'
                                                                      ? Text("Kuwambere Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                      : snap.data[i]['jour'].toString() == '3'
                                                                          ? Text("Kuwakabiri Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                          : snap.data[i]['jour'].toString() == '4'
                                                                              ? Text("Kuwagatatu Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                              : snap.data[i]['jour'].toString() == '5'
                                                                                  ? Text("Kuwakane Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                  : snap.data[i]['jour'].toString() == '6'
                                                                                      ? Text("Kuwagatanu Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                      : Text("Kuwagatandatu Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  snap.data[i]['nom_client'] +
                                                      "  " +
                                                      snap.data[i]
                                                          ['prenom_client'] +
                                                      " Tel:" +
                                                      snap.data[i]
                                                          ['telephone_client'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
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
                                                  snap.data[i]['qte'] +
                                                      "/" +
                                                      snap.data[i]['px'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  snap.data[i]['total'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 30),
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
          ),
          Visibility(
            visible: widget.controled == 0 ? true : false,
            child: StreamBuilder<List>(
                stream: _streamcontroller1.stream,
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
                                    controller: _scrollcontroller1,
                                    physics: BouncingScrollPhysics(),
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
                                                        "stock:" +
                                                            snap.data[i]
                                                                ['q_encien'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : widget.l.eng == 1
                                                        ? Text(
                                                            "stock:" +
                                                                snap.data[i][
                                                                    'q_encien'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        : widget.l.swa == 1
                                                            ? Text(
                                                                "Hisa:" +
                                                                    snap.data[i]
                                                                        [
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
                                                                    snap.data[i]
                                                                        [
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
                                onPressed:
                                    _isontop1 ? _scrolldown1 : _scrolltop1,
                                child: Icon(_isontop1
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
          ),
          Visibility(
              visible: widget.controled == 0 ? true : false,
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 20),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.grey, width: 0),
                                        borderRadius:
                                            BorderRadius.circular(30)),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          widget.l.fra == 1
                                              ? Text(
                                                  "Chercher",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              : widget.l.eng == 1
                                                  ? Text(
                                                      "Search",
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )
                                                  : widget.l.swa == 1
                                                      ? Text(
                                                          "Tafuta",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      : Text(
                                                          "Higa",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.search),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: TextFormField(
                                      enabled: false,
                                      controller: name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                              ? 'Produit'
                                              : widget.l.eng == 1
                                                  ? 'product'
                                                  : widget.l.swa == 1
                                                      ? 'bidhaa'
                                                      : "Igicuruzwa";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        if ((value.isEmpty) ||
                                            (qte.text == "0")) {
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
                                      onChanged: (v) {
                                        try {
                                          setState(() {
                                            total.text =
                                                (double.parse(prix.text) *
                                                        double.parse(v))
                                                    .toString();
                                          });
                                        } catch (e) {
                                          setState(() {
                                            total.text = "";
                                          });
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
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      inputFormatters: [
                                        new FilteringTextInputFormatter.allow(
                                            RegExp("[0-9.]"))
                                      ],
                                      controller: prix,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        if ((value.isEmpty) ||
                                            (prix.text == "0")) {
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
                                                  ? 'remove space'
                                                  : widget.l.swa == 1
                                                      ? 'ambatanisha wingi'
                                                      : 'Fatanya';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (v) {
                                        try {
                                          setState(() {
                                            total.text =
                                                (double.parse(qte.text) *
                                                        double.parse(v))
                                                    .toString();
                                          });
                                        } catch (e) {
                                          setState(() {
                                            total.text = "";
                                          });
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
                                      focusNode: focusnode2,
                                      inputFormatters: [
                                        new FilteringTextInputFormatter.allow(
                                            RegExp("[0-9a-zA-Z.,-/]"))
                                      ],
                                      controller: namecl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLength: 30,
                                      decoration: InputDecoration(
                                          labelText: widget.l.fra == 1
                                              ? "Nom du client"
                                              : widget.l.eng == 1
                                                  ? " His First Name"
                                                  : widget.l.swa == 1
                                                      ? "Jina la Mteja"
                                                      : "Izina ry'umuguzi",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return widget.l.fra == 1
                                              ? 'Entrez Le Nom du client'
                                              : widget.l.eng == 1
                                                  ? 'Enter his First Name'
                                                  : widget.l.swa == 1
                                                      ? 'Andika Jina la Mteja'
                                                      : "Andika Izina ry'umuguzi";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: TextFormField(
                                      focusNode: focusnode3,
                                      inputFormatters: [
                                        new FilteringTextInputFormatter.allow(
                                            RegExp("[0-9a-zA-Z.,-/]"))
                                      ],
                                      controller: prenomcl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLength: 30,
                                      decoration: InputDecoration(
                                          labelText: widget.l.fra == 1
                                              ? "Prenom du client"
                                              : widget.l.eng == 1
                                                  ? " His Last Name"
                                                  : widget.l.swa == 1
                                                      ? "Jina la kwanza la Mteja"
                                                      : "Iritazirano ryiwe",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return widget.l.fra == 1
                                              ? 'Entrez Le Prenom du client'
                                              : widget.l.eng == 1
                                                  ? 'Enter his Last Name'
                                                  : widget.l.swa == 1
                                                      ? 'Andika Jina la kwanza la Mteja'
                                                      : "Andika Iritazirano ry'umuguzi";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: TextFormField(
                                      focusNode: focusnode4,
                                      inputFormatters: [
                                        new FilteringTextInputFormatter.allow(
                                            RegExp("[0-9-+]"))
                                      ],
                                      keyboardType: TextInputType.phone,
                                      controller: telcl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLength: 20,
                                      decoration: InputDecoration(
                                          labelText: widget.l.fra == 1
                                              ? "Son Telephone"
                                              : widget.l.eng == 1
                                                  ? "His Phone number"
                                                  : widget.l.swa == 1
                                                      ? "Nambari ya simu yake"
                                                      : "telephone yiwe",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return widget.l.fra == 1
                                              ? 'Entrez Son Telephone'
                                              : widget.l.eng == 1
                                                  ? 'Enter His Phone number'
                                                  : widget.l.swa == 1
                                                      ? 'Andika Nambari ya simu yake'
                                                      : "Andika Inomero ya telephone yiwe";
                                        }
                                        return null;
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
                                                      : "Yose hamwe",
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
                                      if (_formKey.currentState.validate()) {
                                        dismisskeyboard();
                                        if (widget.duree >= 0) {
                                          if (_formKey.currentState
                                              .validate()) {
                                            if (name.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: widget.l.fra == 1
                                                      ? "chosissez le produit"
                                                      : widget.l.eng == 1
                                                          ? "Choose a product"
                                                          : widget.l.swa == 1
                                                              ? "chagua jina la bidhaa"
                                                              : "Muhitemwo izina",
                                                  backgroundColor: Colors.red,
                                                  gravity: ToastGravity.CENTER,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            } else if (qte.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: widget.l.fra == 1
                                                      ? "Ecrivez la quatité"
                                                      : widget.l.eng == 1
                                                          ? "Write a quantity"
                                                          : widget.l.swa == 1
                                                              ? "Andika kiasi"
                                                              : "Mwandike igitigiri",
                                                  backgroundColor: Colors.red,
                                                  gravity: ToastGravity.CENTER,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            } else if (prix.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: widget.l.fra == 1
                                                      ? "Ecrivez le prix"
                                                      : widget.l.eng == 1
                                                          ? "write a price"
                                                          : widget.l.swa == 1
                                                              ? "andika bei"
                                                              : "andika ikiguzi",
                                                  backgroundColor: Colors.red,
                                                  gravity: ToastGravity.CENTER,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            } else if (namecl.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: widget.l.fra == 1
                                                      ? "Ecrivez son nom"
                                                      : widget.l.eng == 1
                                                          ? "Write his name"
                                                          : widget.l.swa == 1
                                                              ? "Andika jina la mteja"
                                                              : "Mwandike izina ry'umuguzi",
                                                  backgroundColor: Colors.red,
                                                  gravity: ToastGravity.CENTER,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            } else if (prenomcl.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: widget.l.fra == 1
                                                      ? "Ecrivez son prenom"
                                                      : widget.l.eng == 1
                                                          ? "Write his last name"
                                                          : widget.l.swa == 1
                                                              ? "Andika jina lake lapiri"
                                                              : "Mwandike iritazirano ryiwe",
                                                  backgroundColor: Colors.red,
                                                  gravity: ToastGravity.CENTER,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
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
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : widget.l.fra == 1
                                                        ? Text(
                                                            'Accepter',
                                                            style: TextStyle(
                                                                fontSize: 25,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : Text(
                                                            'Emeza',
                                                            style: TextStyle(
                                                                fontSize: 25,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )))),
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
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    showSearch(
                                        context: context,
                                        delegate: DataSearch2(
                                            context,
                                            widget.l,
                                            widget.numero,
                                            widget.worker,
                                            widget.duree,
                                            widget.controled,
                                            widget.isboss,
                                            probleme,
                                            namecl,
                                            prenomcl,
                                            telcl));
                                  },
                                  child: Container(
                                    color: Colors.lightBlueAccent,
                                    alignment: Alignment.center,
                                    child: widget.l.eng == 1
                                        ? Text(
                                            'In detail',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : widget.l.swa == 1
                                            ? Text(
                                                'Kwa Undani',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : widget.l.fra == 1
                                                ? Text(
                                                    'En detail',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    'Raba vyose',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ))
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
                  itemCount: sugest.length,
                  physics: BouncingScrollPhysics(),
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
                                    ? Text("stock:" + sugest[index]['q_encien'],
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white))
                                    : this.l.eng == 1
                                        ? Text(
                                            "stock:" +
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

class DataSearch2 extends SearchDelegate<String> {
  BuildContext context;
  TextEditingController quantite = new TextEditingController();
  TextEditingController namecl;
  TextEditingController prenomcl;
  TextEditingController telcl;
  Langue l;
  var noms;
  String numero;
  int duree;
  int isboss;
  String etat = "0";
  int controled;
  String worker;
  bool visible1 = false;
  DataSearch2(
      this.context,
      this.l,
      this.numero,
      this.worker,
      this.duree,
      this.controled,
      this.isboss,
      this.noms,
      this.namecl,
      this.prenomcl,
      this.telcl);
  messagepayementdette(String name, String nomcl, String prenomcl, String telcl,
      String prix, String resultat) {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: l.fra == 1
          ? Text("Entrer la quantité des produits",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : l.eng == 1
              ? Text("Enter the products quantity",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : l.swa == 1
                  ? Text("Andika Wingi wa bidhaa",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Andika igitigiri c'ibidandazwa",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        Container(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                new FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
              ],
              controller: quantite,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              maxLength: 20,
              decoration: InputDecoration(
                  labelText: l.fra == 1
                      ? "Quantité"
                      : l.eng == 1
                          ? "Quantity"
                          : l.swa == 1
                              ? "Wingi wake"
                              : "Igitigiri",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white)),
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : l.swa == 1
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
              if ((quantite.text.isEmpty) ||
                  (quantite.text.trim().replaceAll(' ', '') == "0")) {
                Fluttertoast.showToast(
                    msg: l.fra == 1
                        ? "Entrez la quantité"
                        : l.eng == 1
                            ? "Enter a quantity"
                            : l.swa == 1
                                ? "Andika wingi wake"
                                : "Andika igitigiri",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.CENTER,
                    toastLength: Toast.LENGTH_LONG);
                return;
              } else if (quantite.text.contains(",") ||
                  quantite.text.contains("-") ||
                  quantite.text.contains(" ")) {
                Fluttertoast.showToast(
                    msg: l.fra == 1
                        ? "Quantité Invalide"
                        : l.eng == 1
                            ? "Invalid quantity "
                            : l.swa == 1
                                ? "Andika wingi vizuri"
                                : "Igitigiri kitarico",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.CENTER,
                    toastLength: Toast.LENGTH_LONG);
                return;
              } else {
                double.parse(quantite.text);
                Navigator.pop(context);
                messagepayementdette2(
                    name, nomcl, prenomcl, telcl, prix, resultat);
              }
            } catch (e) {
              Fluttertoast.showToast(
                  msg: l.fra == 1
                      ? "Corrigez Votre quantité "
                      : l.eng == 1
                          ? "Write well your quantity "
                          : l.swa == 1
                              ? "Andika vizuri Wingi wake "
                              : "Andika neza igitigiri ",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG);
            }
          },
          child: l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : l.swa == 1
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
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alerte;
        });
    //return;
  }

  messagepayementdette2(String name, String nomcl, String prenomcl,
      String telcl, String prix, String resultat) {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: l.fra == 1
          ? Text(
              nomcl +
                  " " +
                  prenomcl +
                  " Veux Payer " +
                  quantite.text +
                  " " +
                  name +
                  " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : l.eng == 1
              ? Text(
                  nomcl +
                      " " +
                      prenomcl +
                      " Wants To Pay " +
                      quantite.text +
                      " " +
                      name +
                      " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : l.swa == 1
                  ? Text(
                      nomcl +
                          " " +
                          prenomcl +
                          " Anataka Kuripa " +
                          name +
                          " " +
                          quantite.text +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      nomcl +
                          " " +
                          prenomcl +
                          " Ashaka Kuriha " +
                          name +
                          " " +
                          quantite.text +
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
          },
          child: l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : l.swa == 1
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
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Payemmentdette(
                      l: this.l,
                      numero: this.numero,
                      name: name,
                      prix: prix,
                      qte: quantite.text.trim().replaceAll(' ', ''),
                      etat: this.etat,
                      nomcl: nomcl,
                      prenomcl: prenomcl,
                      tel: telcl,
                      isboss: this.isboss,
                      worker: this.worker,
                      resultat: resultat,
                    )));
          },
          child: l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : l.swa == 1
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
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alerte;
        });
    //return;
  }

  snackabargood() {
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: l.fra == 1
                ? Text(
                    "Bravo",
                    style: TextStyle(fontSize: 50, color: Colors.green),
                    textAlign: TextAlign.center,
                  )
                : l.eng == 1
                    ? Text(
                        'Done',
                        style: TextStyle(fontSize: 50, color: Colors.green),
                        textAlign: TextAlign.center,
                      )
                    : l.swa == 1
                        ? Text(
                            'Vizuri',
                            style: TextStyle(fontSize: 40, color: Colors.green),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Vyakunze',
                            style: TextStyle(fontSize: 40, color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              Icons.warning,
              color: Colors.green,
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

  paspayemessageechec() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: l.fra == 1
          ? Text("Desolé Il y a un snap.data,Réessayez plus tard",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : l.eng == 1
              ? Text("Sorry We have a problem,Retry Later",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : l.swa == 1
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
          child: l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : l.swa == 1
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

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: l.fra == 1
          ? Text("Votre paquet a expiré Vous Voulez payer encore ?",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : l.eng == 1
              ? Text("Your Paquet has Finished Do you want to pay once again ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : l.swa == 1
                  ? Text("Mfuko wako Umeisha Munataka kulipa tena ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center)
                  : Text(
                      "Umutekero wanyu Waheze ushaka kuriha kandi ?",
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
          child: l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : l.swa == 1
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
                          l: l,
                          numero: numero,
                        )));
          },
          child: l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              color: Colors.green,
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
                element['nom_client']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element['nom_client']
                    .toString()
                    .toUpperCase()
                    .contains(query.toUpperCase()) ||
                element['prenom_client']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element['prenom_client']
                    .toString()
                    .toUpperCase()
                    .contains(query.toUpperCase()) ||
                element['nom']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element['nom']
                    .toString()
                    .toUpperCase()
                    .contains(query.toUpperCase()) ||
                element['dat'].toString().contains(query) ||
                element['telephone_client'].toString().contains(query))
            .toList();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                  itemCount: sugest.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        this.namecl.text = sugest[index]['nom_client'];
                        this.prenomcl.text = sugest[index]['prenom_client'];
                        this.telcl.text = sugest[index]['telephone_client'];
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3),
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
                                subtitle: Column(
                                  children: [
                                    Text(sugest[index]['prenom_client'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 20)),
                                    Text(sugest[index]['nom'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text(
                                        sugest[index]['qte'] +
                                            "/" +
                                            sugest[index]['px'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                    Text(sugest[index]['total'],
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Visibility(
                                        visible: controled == 1 ? false : true,
                                        child: InkWell(
                                            splashColor: Colors.white,
                                            onTap: () {
                                              if (this.duree >= 0) {
                                                messagepayementdette(
                                                    sugest[index]['nom'],
                                                    sugest[index]['nom_client'],
                                                    sugest[index]
                                                        ['prenom_client'],
                                                    sugest[index]
                                                        ['telephone_client'],
                                                    (sugest[index]['px'])
                                                        .toString(),
                                                    (sugest[index]['qte'])
                                                        .toString());
                                              } else {
                                                if (this.duree != -1002) {
                                                  paspayemessage();
                                                } else {
                                                  paspayemessageechec();
                                                }
                                              }
                                            },
                                            child: Card(
                                                color: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.grey,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                child: this.l.fra == 1
                                                    ? Text("Payer",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 30))
                                                    : this.l.eng == 1
                                                        ? Text("Pay",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 30))
                                                        : this.l.swa == 1
                                                            ? Text("Lipisha",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        30))
                                                            : Text("Kurihisha",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight.bold,
                                                                    fontSize: 30)))),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    Text(sugest[index]['dat'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text(sugest[index]['telephone_client'],
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                                title: RichText(
                                  text: TextSpan(
                                      text: sugest[index]['nom_client']
                                              .toString()
                                              .contains(query)
                                          ? sugest[index]['nom_client']
                                              .substring(0, query.length)
                                          : sugest[index]['nom_client']
                                                  .toString()
                                                  .contains(query.toUpperCase())
                                              ? sugest[index]['nom_client']
                                                  .substring(0, query.length)
                                              : sugest[index]['telephone_client']
                                                      .toString()
                                                      .contains(query)
                                                  ? sugest[index]['telephone_client']
                                                      .substring(
                                                          0, query.length)
                                                  : sugest[index]['dat']
                                                          .toString()
                                                          .contains(query)
                                                      ? sugest[index]['dat'].substring(
                                                          0, query.length)
                                                      : sugest[index]['prenom_client']
                                                              .toString()
                                                              .contains(query)
                                                          ? sugest[index]['prenom_client'].substring(0, query.length)
                                                          : sugest[index]['prenom_client'].toString().contains(query.toUpperCase())
                                                              ? sugest[index]['prenom_client'].substring(0, query.length)
                                                              : sugest[index]['nom'].toString().contains(query)
                                                                  ? sugest[index]['nom'].substring(0, query.length)
                                                                  : sugest[index]['nom'].toString().contains(query.toUpperCase())
                                                                      ? sugest[index]['nom'].substring(0, query.length)
                                                                      : sugest[index]['nom_client'].substring(0, query.length),
                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30),
                                      children: [
                                        TextSpan(
                                            text: sugest[index]['nom_client']
                                                    .toString()
                                                    .contains(query)
                                                ? sugest[index]['nom_client']
                                                    .substring(query.length)
                                                : sugest[index]['nom_client']
                                                        .toString()
                                                        .contains(
                                                            query.toUpperCase())
                                                    ? sugest[index]
                                                            ['nom_client']
                                                        .substring(query.length)
                                                    : sugest[index]['telephone_client']
                                                            .toString()
                                                            .contains(query)
                                                        ? sugest[index]['telephone_client']
                                                            .substring(
                                                                query.length)
                                                        : sugest[index]['dat']
                                                                .toString()
                                                                .contains(query)
                                                            ? sugest[index]
                                                                    ['dat']
                                                                .substring(query.length)
                                                            : sugest[index]['prenom_client'].toString().contains(query)
                                                                ? sugest[index]['prenom_client'].substring(query.length)
                                                                : sugest[index]['prenom_client'].toString().contains(query.toUpperCase())
                                                                    ? sugest[index]['prenom_client'].substring(query.length)
                                                                    : sugest[index]['nom'].toString().contains(query)
                                                                        ? sugest[index]['nom'].substring(query.length)
                                                                        : sugest[index]['nom'].toString().contains(query.toUpperCase())
                                                                            ? sugest[index]['nom'].substring(query.length)
                                                                            : sugest[index]['nom_client'].substring(query.length),
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30)),
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
