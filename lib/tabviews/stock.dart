import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import '../servicepayement.dart';
import 'package:flutter/foundation.dart';
class Stock extends StatefulWidget {
  final Langue l;
  final int isboss;
  final int controled;
  final String numero;
  final String password;
  final int duree;
  final String worker;
  Stock(
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
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  TextEditingController name = new TextEditingController();
  TextEditingController qte = new TextEditingController();
  TextEditingController referance = new TextEditingController();
  bool delet = false;
  bool ispop = true;
  Timer _timer;
  String va = "";
  ScrollController _scrollcontroller = new ScrollController();
  final _formKey = GlobalKey<FormState>();
  StreamController<List> _streamcontroller1 = StreamController<List>();
  StreamController<List> _streamcontroller = StreamController<List>();
  FocusNode focusnode;
  FocusNode focusnode1;
  @override
  void initState() {
    focusnode=FocusNode();
    focusnode1=FocusNode();
    focusnode.addListener(() { });
    focusnode1.addListener(() { });
    selectstock();
_timer = Timer.periodic(const Duration(seconds:5), (timer) {
      selectstock();
    });
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
    _streamcontroller.close();
    _streamcontroller1.close();
    name.dispose();
    if (_timer.isActive) _timer.cancel();
    qte.dispose();
    noms.clear();
    _scrollcontroller.dispose();
    referance.dispose();
    stock.clear();
    super.dispose();
  }

  final noms = [];
  var stock = [];
 firstcheckproductt(){
    setState(() {
      ispop = false;
      visible1 = true;
    });
    try {
      if (name.text.isNotEmpty && (double.parse(qte.text) > 0)) {
        http.post(
            "https://kakwetuburundifafanini.com/fp/firstcheckproduct1.php",
            body: {
              "nom": name.text.trim().replaceAll(' ', '').toUpperCase(),
              "nro": widget.numero,
              "q_encien": qte.text.replaceAll(' ', '').trim(),
              "q_recent": qte.text.replaceAll(' ', '').trim(),
            }).then((value){
          if(value.statusCode==200){
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
          }else{
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
          referance.text = "";
          qte.text = "";
          name.text = "";
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
        ispop = true;
        visible1 = false;
        dismisskeyboard();
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

  selectstock() async {
    try {
      final response = await http
          .post("https://kakwetuburundifafanini.com/gs/selectstock.php", body: {
        "nro": widget.numero,
      });
    var resultat=await compute(_isolate,response.body);
      setState(() {
            _streamcontroller1.add(resultat);
        stock =resultat;
      });
    } catch (e) {
      setState(() {
        stock = [];
      });
    }
  }
     static _isolate(String body){
return jsonDecode(body);
  }
  bool visible1 = false;
  deleteproduct(String nom){
    setState(() {
      ispop = false;
    });
    try {
      http.post("https://kakwetuburundifafanini.com/dp/deleteproduct.php",
          body: {
            "nom": nom,
            "nro": widget.numero,
          });
      setState(() {
        ispop = true;
      });
    } catch (e) {
      setState(() {
        ispop = true;
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

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Votre paquet a expiré Vous Voulez payer Encore ?",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text(
                  "Your Packet has Finished Do you want to pay once again ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Mfuko wako Umeisha Unataka kulipa tena ?",
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
          ? Text("Vous Voulez Enregistrer " + qte.text + " " + name.text + " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text(
                  "Do you want to register " +
                      qte.text +
                      " " +
                      name.text +
                      " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text(
                      "Unataka kuingiza " + name.text + " " + qte.text + " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka kwinjiza " + name.text + " " + qte.text + " ?",
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
              referance.text = "";
              name.text = "";
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
              if (double.parse(qte.text.trim()) > 0) {
                Navigator.pop(context);
                if (widget.isboss == 0) {
                  if (widget.worker == "y") {
                    firstcheckproductt();
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
                      referance.text = "";
                      qte.text = "";
                      name.text = "";
                      ispop = true;
                      visible1 = false;
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
                firstcheckproductt();
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
                setState(() {
                  referance.text = "";
                  name.text = "";
                });
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

  void messagevalidersuppression(String nom, String stock1,int i) {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text(
              "Vous Voulez Vraiment Supprimer " + stock1 + " de " + nom + " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Do you Want to delete " + stock1 + " of " + nom + " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Unataka Kuondoa " + nom + " " + stock1 + " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka guhanagura " + nom + "  " + stock1 + " ?",
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
              referance.text = "";
              name.text = "";
              delet = false;
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
            if (widget.duree >= 0) {
              Navigator.pop(context);
              deleteproduct(nom);
              setState(() {
                delet = false;
              });
              setState(() {
                referance.text = "";
                name.text = "";
              });
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
        duration: Duration(seconds: stock.isEmpty ? 1 :(stock.length*2)),
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
            setState(() {
              ispop = true;
            });
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
            setState(() {
              ispop = true;
            });
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
        }
        return _willpop();
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
                            Visibility(
                              visible: widget.controled == 1 ? true : false,
                              child: Padding(
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
                                              name,
                                              context,
                                              widget.l,
                                              widget.controled,
                                              referance,
                                              stock));
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
                            ),
                            Expanded(
                                child: Scrollbar(
                              child: ListView.builder(
                                  controller: _scrollcontroller,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:snap.data.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      splashColor: Colors.white,
                                      onLongPress: () {
                                        if (widget.isboss == 1) {
                                          setState(() {
                                            delet = true;
                                            referance.text = "";
                                            name.text = "";
                                          });
                                        } else {
                                          setState(() {
                                            referance.text = "";
                                            name.text = "";
                                          });
                                        }
                                      },
                                      onTap: () {
                                        if ((widget.controled == 0) &&
                                            (delet == false)) {
                                          if (name.text.isEmpty) {
                                            setState(() {
                                              referance.text = snap.data[i]['nom'];
                                              name.text = snap.data[i]['nom'];
                                            });
                                          } else {
                                            setState(() {
                                              delet = false;
                                              referance.text = "";
                                              name.text = "";
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            delet = false;
                                            referance.text = "";
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
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: widget.l.fra == 1
                                                  ? Text(
                                                      "Stock: " +
                                                          snap.data[i]['q_encien'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 30),
                                                    )
                                                  : widget.l.eng == 1
                                                      ? Text(
                                                          "Stock: " +
                                                              snap.data[i]
                                                                  ['q_encien'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30),
                                                        )
                                                      : widget.l.swa == 1
                                                          ? Text(
                                                              "Hisa: " +
                                                                  snap.data[i][
                                                                      'q_encien'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 30),
                                                            )
                                                          : Text(
                                                              "Sitoke: " +
                                                                  snap.data[i][
                                                                      'q_encien'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: widget.l.fra == 1
                                                    ? snap.data[i]['jour'].toString() ==
                                                            '1'
                                                        ? Text(
                                                            "stock Recent Dimanche le " +
                                                                snap.data[i]
                                                                    ['dat'] +
                                                                " : " +
                                                                snap.data[i][
                                                                    'q_recent'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white))
                                                        : snap.data[i]['jour']
                                                                    .toString() ==
                                                                '2'
                                                            ? Text(
                                                                "stock Recent Lundi le " +
                                                                    snap.data[i]
                                                                        ['dat'] +
                                                                    " : " +
                                                                    snap.data[i]['q_recent'],
                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                            : snap.data[i]['jour'].toString() == '3'
                                                                ? Text("stock Recent Mardi le " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                : snap.data[i]['jour'].toString() == '4'
                                                                    ? Text("stock Recent Mercredi le " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                    : snap.data[i]['jour'].toString() == '5'
                                                                        ? Text("stock Recent Jeudi le " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                        : snap.data[i]['jour'].toString() == '6'
                                                                            ? Text("stock Recent Vendredi le " + snap.data[i]['dat'] + ":" + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : Text("stock Recent Samedi le " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                    : widget.l.eng == 1
                                                        ? snap.data[i]['jour'].toString() == '1'
                                                            ? Text("Recent stock Sunday " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                            : snap.data[i]['jour'].toString() == '2'
                                                                ? Text("Recent stock Monday " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                : snap.data[i]['jour'].toString() == '3'
                                                                    ? Text("Recent stock Tuesday " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                    : snap.data[i]['jour'].toString() == '4'
                                                                        ? Text("Recent stock Wednesday " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                        : snap.data[i]['jour'].toString() == '5'
                                                                            ? Text("Recent stock Thursday " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : snap.data[i]['jour'].toString() == '6'
                                                                                ? Text("Recent stock Friday " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                : Text("Recent stock Saturday " + snap.data[i]['dat'] + ":" + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                        : widget.l.swa == 1
                                                            ? snap.data[i]['jour'].toString() == '1'
                                                                ? Text("Hisa yakalibu Jumapili " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                : snap.data[i]['jour'].toString() == '2'
                                                                    ? Text("Hisa yakalibu Jumatatu " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                    : snap.data[i]['jour'].toString() == '3'
                                                                        ? Text("Hisa yakalibu Jumanne " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                        : snap.data[i]['jour'].toString() == '4'
                                                                            ? Text("Hisa yakalibu Jumatano " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : snap.data[i]['jour'].toString() == '5'
                                                                                ? Text("Hisa yakalibu Alhamisi " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                : snap.data[i]['jour'].toString() == '6'
                                                                                    ? Text("Hisa yakalibu Ijumaa " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                    : Text("Hisa yakalibu Jumamosi " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                            : snap.data[i]['jour'].toString() == '1'
                                                                ? Text("Sitoke Iheruka Ni Kuw'Imana " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                : snap.data[i]['jour'].toString() == '2'
                                                                    ? Text("Sitoke Iheruka Ni Kuwambere " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                    : snap.data[i]['jour'].toString() == '3'
                                                                        ? Text("Sitoke Iheruka Ni Kuwakabiri " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                        : snap.data[i]['jour'].toString() == '4'
                                                                            ? Text("Sitoke Iheruka Ni Kuwagatatu " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : snap.data[i]['jour'].toString() == '5'
                                                                                ? Text("Sitoke Iheruka Ni Kuwakane " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                : snap.data[i]['jour'].toString() == '6'
                                                                                    ? Text("Sitoke Iheruka Ni Kuwagatanu " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                    : Text("Sitoke Iheruka Ni Kuwagatandatu " + snap.data[i]['dat'] + " : " + snap.data[i]['q_recent'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Visibility(
                                                visible: delet,
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      messagevalidersuppression(
                                                          snap.data[i]['nom'],
                                                          snap.data[i]['q_encien'],i); 
                                                    }
                                                    ),
                                              ),
                                            )
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
                                    onTap: () {
                                      showSearch(
                                          context: context,
                                          delegate: DataSearch2(
                                              name,
                                              context,
                                              widget.l,
                                              widget.controled,
                                              referance,
                                              stock));
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
                              Container(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                    focusNode: focusnode1,
                                    inputFormatters: [
                                    new FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z.,-/]"))
                                                                 ],
                                    enabled:
                                        referance.text.isEmpty ? true : false,
                                    autofocus: true,
                                    controller: name,
                                    maxLength: 20,
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
                                            ? 'Entrez ou choisissez Le produit'
                                            : widget.l.eng == 1
                                                ? 'Enter or choose a product'
                                                : widget.l.swa == 1
                                                    ? 'Andika au chagua bidhaa'
                                                    : 'andika canke uhitemwo ikidandazwa';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible: false,
                                  child: TextFormField(
                                    controller: referance,
                                  )),
                              Container(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                    controller: qte,
                                         focusNode: focusnode,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                        inputFormatters: [
                                    new FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                                  ],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                                  "Si Vous avez Un Jour Enregistré Ce Produit Selectionnez-le Dans La Liste des produits Car Vous pouvez vous tromper comment le nom s'ecrit",
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
                                                      "If You Wrote One Day this product Choose it in List of product in order to avoid that you Write bad the Product",
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
                                                          "Ukiwa siku moja Uliingiza Hili Jina chagua mu Orodha Jina, Kwasababu unaweza jidanganya Kuliandika",
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
                                                          "Mugihe Mwigeze kwandika Iki gicuruzwa, gicagure murutonde Kubera Murashobora kwihenda uko candikwa",
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

class DataSearch2 extends SearchDelegate<String> {
  TextEditingController nom = new TextEditingController();
  TextEditingController reference = new TextEditingController();
  BuildContext context;
  Langue l;
  var noms;
  int controled;
  DataSearch2(this.nom, this.context, this.l, this.controled, this.reference,
      this.noms);
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
                    .contains(query.toUpperCase())||element['dat']
                    .toString()
                    .contains(query))
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
                        if (controled == 0) {
                          nom.text = sugest[index]['nom'];
                          reference.text = sugest[index]['nom'];
                          Navigator.pop(context);
                        }
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
                                trailing: Column(
                                  children: [
                                    this.l.fra == 1
                                        ? Text(
                                            "Stock recent:" +
                                                sugest[index]['q_recent'],
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontWeight: FontWeight.bold))
                                        : this.l.eng == 1
                                            ? Text(
                                                "Recent Stock:" +
                                                    sugest[index]['q_recent'],
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : this.l.swa == 1
                                                ? Text(
                                                    "Hisa yakaribu:" +
                                                        sugest[index]
                                                            ['q_recent'],
                                                    style: TextStyle(
                                                        color: Colors.yellow,
                                                        fontWeight:
                                                            FontWeight.bold))
                                                : Text(
                                                    "Sitoke Iheruka:" +
                                                        sugest[index]
                                                            ['q_recent'],
                                                    style: TextStyle(
                                                        color: Colors.yellow,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                    Text(sugest[index]['dat'],
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                title: RichText(
                                  text: TextSpan(
                                      text:sugest[index]['nom']
                                          .substring(0, query.length),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                      children: [
                                        TextSpan(
                                            text:sugest[index]['nom']
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
