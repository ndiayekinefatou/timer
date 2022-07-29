//import 'package:http/http.dart';
//import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:contacts_service/contacts_service.dart';
import 'Player.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Delete extends StatefulWidget {
  List<Contact> contacts;

  dynamic respJson;
  Delete(this.contacts, this.respJson);

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  List<Contact> _contactFiltred = [];
  var audioPlayer = SoundPlayer();

  @override
  void initState() {
    super.initState();
    getSearchContact();
    audioPlayer.init();
  }

  @override
  void dispose() {
    super.dispose();
    //audioPlayer.init();
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

  _deleteC(Contact contact) async {
    await ContactsService.deleteContact(contact);

    print("un contact supprimé");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Delete"),
        backgroundColor: Colors.indigo,
      ),
      body: _deleteContact(),
    );
  }

  Widget _deleteContact() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: _contactFiltred.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = _contactFiltred[index];

          if (_contactFiltred.length == 1) {
            print("un contact à suprimer");
            _deleteC(contact);
            Navigator.of(context).pop();
            return Center(child: new Text("Contact supprimé"));
          } else if (_contactFiltred.length > 1) {
            return Center(
                child: new Text("Il existe plusieurs contact à supprimer"));
          } else {
            return Center(child: new Text("Aucun contact à supprimer"));
          }
        },
      ),
    );
  }
}
