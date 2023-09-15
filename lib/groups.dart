import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:qrcode/delete_groups.dart';
import 'package:qrcode/select_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_groups.dart';

var prefs;

Future<Map<String, List<String>>> buildGroups() async {
  prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> groups = {};

  final List<String>? groupNames = prefs.getStringList('groupNames');

  for (String name in groupNames!) {
    final List<String>? groupMembers = prefs.getStringList(name);
    groups[name] = groupMembers!;
  }

  return groups;
}

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  GroupListState createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  late Future<Map<String, List<String>>> groups;

  @override
  void initState() {
    super.initState();
    groups = SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return buildGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: const Text("Contactopus"),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.fromSize(
                size: Size(160, 50),
                child: Material(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    splashColor: Colors.green,
                    onTap: () async {
                      var allContacts = await FlutterContacts.getContacts();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateGroups(
                                    allContacts: allContacts,
                                  )));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Create",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              SizedBox.fromSize(
                size: Size(160, 50),
                child: Material(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    splashColor: Colors.orange,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      List<String>? allGroupNames =
                          prefs.getStringList('groupNames');
                      if (allGroupNames != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeleteGroups(
                                      allGroupNames: allGroupNames,
                                    )));
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Delete",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height * 0.224719,
              width: MediaQuery.of(context).size.width * 0.874997,
              child: FutureBuilder<Map<String, List<String>>>(
                  future: groups,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, List<String>>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return const Text(
                            '',
                          );
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, int index) {
                                List<String> contactIds;
                                return ElevatedButton(
                                  onPressed: () async => {
                                    contactIds =
                                        snapshot.data!.values.elementAt(index),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SelectDetails(
                                                  contactIds: contactIds,
                                                ))),
                                  },
                                  child: Text(
                                      snapshot.data!.keys.elementAt(index),
                                      style: TextStyle(fontSize: 16)),
                                );
                              });
                        }
                    }
                  })),
          const SizedBox(height: 0),
          Image(
            image: AssetImage('assets/contactopus.png'),
            width: screenWidth / 2.057149910228264,
            height: screenHeight / 4.451450037592496,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }
}
