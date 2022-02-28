// import 'package:flutter/material.dart';
// import 'home.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:chrono_project2/Recorder.dart';
// import 'package:chrono_project2/timer_widget.dart';

// class Result extends StatefulWidget {
//   const Result(Widget buildPlayer, {Key? key}) : super(key: key);

//   @override
//   _ResultState createState() => _ResultState();
// }

// class _ResultState extends State<Result> {
//   @override
//   bool visibleResult = true;
//   List<Contact> contacts = [];

//   getOneContact() async {
//     //Ici c'est la recherche du contact dont le nom est Ada. Ce dont j'ai besoin pour afficher
//     // le résultat
//     List<Contact> contacts = await ContactsService.getContacts(query: 'Ada');
//   }

//   Widget build(BuildContext context) => Center(child: searchContact());

//   Widget searchContact() {
//     return ListView.builder(
//         shrinkWrap: true,
//         padding: const EdgeInsets.all(8),
//         itemCount: contacts.length,
//         itemBuilder: (BuildContext context, int index) {
//           Contact contact = contacts[index];
//           return ListTile(
//             leading: CircleAvatar(
//               child: Text(contact.initials()),
//             ),
//             title: Text('${contact.displayName}'),
//             subtitle: Text('${contact.phones?.elementAt(0).value}'),
//           );
//         });
//   }
// }
