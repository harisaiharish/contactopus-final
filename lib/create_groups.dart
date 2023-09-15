import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:qrcode/groups.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future saveGroups(String groupName, List<String> groupMembers) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> groups = {};

  final List<String>? groupNames = prefs.getStringList('groupNames');

  if (groupNames != null) {
    groupNames.add(groupName);
    await prefs.setStringList('groupNames', groupNames);
  } else {
    await prefs.setStringList('groupNames', <String>[groupName]);
  }

  await prefs.setStringList(groupName, groupMembers);
}

class CreateGroups extends StatefulWidget {
  late List<Contact> allContacts = [];
  CreateGroups({Key? key, required this.allContacts}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreateGroupsState();
}

class _CreateGroupsState extends State<CreateGroups> {
  late List<bool> isSelected = [];
  final _controller = TextEditingController();
  static List<Contact> allContacts = [];
  List<MultiSelectItem<Contact>> _items = [];
  List<String> contactIds = [];
  List<String> backup = [];

  List<Contact> _selectedAnimals5 = [];

  @override
  void initState() {
    super.initState();
    allContacts = widget.allContacts;
    _selectedAnimals5 = allContacts;
    _items = allContacts
        .map(
            (contact) => MultiSelectItem<Contact>(contact, contact.displayName))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<String> contactIds;
    return Scaffold(
        appBar: AppBar(title: const Text("Contactopus")),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Dialog(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Name',
                  hintText: 'Group Name',
                ),
              ),
            ),
            Container(
              width: screenWidth,
              height: screenHeight * 0.20,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(children: <Widget>[
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
              ]),
            ),
            ElevatedButton(
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () async => {
                      contactIds = [],
                      for (Contact c in _selectedAnimals5)
                        {
                          contactIds.add(c.id),
                        },
                      if (_controller.text != null &&
                          _controller.text.isNotEmpty &&
                          contactIds.length > 0)
                        {
                          await saveGroups(_controller.text, contactIds),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupList())),
                        }
                    }),
          ]),
        ));
  }
}
