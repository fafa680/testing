
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Payemmentdette extends StatefulWidget {
  final Langue l;
  final String numero;
  final String name;
  final String prix;
  final String qte;
  final String etat;
  final String nomcl;
  final String prenomcl;
  final String tel;
  final int isboss;
  final String worker;
   final String resultat;
  Payemmentdette(
      {Key key,
      this.l,
      this.numero,
      this.name,
      this.prix,
      this.qte,
      this.etat,
      this.nomcl,
      this.prenomcl,
      this.tel,
      this.isboss,
      this.worker,
      this.resultat})
      : super(key: key);
  @override
  _PayemmentdetteState createState() => _PayemmentdetteState();
}

class _PayemmentdetteState extends State<Payemmentdette> {
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
                        ? Securite(
                            l: widget.l,
                            numero: widget.numero,
                            name: widget.name,
                            prix: widget.prix,
                            qte: widget.qte,
                            etat: widget.etat,
                            nomcl: widget.nomcl,
                            prenomcl: widget.prenomcl,
                            tel: widget.tel,
                            isboss: widget.isboss,
                            worker: widget.worker,
                            resultat: widget.resultat,
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

class Securite extends StatefulWidget {
  final Langue l;
  final String numero;
  final String name;
  final String prix;
  final String qte;
  final String etat;
  final String nomcl;
  final String prenomcl;
  final String tel;
  final int isboss;
  final String worker;
  final String resultat;
  Securite(
      {Key key,
      this.l,
      this.numero,
      this.name,
      this.prix,
      this.qte,
      this.etat,
      this.nomcl,
      this.prenomcl,
      this.tel,
      this.isboss,
      this.worker,
      this.resultat})
      : super(key: key);

  @override
  _SecuriteState createState() => _SecuriteState();
}

class _SecuriteState extends State<Securite>{
  bool visible1 = true;
  bool ispop = false;
  @override
  void initState() {
    firstcheckdettepayer();
    super.initState();
  }
 firstcheckdettepayer(){
 try{
   if (double.parse(widget.resultat)>= double.parse(widget.qte) &&
            (double.parse(widget.qte)) > 0) {
          if (double.parse(widget.resultat)== double.parse(widget.qte)) {
            if (widget.isboss == 0) {
              if(widget.worker=="y"){
              firstcheckventedelete();
              }else if(widget.worker=="n"){
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
          Navigator.of(context).pop();
          Navigator.pop(context);
        });
              }else{
          setState(() {
        visible1 = false;
        ispop = true;
        Navigator.of(context).pop();
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
            } else {
              firstcheckventedelete();
            }
          } else {
            if (widget.isboss == 0) {
              if(widget.worker=="y"){
              firstcheckvente();
              }else if(widget.worker=="n"){
               setState(() {
                  Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Desolé,Vous n'vez pas L'autorisation d'enregistrer,Contacter Votre Boss"
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
          Navigator.of(context).pop();
          Navigator.pop(context);
        });
              }else{
          setState(() {
        visible1 = false;
        ispop = true;
        Navigator.of(context).pop();
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
            } else {
              firstcheckvente();
            }
          }
        } else {
          setState(() {
                      Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Echec!! sa dette est " +
                      widget.resultat +
                      " pas " +
                      widget.qte
                  : widget.l.eng == 1
                      ? "Error!! His debt is " +
                          widget.resultat +
                          " Not " +
                          widget.qte
                      : widget.l.swa == 1
                          ? "Habiwezekani!! Deni lake ni " +
                              widget.resultat +
                              " Hapana " +
                              widget.qte
                          : "Ntibikunda!! Ideni yatwaye ni " +
                              widget.resultat +
                              " Mwebwe Mwanditse " +
                              widget.qte,
              backgroundColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
            visible1 = false;
            ispop = true;
            Navigator.of(context).pop();
          });
        }
   }catch(e){
 setState(() {
        visible1 = false;
        ispop = true;
        Navigator.of(context).pop();
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
 firstcheckvente(){
    try {
      http.post(
          "https://kakwetuburundifafanini.com/fv/firstcheckvente1.php",
          body: {
            "nom": widget.name,
            "nro": widget.numero,
            "px": widget.prix,
            "qte": widget.qte,
            "etat": widget.etat,
            "nom_client": widget.nomcl,
            "prenom_client": widget.prenomcl,
            "telephone_client": widget.tel,
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
          visible1 = false;
          ispop = true;
          Navigator.of(context).pop();
        });
    } catch (e) {
      setState(() {
        visible1 = false;
        ispop = true;
        Navigator.of(context).pop();
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

  firstcheckventedelete(){
    try {
      http.post(
          "https://kakwetuburundifafanini.com/fv/firstcheckvente2.php",
          body: {
            "nom": widget.name,
            "nro": widget.numero,
            "px": widget.prix,
            "qte": widget.qte,
            "etat": widget.etat,
            "nom_client": widget.nomcl,
            "prenom_client": widget.prenomcl,
            "telephone_client": widget.tel,
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
          visible1 = false;
          ispop = true;
          Navigator.of(context).pop();
        });
    } catch (e) {
   setState(() {
        visible1 = false;
        ispop = true;
        Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => ispop,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Visibility(
            visible: visible1,
            child:Center(
                        child: LinearProgressIndicator(
                      backgroundColor: Colors.cyanAccent,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    ))
          ),
        ),
      ),
    );
  }
}
