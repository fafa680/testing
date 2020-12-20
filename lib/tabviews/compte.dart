import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'package:kakwetu/servicepayement.dart';
import 'package:flutter/services.dart';

class Compte extends StatefulWidget {
  final Langue l;
  final int isboss;
  final String numero;
  final int duree;
  Compte({Key key, this.l, this.isboss, this.numero, this.duree})
      : super(key: key);
  @override
  _CompteState createState() => _CompteState();
}

class _CompteState extends State<Compte> {
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
                            isboss: widget.isboss,
                            numero: widget.numero,
                            duree: widget.duree,
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
  final int isboss;
  final String numero;
  final int duree;
  Myform({Key key, this.l, this.isboss, this.numero, this.duree})
      : super(key: key);

  @override
  _MyformState createState() => _MyformState();
}

class _MyformState extends State<Myform> {
  TextEditingController pass = new TextEditingController();
  TextEditingController nom = new TextEditingController();
  TextEditingController prenom = new TextEditingController();
  TextEditingController newp = new TextEditingController();
  TextEditingController confp = new TextEditingController();
  bool isobscure = true;
  FocusNode focusnode;
  FocusNode focusnode1;
  FocusNode focusnode2;
  FocusNode focusnode3;
  FocusNode focusnode4;
  @override
  void initState() {
    getId();
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
    newp.dispose();
    confp.dispose();
    pass.dispose();
    nom.dispose();
    prenom.dispose();
    super.dispose();
  }

  bool visble1 = true;
  bool visble2 = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
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

  String idphone = "";
  getId() async {
    var deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        setState(() {
          idphone = iosDeviceInfo.identifierForVendor;
        });
      } else {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        setState(() {
          idphone = androidDeviceInfo.androidId;
        });
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  updateworkerpass() {
    try {
      if ((testPass() > 0) &&
          (newp.text.length >= 6) &&
          nom.text.isNotEmpty &&
          prenom.text.isNotEmpty) {
        http.post(
            "https://kakwetuburundifafanini.com/update/updatechangeallworker.php",
            body: {
              "nro_w": widget.numero,
              "pd": crypterchaine(newp.text.trim().replaceAll(' ', '')),
              "nom_w": nom.text.trim().replaceAll(' ', ''),
              "prenom_w": prenom.text.trim().replaceAll(' ', ''),
              "etat": "",
              "tid": idphone
            }).then((value) {
          if (value.statusCode == 200) {
            setState(() {
              visible2 = false;
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
          } else {
            setState(() {
              visible2 = false;
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
            });
          }
        });
        setState(() {
          newp.text = "";
          nom.text = "";
          prenom.text = "";
          confp.text = "";
        });
      } else {
        setState(() {
          visible2 = false;
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
        });
      }
    } catch (e) {
      setState(() {
        visible2 = false;
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
      });
      return;
    }
  }

  static _isolate1(String body) {
    return jsonDecode(body);
  }

  updatebosspass() {
    try {
      if ((testPass() > 0) && (newp.text.length >= 6)) {
        http.post(
            "https://kakwetuburundifafanini.com/update/updatebosspass.php",
            body: {
              "nro": widget.numero,
              "pd": crypterchaine(newp.text.trim().replaceAll(' ', '')),
              "tid": idphone
            }).then((value) {
          if (value.statusCode == 200) {
            setState(() {
              visible2 = false;
              Navigator.pop(context);
              Navigator.pop(context);
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
            });
          } else {
            setState(() {
              visible2 = false;
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
            });
          }
        });
        setState(() {
          newp.text = "";
          confp.text = "";
        });
      } else {
        setState(() {
          visible2 = false;
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
        });
      }
    } catch (e) {
      setState(() {
        visible2 = false;
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
      });
      return;
    }
  }

  changepassworker() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginworkerentrer.php",
          body: {
            "nro_w": widget.numero,
            "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          });
      var resultat = await compute(_isolate1, response.body);
      if (resultat.length == 0 && response.statusCode == 200) {
        setState(() {
          visible1 = false;
          Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Mot de passe Inconnu"
                  : widget.l.eng == 1
                      ? "Uknown Password"
                      : widget.l.swa == 1
                          ? "Hiri Nenosiri Harijulikani"
                          : "Irijambo kabanga Siryo",
              backgroundColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        });
      } else {
        setState(() {
          visble1 = false;
          visible1 = false;
          visble2 = true;
        });
      }
    } catch (e) {
      setState(() {
        visible1 = false;
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Echec,Réessayer"
                : widget.l.eng == 1
                    ? "Failed,Retry"
                    : widget.l.swa == 1
                        ? "Bimekatala"
                        : "Ntivyakunze komuhindura",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      });
    }
  }

  changepassboss() async {
    setState(() {
      visble1 = true;
    });
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginbosschangepd.php",
          body: {
            "nro": widget.numero,
            "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          });
      var resultat = await compute(_isolate1, response.body);
      if (resultat.length == 0 && response.statusCode == 200) {
        changepassworker();
      } else {
        setState(() {
          visble1 = false;
          visble2 = true;
          visible1 = false;
        });
      }
    } catch (e) {
      setState(() {
        visible1 = false;
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Echec,Réessayer"
                : widget.l.eng == 1
                    ? "Failed,Retry"
                    : widget.l.swa == 1
                        ? "Bimekatala"
                        : "Ntivyakunze komuhindura",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      });
    }
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

  bool visible2 = false;
  changepassworker2() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginworkerentrer.php",
          body: {
            "nro_w": widget.numero,
            "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          });
      var resultat = await compute(_isolate1, response.body);
      if (resultat.length == 0 && response.statusCode == 200) {
        setState(() {
          visible2 = false;
          Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Echec,Réessayer"
                  : widget.l.eng == 1
                      ? "Failed,Retry"
                      : widget.l.swa == 1
                          ? "Bimekatala"
                          : "Ntivyakunze komuhindura",
              backgroundColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        });
      } else {
        updateworkerpass();
      }
    } catch (e) {
      setState(() {
        visible2 = false;
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
      });
    }
  }

  changepassboss2() async {
    setState(() {
      visible2 = true;
    });
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginbosschangepd.php",
          body: {
            "nro": widget.numero,
            "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          });
      var resultat = await compute(_isolate1, response.body);
      if (resultat.length == 0 && response.statusCode == 200) {
        changepassworker2();
      } else {
        updatebosspass();
      }
    } catch (e) {
      setState(() {
        visible2 = false;
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
      });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Visibility(
            visible: visble1,
            child: Padding(
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
                      key: _formKey1,
                      child: Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15),
                          child: TextFormField(
                            enableInteractiveSelection: false,
                            focusNode: focusnode,
                            inputFormatters: [
                              new FilteringTextInputFormatter.deny(
                                  RegExp("[#*'\"/&();=|@]"))
                            ],
                            controller: pass,
                            obscureText: isobscure,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                                    ? "Mot de Passe"
                                    : widget.l.eng == 1
                                        ? "PassWord"
                                        : widget.l.swa == 1
                                            ? "nenosiri"
                                            : "Ijambo Kabanga",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Entrez Votre Mot de Passe'
                                    : widget.l.eng == 1
                                        ? 'Enter Your PassWord'
                                        : widget.l.swa == 1
                                            ? 'Ingiza nenosiri'
                                            : 'Shiramwo Ijambo Kabanga';
                              }

                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            if (widget.duree >= 0) {
                              if (_formKey1.currentState.validate()) {
                                dismisskeyboard();
                                getId();
                                setState(() {
                                  visible1 = true;
                                });
                                changepassboss();
                              }
                            } else {
                              if (widget.duree != -1002) {
                                paspayemessage();
                              } else {
                                paspayemessageechec();
                              }
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
                      ])),
                ),
              ),
            ),
          ),
          Visibility(
            visible: visble2,
            child: Padding(
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
                        Visibility(
                          visible: widget.isboss == 1 ? false : visble2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30.0, top: 15),
                            child: TextFormField(
                              focusNode: focusnode1,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Z.,-/]"))
                              ],
                              controller: nom,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLength: 30,
                              decoration: InputDecoration(
                                  labelText: widget.l.fra == 1
                                      ? "Nom"
                                      : widget.l.eng == 1
                                          ? "First Name"
                                          : widget.l.swa == 1
                                              ? "Jina la Kwanza"
                                              : "Izina ry'Ikirundi",
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return widget.l.fra == 1
                                      ? 'Entrez Votre Nom'
                                      : widget.l.eng == 1
                                          ? 'Enter your first Name'
                                          : widget.l.swa == 1
                                              ? 'Ingiza jina lakwanza'
                                              : 'andika Izina';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.isboss == 1 ? false : visble2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30.0, top: 15),
                            child: TextFormField(
                              focusNode: focusnode2,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Z.,-/]"))
                              ],
                              controller: prenom,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLength: 30,
                              decoration: InputDecoration(
                                  labelText: widget.l.fra == 1
                                      ? "Prenom"
                                      : widget.l.eng == 1
                                          ? "Last Name"
                                          : widget.l.swa == 1
                                              ? "Jina la Mwisho"
                                              : "Iritazirano",
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return widget.l.fra == 1
                                      ? 'Entrez Votre prenom'
                                      : widget.l.eng == 1
                                          ? 'Enter your last Name'
                                          : widget.l.swa == 1
                                              ? 'Ingiza jina lapili'
                                              : 'Injiza Iritazirano';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              enableInteractiveSelection: false,
                              focusNode: focusnode3,
                              inputFormatters: [
                                new FilteringTextInputFormatter.deny(
                                    RegExp("[#*'\"/&();=|@]"))
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
                                              ? 'Ingiza nenosiri La mpya'
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
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              enableInteractiveSelection: false,
                              focusNode: focusnode4,
                              inputFormatters: [
                                new FilteringTextInputFormatter.deny(
                                    RegExp("[#*'\"/&();=|@]"))
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
                                      ? "Cofirmer"
                                      : widget.l.eng == 1
                                          ? "Conform"
                                          : widget.l.swa == 1
                                              ? "Thibitisha"
                                              : "Risubiremwo",
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
                                } else if (newp.text != confp.text) {
                                  return widget.l.fra == 1
                                      ? 'Cofirmez bien'
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              dismisskeyboard();
                              changepassboss2();
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
                              visible: visible2,
                              child: Center(
                                  child: LinearProgressIndicator(
                                backgroundColor: Colors.cyanAccent,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              ))),
                        ),
                      ])),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
