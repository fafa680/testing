import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'ajouter1.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
class Ajouter extends StatefulWidget {
  final Langue l;
  final String numero;
  Ajouter({Key key, this.l, this.numero}) : super(key: key);
  @override
  _AjouterState createState() => _AjouterState();
}

class _AjouterState extends State<Ajouter> {
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
  Myform({Key key, this.l, this.numero}) : super(key: key);

  @override
  _MyformState createState() => _MyformState();
}

class _MyformState extends State<Myform> {
  TextEditingController pass = new TextEditingController();
  TextEditingController nom = new TextEditingController();
  TextEditingController prenom = new TextEditingController();
  TextEditingController drop = new TextEditingController();
  TextEditingController passconf = new TextEditingController();
  List<String> pays = [];
  final _formKey = GlobalKey<FormState>();
  bool isobscure = true;
  String etat = "";
  String hisnumber = "";
  String pass1 = "";
  String nom1 = "";
  String prenom1 = "";
  String pay1 = "";
  StreamController<List> _streamcontroller = StreamController<List>();
  FocusNode focusnode;
  FocusNode focusnode1;
  FocusNode focusnode2;
  FocusNode focusnode3;
   @override
  void initState() {
    selectpays();
    getId();
     focusnode = FocusNode();
    focusnode1 = FocusNode();
    focusnode2 = FocusNode();
    focusnode3 = FocusNode();
    focusnode.addListener(() {});
    focusnode1.addListener(() {});
    focusnode2.addListener(() {});
    focusnode3.addListener(() {});
    super.initState();
  }
   dismisskeyboard() {
    focusnode.unfocus();
    focusnode1.unfocus();
    focusnode2.unfocus();
    focusnode3.unfocus();
  }
  @override
  void dispose() {
    focusnode1.dispose();
    focusnode.dispose();
    focusnode2.dispose();
    focusnode3.dispose();
    passconf.dispose();
    _streamcontroller.close();
    pass.dispose();
    nom.dispose();
    prenom.dispose();
    drop.dispose();
    pays.clear();
    super.dispose();
  }
    String idphone="";
getId() async{
  var deviceInfo=DeviceInfoPlugin();
  try{
if(Platform.isIOS){
 var iosDeviceInfo = await deviceInfo.iosInfo;
  setState(() {
    idphone=iosDeviceInfo.identifierForVendor;
  });
}else{
  var androidDeviceInfo = await deviceInfo.androidInfo;
  setState(() {
    idphone=androidDeviceInfo.androidId;
  });
}
  }catch(e){
Navigator.pop(context);
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

    while (i < pass.text.length && t == 0) {
      if (al.contains(pass.text[i])) {
        t += 1;
      }

      i++;
    }
    while (j < pass.text.length && t1 == 0) {
      if (nu.contains(pass.text[j])) {
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

  snackabardropimpty() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: widget.l.fra == 1
                ? Text(
                    'Le Pays',
                    style: TextStyle(fontSize: 50, color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : widget.l.eng == 1
                    ? Text(
                        'Country',
                        style: TextStyle(fontSize: 50, color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : widget.l.swa == 1
                        ? Text(
                            'Nchi',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Igihugu',
                            style: TextStyle(fontSize: 40, color: Colors.red),
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
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  snackabarfaux() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: widget.l.fra == 1
                ? Text(
                    'Reessayez',
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
                            'Rudiyaemwo',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Subiramwo',
                            style: TextStyle(fontSize: 40, color: Colors.red),
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
static _isolate(String body){
return jsonDecode(body);
  }
  bool visible1 = false;
  insertworker(){
    setState(() {
     visible1=true;
       });
    var url = "https://kakwetuburundifafanini.com/insert/insertw_c.php";
    try {
      if(nom.text.isNotEmpty&&prenom.text.isNotEmpty&&(testPass()>0)&&(pass.text.length>=6)&&pay1!=""){
http.post(url, body: {
        "etat": etat,
        "nom_w": nom.text.trim().replaceAll(' ', ''),
        "nro": widget.numero,
        "nro_w": hisnumber,
        "pd":crypterchaine(pass.text.trim().replaceAll(' ', '')),
        "prenom_w": prenom.text.trim().replaceAll(' ', ''),
        "tid":idphone
      }).then((value){
        if(value.statusCode==200){
           Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Ajouter1(
                    l: widget.l,
                    nom: nom1,
                    prenom: prenom1,
                    pass: pass1,
                    nro: widget.numero,
                    pays: pay1,
                    idphone: idphone,
                  )));
                  setState(() {
              visible1 = false;
            });
                 }else{
            setState(() {
              Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Operation Echouée"
                : widget.l.eng == 1
                    ? "Failed"
                    : widget.l.swa == 1 ? "Bimekatala" : "Ntivyakunze",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
            visible1 = false;
            });
        }
      });
       setState(() {
        nom1 = nom.text.trim().replaceAll(' ', '');
        prenom1 = prenom.text.trim().replaceAll(' ', '');
        pass1 =crypterchaine(pass.text.trim().replaceAll(' ', ''));
        nom.text = "";
        pass.text = "";
        prenom.text = "";
        drop.text = "";
        passconf.text="";
      });
      }else{
       setState(() {
              Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Operation Echouée"
                : widget.l.eng == 1
                    ? "Failed"
                    : widget.l.swa == 1 ? "Bimekatala" : "Ntivyakunze",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
            visible1 = false;
            });
      } 
    } catch (e) {
     setState(() {
              Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Operation Echouée"
                : widget.l.eng == 1
                    ? "Failed"
                    : widget.l.swa == 1 ? "Bimekatala" : "Ntivyakunze",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
            visible1 = false;
            });
      return;
    }
  }
  selectpays() async {
    try {
      final response = await http
          .get("https://kakwetuburundifafanini.com/pays/selectpays.php");
          var resultat=await compute(_isolate,response.body);
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
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
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15),
                          child: TextFormField(
                            focusNode: focusnode,
                            inputFormatters: [
                                    new FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z.-/]"))
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
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Entrez Son Nom'
                                    : widget.l.eng == 1
                                        ? 'Enter His First Name'
                                        : widget.l.swa == 1
                                            ? 'Ingiza Jina Lake La Kwanza Lako'
                                            : "Shiramwo Izina ryiwe ry'Ikirundi";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15),
                          child: TextFormField(
                            focusNode: focusnode1,
                            inputFormatters: [
                                    new FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z.-/]"))
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
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Entrez Son Prenom'
                                    : widget.l.eng == 1
                                        ? 'Enter His Last Name'
                                        : widget.l.swa == 1
                                            ? 'Ingiza Jina Lake La Misho'
                                            : "Shiramwo Izina ryiwe ry'Iritazirano";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: TextFormField(
                            focusNode: focusnode2,
                           inputFormatters: [
                                    new FilteringTextInputFormatter.deny(RegExp("[#*'\"/&();=|@]"))
                                                                 ],
                            controller: pass,
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
                                    ? "Mot de Passe"
                                    : widget.l.eng == 1
                                        ? "PassWord"
                                        : widget.l.swa == 1
                                            ? "nenosiri"
                                            : "Kabanga",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Entrez Son Mot de Passe'
                                    : widget.l.eng == 1
                                        ? 'Enter His PassWord'
                                        : widget.l.swa == 1
                                            ? 'Ingiza nenosiri Lake'
                                            : 'Shiramwo Ijambo Kabanga ryiwe';
                              } else if (testPass() == 0) {
                                return widget.l.fra == 1
                                    ? 'Melangez les chiffres et les Lettres'
                                    : widget.l.eng == 1
                                        ? 'Mix digit and letters'
                                        : widget.l.swa == 1
                                            ? 'changanya takwimu na herufi'
                                            : "Teranya Ibiharuro N'idome";
                              } else if(pass.text.length<6){
                                return widget.l.fra == 1
                                    ? 'aumoins 6 caracteres'
                                    : widget.l.eng == 1
                                        ? 'at least 6 characters'
                                        : widget.l.swa == 1
                                            ? 'Siyo chini ya 6'
                                            : 'Ako nigato,vyopfuma 6';
                              }else{
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: TextFormField(
                            focusNode: focusnode3,
                            inputFormatters: [
                                    new FilteringTextInputFormatter.deny(RegExp("[#*'\"/&();=|@]"))
                                                                 ],
                            controller: passconf,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            obscureText: true,
                            textAlign: TextAlign.center,
                            maxLength: 15,
                            decoration: InputDecoration(
                                labelText: widget.l.fra == 1
                                    ? "Confirmez"
                                    : widget.l.eng == 1
                                        ? "Confirm"
                                        : widget.l.swa == 1
                                            ? "Thibitisha"
                                            : "Subiramwo",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Confirmez son Mot de passe'
                                    : widget.l.eng == 1
                                        ? 'Confirm His PassWord'
                                        : widget.l.swa == 1
                                            ? 'Thibitisha nenosiri Lake'
                                            : 'Subiramwo Ijambo Kabanga ryiwe';
                              } else if (pass.text != passconf.text) {
                                return widget.l.fra == 1
                                    ? 'Confirmez Bien'
                                    : widget.l.eng == 1
                                        ? 'Confirm well'
                                        : widget.l.swa == 1
                                            ? 'Thibitisha vizuri'
                                            : "Mwihenze Gusubiramwo";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        StreamBuilder<List>(
                            stream: _streamcontroller.stream,
                            builder: (context, snap) {
                              if (snap.hasError) {
                                return null;
                              } else if (snap.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Card(
                                    color: Colors.amber,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.lightBlue, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: DropDownField(
                                      inputFormatters: [
                                    new FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z.-/]"))
                                                                 ],
                                      onValueChanged: (v) {
                                        setState(() {
                                          pay1 = v;
                                        });
                                      },
                                      controller: drop,
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      labelText: widget.l.fra == 1
                                          ? "Pays"
                                          : widget.l.eng == 1
                                              ? "Country"
                                              : widget.l.swa == 1
                                                  ? "Nchi"
                                                  : "Igihugu",
                                      labelStyle: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic),
                                      strict: false,
                                      items: pays,
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor:Colors.white,
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              dismisskeyboard();
                              getId();
                              if (pay1!="") {
                                insertworker();
                              } else {
                                snackabardropimpty();
                              }
                            }
                          },
                          child: Container(
                            width: 250,
                            height: 40,
                            color: Colors.blue,
                            alignment: Alignment.center,
                            child: widget.l.eng == 1
                                ? Text(
                                    'Accept',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : widget.l.swa == 1
                                    ? Text(
                                        'Kubali',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : widget.l.fra == 1
                                        ? Text(
                                            'Accepter',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'Emeza',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Visibility(
                            visible: visible1,
                            child:Center(
                                        child: LinearProgressIndicator(
                                      backgroundColor: Colors.cyanAccent,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.red),
                                    ))
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(2),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "You Choose A country where you are now",
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
                                                    "Chagua Nchi Ambayo ukoemwo Sasa hivi",
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
                                                    "Hitamwo Igihugu Urimwo ubunyene",
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
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
