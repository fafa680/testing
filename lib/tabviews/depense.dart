import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../servicepayement.dart';

class Depense extends StatefulWidget {
  final Langue l;
  final int isboss;
  final int controled;
  final String numero;
  final String password;
  final int duree;
  final String worker;
  Depense(
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
  _DepenseState createState() => _DepenseState();
}

class _DepenseState extends State<Depense> {
  TextEditingController nom = new TextEditingController();
  TextEditingController montant = new TextEditingController();
  StreamController<List> _streamcontroller1 = StreamController<List>();
  ScrollController _scrollcontroller = new ScrollController();
  bool ispop = true;
  FocusNode focusnode;
  FocusNode focusnode1;
  @override
  void initState() {
    focusnode = FocusNode();
    focusnode1 = FocusNode();
    focusnode.addListener(() {});
    focusnode1.addListener(() {});
    selectdepense();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      selectdepense();
    });
    super.initState();
  }

  dismisskeyboard() {
    focusnode.unfocus();
    focusnode1.unfocus();
  }

  @override
  void dispose() {
    focusnode.dispose();
    focusnode1.dispose();
    _scrollcontroller.dispose();
    _streamcontroller1.close();
    nom.dispose();
    montant.dispose();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  bool update = true;
  final _formKey = GlobalKey<FormState>();
  Timer _timer;
  static _isolate(String body) {
    return jsonDecode(body);
  }

  selectdepense() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selectdepense.php",
          body: {
            "nro": widget.numero,
          });
      var resultat = await compute(_isolate, response.body);
      setState(() {
        _streamcontroller1.add(resultat);
      });
    } catch (e) {}
  }

  adddepense() {
    setState(() {
      visible1 = true;
    });
    try {
      if (nom.text.isNotEmpty && (double.parse(montant.text) > 0)) {
        http.post("https://kakwetuburundifafanini.com/add/adddepense.php",
            body: {
              "sorte": nom.text.trim().replaceAll(' ', ''),
              "nro": widget.numero,
              "sme": montant.text.trim().replaceAll(' ', ''),
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
            selectdepense();
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
          nom.text = "";
          montant.text = "";
          visible1 = false;
          ispop = true;
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

  bool visible1 = false;
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

  void messagevalidation() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text(
              "Vous Voulez Enregstrer " +
                  montant.text +
                  " Comme depense de " +
                  nom.text +
                  " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text(
                  "Do you want Register " +
                      montant.text +
                      " as spending of " +
                      nom.text +
                      " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text(
                      "Unataka kuingiza " +
                          montant.text +
                          " kama Matumizi ya " +
                          nom.text +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka Kwinjiza " +
                          montant.text +
                          " Nk'ivyakoreshejwe mu " +
                          nom.text +
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
              nom.text = "";
              montant.text = "";
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
              if (double.parse(montant.text.trim()) > 0) {
                Navigator.pop(context);
                if (widget.isboss == 0) {
                  if (widget.worker == "y") {
                    adddepense();
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
                  adddepense();
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
                                  controller: _scrollcontroller,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snap.data.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
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
                                                                    ['dat'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white))
                                                        : snap.data[i]['jour']
                                                                    .toString() ==
                                                                '2'
                                                            ? Text("Lundi le " + snap.data[i]['dat'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight.bold,
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
                                                snap.data[i]['sorte'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                snap.data[i]['sme'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )),
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
                              Container(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                    focusNode: focusnode1,
                                    inputFormatters: [
                                      new FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-Z.,-/]"))
                                    ],
                                    controller: nom,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    maxLength: 30,
                                    decoration: InputDecoration(
                                        labelText: widget.l.fra == 1
                                            ? "Nom du depense"
                                            : widget.l.eng == 1
                                                ? "Spent name"
                                                : widget.l.swa == 1
                                                    ? "Jina la matumizi"
                                                    : "Ico wayakoresheje",
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return widget.l.fra == 1
                                            ? 'Entrer Le Nom du depense'
                                            : widget.l.eng == 1
                                                ? 'Enter Spent name'
                                                : widget.l.swa == 1
                                                    ? 'Andika Jina la matumizi'
                                                    : "Andika Ico wayakoresheje";
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
                                    controller: montant,
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
                                            ? "Montant"
                                            : widget.l.eng == 1
                                                ? "Amount"
                                                : widget.l.swa == 1
                                                    ? "Kiasi"
                                                    : "Ukwo angana",
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    validator: (value) {
                                      if ((value.isEmpty) ||
                                          (montant.text == "0")) {
                                        return widget.l.fra == 1
                                            ? 'Entrer le Montant'
                                            : widget.l.eng == 1
                                                ? 'Enter an Amount'
                                                : widget.l.swa == 1
                                                    ? 'Andika Kiasi'
                                                    : "Andika Ukwo angana";
                                      } else if (montant.text.contains(",")) {
                                        return widget.l.fra == 1
                                            ? 'Utilisez .'
                                            : widget.l.eng == 1
                                                ? 'Use .'
                                                : widget.l.swa == 1
                                                    ? 'Tumiya .'
                                                    : 'Koresha .';
                                      } else if (montant.text.contains("-")) {
                                        return widget.l.fra == 1
                                            ? 'Enlevez -'
                                            : widget.l.eng == 1
                                                ? 'remove -'
                                                : widget.l.swa == 1
                                                    ? 'tosha -'
                                                    : 'kuramwo -';
                                      } else if (montant.text.contains(" ")) {
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
                              InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    dismisskeyboard();
                                    if (widget.duree >= 0) {
                                      if (nom.text.isEmpty) {
                                        return;
                                      } else if (montant.text.isEmpty) {
                                        return;
                                      } else {
                                        messagevalidation();
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
                                                  ),
                                  ),
                                ),
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
