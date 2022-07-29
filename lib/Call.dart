//import 'package:call_log/call_log.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Call extends StatefulWidget {
  List<Contact> contacts;

  dynamic respJson;
  Call(this.contacts, this.respJson);

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  List<Contact> _contactFiltred = [];

  @override
  void initState() {
    super.initState();
    getSearchContact();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool similarity(Contact contact) {
    String contactName = contact.displayName!.toLowerCase();
    if ((contactName.similarityTo(widget.respJson["text_predict"]) > 0.6)) {
      return true;
    } else {
      return false;
    }
  }

  getSearchContact() async {
    List<Contact> _contacts = [];
    _contacts.addAll(widget.contacts);
    _contacts.retainWhere((contact) => similarity(contact));

    setState(() {
      _contactFiltred = _contacts;
    });
    return _contactFiltred;
  }

  _callNumber(Contact contact) async {
    var number = '${contact.phones?.elementAt(0).value}'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Call"),
          backgroundColor: Colors.indigo,
        ),
        body: _callContact());
  }

  Widget _callContact() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: _contactFiltred.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = _contactFiltred[index];
          if (_contactFiltred.length == 1) {
            print("un contact à appeler");
            _callNumber(contact);
            //calllog();
            return new Text("");
          } else {
            return new Text(
              "Aucun contact à appeler",
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }
}
