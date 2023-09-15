import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:qrcode/select_details.dart';

class Try extends StatefulWidget {
  late List<Contact> allContacts = [];
  Try({Key? key, required this.allContacts}) : super(key: key);
  @override
  _Try createState() => _Try();
}

class _Try extends State<Try> {
  static List<Contact> allContacts = [];
  List<MultiSelectItem<Contact>> _items = [];
  List<String> contactIds = [];
  List<String> backup = [];

  List<Contact> _selectedAnimals5 = [];

  @override
  void initState() {
    super.initState();
    allContacts = widget.allContacts;
    _items = allContacts
        .map(
            (contact) => MultiSelectItem<Contact>(contact, contact.displayName))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contactopus"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              MultiSelectDialogField(
                items: _items,
                searchable: true,
                title: const Text("Contacts"),
                selectedColor: Colors.green,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                buttonIcon: const Icon(
                  Icons.contact_page,
                  color: Colors.green,
                ),
                buttonText: Text(
                  "Select Contact(s)",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  _selectedAnimals5 = results;
                },
              ),
              ElevatedButton(
                  child: const Text(
                    'Select Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async => {
                        for (Contact c in _selectedAnimals5)
                          {
                            contactIds.add(c.id),
                          },
                        backup = contactIds,
                        contactIds = [],
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectDetails(
                                      contactIds: backup,
                                    ))),
                      }),
              const SizedBox(height: 120),
              const Image(
                image: AssetImage('assets/contactopus.png'),
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              )
            ],
          ),
        ),
      ),
    );
  }
}
