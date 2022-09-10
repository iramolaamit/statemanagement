import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final contactBook = ContactBook();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: ValueListenableBuilder(valueListenable:  ContactBook(),
        builder: (context, value, child) =>
         ListView.builder(
          itemCount: contactBook.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final contact = contactBook.contact(index: index)!;
            return ListTile(
              title: Text(contact.name),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed('/new-contact');
          },
          child: Icon(Icons.contacts)),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({Key? key}) : super(key: key);

  @override
  State<NewContactView> createState() => _NewContactState();
}

class _NewContactState extends State<NewContactView> {
  final _contactController = TextEditingController();
  @override
  void initState() {
    _contactController;
    super.initState();
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new contact'),
      ),
      body: Column(children: [
        TextField(
          controller: _contactController,
          decoration: const InputDecoration(hintText: 'Enter the name ...'),
        ),
        TextButton(
          onPressed: () {
            final contact = Contact(name: _contactController.text);
            ContactBook().add(contact: contact);
            Navigator.of(context).pop();
          },
          child: const Text("Add contact"),
        )
      ]),
    );
  }
}

class Contact {
  final String id;
  final String name;
  Contact({required this.name}) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;
  // final List<Contact> _contacts = [];
  // int get length => _contacts.length;
  int get length => value.length;
  void add({required Contact contact}) {
    // _contacts.add(contact);
    final contacts = value;
    contacts.add(contact);
    value = contacts;
    notifyListeners();
  }

  void remove({required Contact contact}) {
    // _contacts.remove(contact);
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);

      notifyListeners();
    }
  }

  Contact? contact({required int index}) {
    // return (_contacts.length > index) ? _contacts[index] : null;
    return (value.length > index) ? value[index] : null;
  }
}
