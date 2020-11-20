import 'dart:math';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
class Changer extends StatefulWidget {
  final Langue l;
  final String nro;
  final String nrow;
  Changer({Key key, this.l, this.nro, this.nrow}) : super(key: key);

  @override
  _ChangerState createState() => _ChangerState();
}

class _ChangerState extends State<Changer> {
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
                            nro: widget.nro,
                            nrow: widget.nrow,
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
  final String nro;
  final String nrow;
  Myform({Key key, this.l, this.nro, this.nrow}) : super(key: key);

  @override
  _MyformState createState() => _MyformState();
}

class _MyformState extends State<Myform> {
  TextEditingController newp = new TextEditingController();
  TextEditingController confp = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isobscure = true;
   FocusNode focusnode;
    FocusNode focusnode1;
   @override
  void initState() {
   focusnode=FocusNode();
    focusnode1=FocusNode();
    focusnode.addListener(() { });
    focusnode1.addListener(() { });
    super.initState();
  }
     dismisskeyboard(){
  focusnode.unfocus();
   focusnode1.unfocus();
}
  @override
  void dispose() {
focusnode.dispose();
focusnode1.dispose();
    newp.dispose();
    confp.dispose();
    super.dispose();
  }

  crypterchaine(String pass) {
    String chaine = "abcdefghi0123456789jklmnopkrstuvwxyz.";
    String c;
    String t = "";
    String b = pass;
    for (int i = 0; i < b.length; i++) {
      if (chaine.contains(b[i])) {
        c = (pow(chaine.indexOf(b[i]), 4) + (731)).toString();
      } else {
        try {
          c = chaine[int.parse(b[i])];
        } catch (e) {
          c = b[i];
        }
      }
      if (t == "") {
        t = c;
      } else {
        t += "." + c;
      }
    }
    return t;
  }

  testPass() {
    //on test si le password contient le chiffres et les lettres
    String al = "abcdefghijklmnopkrstuvwyxz";
    String nu = "1234567890";
    int i = 0;
    int j = 0;
    int t = 0;
    int t1 = 0;

    while (i < newp.text.length && t == 0) {
      if (al.contains(newp.text[i])) {
        t += 1;
      }

      i++;
    }
    while (j < newp.text.length && t1 == 0) {
      if (nu.contains(newp.text[j])) {
        t1 += 1;
      }

      j++;
    }

    if (t > 0 && t1 > 0) {
      return (t + t1);
    } else {
      return 0;
    }
  }

  bool ispop = true;
  bool visible1 = false;
  updateworkerpassBoss(){
    setState(() {
      ispop = false;
      visible1 = true;
    });
    try {
      if ((testPass()>0)&&(newp.text.length>=6)) {
     http.post(
            "https://kakwetuburundifafanini.com/update/updateworkerpassBoss.php",
            body: {
              "etat":"changed",
              "nro": widget.nro,
              "nro_w": widget.nrow,
              "pd": crypterchaine(newp.text.trim().replaceAll(' ', '')),
            }).then((value){
              if(value.statusCode==200){
                 setState(() {
            ispop = true;
            visible1 = false;
            Fluttertoast.showToast(
                msg: widget.l.fra == 1
                    ? "Bien Fait"
                    : widget.l.eng == 1
                        ? "Well Done"
                        : widget.l.swa == 1
                            ? "Umeweza"
                            : "Vyakunze",
                backgroundColor: Colors.black,
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
            Navigator.pop(context);
          });
              }else{
setState(() {
          ispop = true;
          visible1 = false;
          Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Echec"
                  : widget.l.eng == 1
                      ? "Failure"
                      : widget.l.swa == 1
                          ? "Binakatala"
                          : "Vyase",
              backgroundColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        });
              }
            });
          setState(() {
         newp.text="";
         confp.text="";
        });
      } else {
        setState(() {
          ispop = true;
          visible1 = false;
          Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Echec"
                  : widget.l.eng == 1
                      ? "Failure"
                      : widget.l.swa == 1
                          ? "Binakatala"
                          : "Vyase",
              backgroundColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        });
      }
    } catch (e) {
      setState(() {
        ispop = true;
        visible1 = false;
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Echec"
                : widget.l.eng == 1
                    ? "Failure"
                    : widget.l.swa == 1
                        ? "Binakatala"
                        : "Vyase",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => ispop,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: 400,
                child: Card(
                  elevation: 0,
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.lightBlue, width: 5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        widget.l.fra == 1
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Changement de ton Travailleur",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : widget.l.eng == 1
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Changing Of your Worker",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : widget.l.swa == 1
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Kubadilisha Mtumishi wako",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Guhindura Umukozi Wawe",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              focusNode: focusnode,
                              inputFormatters: [
                                    new FilteringTextInputFormatter.deny(RegExp("[#*'\"/&();=|@]"))
                                                                 ],
                              controller: newp,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              obscureText: isobscure,
                              textAlign: TextAlign.center,
                              maxLength: 15,
                              decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      if (isobscure) {
                                        setState(() {
                                          isobscure = false;
                                        });
                                      } else {
                                        setState(() {
                                          isobscure = true;
                                        });
                                      }
                                    },
                                    child: Icon(
                                        isobscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white),
                                  ),
                                  labelText: widget.l.fra == 1
                                      ? "Nouveau Mot de Passe"
                                      : widget.l.eng == 1
                                          ? "New PassWord"
                                          : widget.l.swa == 1
                                              ? "nenosiri la mpya"
                                              : "Ijambo Kabanga rishasha",
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return widget.l.fra == 1
                                      ? 'Entrez Le Nouveau Mot de Passe'
                                      : widget.l.eng == 1
                                          ? 'Enter A new PassWord'
                                          : widget.l.swa == 1
                                              ? 'Ingiza Neno La Kificho La mpya'
                                              : 'Shiramwo Ijambo Kabanga rishasha';
                                } else if (testPass() == 0) {
                                  return widget.l.fra == 1
                                      ? 'Melangez les chiffres et les Lettres'
                                      : widget.l.eng == 1
                                          ? 'Mix digit and letters'
                                          : widget.l.swa == 1
                                              ? 'changanya takwimu na herufi'
                                              : "Teranya Ibiharuro N'idome";
                                } else if (newp.text.length < 6) {
                                  return widget.l.fra == 1
                                      ? 'aumoins 6 caracteres'
                                      : widget.l.eng == 1
                                          ? 'at least 6 characters'
                                          : widget.l.swa == 1
                                              ? 'Siyo chini ya 6'
                                              : 'Ako nigato,vyopfuma 6';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            focusNode: focusnode1,
                            inputFormatters: [
                                    new FilteringTextInputFormatter.deny(RegExp("[#*'\"/&();=|@]"))
                                                                 ],
                            controller: confp,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            obscureText: true,
                            textAlign: TextAlign.center,
                            maxLength: 15,
                            decoration: InputDecoration(
                                labelText: widget.l.fra == 1
                                    ? "Cofirmez"
                                    : widget.l.eng == 1
                                        ? "Conform"
                                        : widget.l.swa == 1
                                            ? "Thibitisha"
                                            : "Subiramwo",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Cofirmez Le Mot de passe'
                                    : widget.l.eng == 1
                                        ? 'Conform PassWord'
                                        : widget.l.swa == 1
                                            ? 'Thibitisha nenosiri'
                                            : 'Subiramwo Ijambo Kabanga';
                              } else if (confp.text != newp.text) {
                                return widget.l.fra == 1
                                    ? 'Cofirmez Bien'
                                    : widget.l.eng == 1
                                        ? 'Conform Well'
                                        : widget.l.swa == 1
                                            ? 'Thibitisha Vizuri'
                                            : 'Subiramwo Neza';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor:Colors.white,
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              dismisskeyboard();
                              updateworkerpassBoss();
                            }
                          },
                          child: Container(
                            width: 250,
                            height: 40,
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
                                            fontWeight: FontWeight.bold),
                                      )
                                    : widget.l.fra == 1
                                        ? Text(
                                            'Accepter',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'Emeza',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
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
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              ))),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(3),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black26, width: 5),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  widget.l.fra == 1
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Pour se connecter Le Nouveau Travaileur va utiliser le Numero de l'encien travaileur et le Nouveau mot de passe",
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
                                                "A new worker uses the number of old worker and a new password to connect himself",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : widget.l.swa == 1
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Mtumishi Wampya anatumia Kwakuingiya Nambari ya mtumishi wa zamani pamoja na nenosiri hili ya mpya",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Mukwinjira Umukozi Mushasha azokoresha Inomero y'uwahahora hamwe n'ijambo kabanga rishasha mumuhaye",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                      ])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
