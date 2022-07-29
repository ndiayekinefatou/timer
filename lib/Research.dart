import 'package:string_similarity/string_similarity.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Research extends StatefulWidget {
  //const Research({Key? key}) : super(key: key);
  List<Contact> contacts;

  dynamic respJson;
  Research(this.contacts, this.respJson);

  @override
  State<Research> createState() => _ResearchState();
}

class _ResearchState extends State<Research> {
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

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Research"),
          backgroundColor: Colors.indigo,
        ),
        body: Stack(children: <Widget>[
          Column(
            children: [Expanded(child: searchContact())],
          )
        ]),
      ),
    );
  }

  Widget searchContact() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: _contactFiltred.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = _contactFiltred[index];
          if (_contactFiltred.length > 1) {
            return ListTile(
                //height: 50,
                title: Text(
                  '${contact.displayName}',
                  style: TextStyle(fontSize: 20.0),
                ),
                leading: CircleAvatar(
                  child: Text(contact.initials()),
                ));
          } else if (_contactFiltred.length == 1) {
            return Card(
              child: Center(
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      child: Text(
                        contact.initials(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      radius: 30,
                      backgroundColor: const Color(0xff2ba5e6),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '${contact.displayName}',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 30,
                        color: const Color(0xff777777),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.call,
                              color: const Color(0xff2ba5e6),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(children: [
                                Text(
                                  '${contact.phones?.elementAt(0).value}',
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xff2ba5e6),
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Mobile',
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xff2ba5e6)),
                                  textAlign: TextAlign.center,
                                ),
                              ])),
                        ]),
                  )
                ]),
              ),
            );
          } else {
            return Center(child: new Text("Aucun contact"));
          }
        },
      ),
    );
  }
}

/* Widget searchContact() {
  return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      //itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        //Contact contact = contacts[index];
        return Card(
          child: Center(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  /*child: Text(
                      contact.initials(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),*/
                  radius: 30,
                  backgroundColor: const Color(0xff2ba5e6),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                /*child: Text(
                    '${contact.displayName}',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 30,
                      color: const Color(0xff777777),
                    ),
                    textAlign: TextAlign.center,
                  ),*/
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.call,
                          color: const Color(0xff2ba5e6),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(children: [
                            /*Text(
                                '${contact.phones?.elementAt(0).value}',
                                style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xff2ba5e6),
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              ),*/
                            Text(
                              'Mobile',
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xff2ba5e6)),
                              textAlign: TextAlign.center,
                            ),
                          ])),
                    ]),
              )
            ]),
          ),
        );
      });
} */
