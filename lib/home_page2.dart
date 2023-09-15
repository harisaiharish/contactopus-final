import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:qrcode/groups.dart';
import 'package:qrcode/qr_scanner.dart';
import 'package:qrcode/select_details.dart';
import 'package:qrcode/share_contacts_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateHomePage2State();
}

class _CreateHomePage2State extends State<HomePage2> {
  late String id = "";
  List<String> myID = [];
  late String name = "";
  late String email = "";
  late String phoneNumber = "";

  @override
  void initState() {
    super.initState();
    () async {
      await FlutterContacts.requestPermission();
      final prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("my_id");
      if (id != null) {
        Contact? c = await FlutterContacts.getContact(id);
        if (c != null) {
          myID.add(id);
          setState(() {
            name = c.displayName.isNotEmpty ? c.displayName : "1";
            try {
              email = c.emails.first.address;
            } catch (e) {
              email = "";
            }
            try {
              phoneNumber = c.phones.first.number;
            } catch (e) {
              phoneNumber = "";
            }
          });
        }
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Future.delayed(
        Duration.zero,
        () => showDialogIfFirstLoaded(
              context,
            ));
    return Scaffold(
        appBar: AppBar(title: const Text("Contactopus")),
        backgroundColor: const Color.fromARGB(221, 43, 42, 42),
        body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth * 0.0243055,
                    height: screenHeight * 0.0336969,
                  ),
                  Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SizedBox(
                        width: screenWidth * 0.923708,
                        height: screenHeight * 0.112323,
                        child: InkWell(
                          splashColor: Colors.green,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectDetails(
                                          contactIds: myID,
                                        )));
                          },
                          child: ListTile(
                            leading: SvgPicture.asset(
                                'assets/Contactopus_logo.svg',
                                width: screenWidth * 0.17014),
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              email,
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: Text(
                              phoneNumber,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    width: screenWidth * 0.0243055,
                    height: screenHeight * 0.0336969,
                  ),
                  SizedBox(
                    width: screenWidth * 0.923608,
                    height: screenHeight * 0.0561615,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: () async {
                          var allContacts = await FlutterContacts.getContacts();
                          if (!mounted) {
                            return;
                          }
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Select Contact"),
                                  content: SizedBox(
                                    height: screenHeight * 0.33696885,
                                    width: screenWidth * 0.729164135,
                                    child: ListView.builder(
                                        itemCount: allContacts.length,
                                        itemBuilder: (context, position) {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              if (await FlutterContacts
                                                  .requestPermission()) {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.remove("my_id");
                                                prefs.setString("my_id",
                                                    allContacts[position].id);
                                              }
                                            },
                                            child: Text(allContacts[position]
                                                .displayName),
                                          );
                                        }),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        'Set',
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {});
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        await Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage2()));
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'Create New',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Contact c = Contact();
                                        Contact c1 =
                                            await FlutterContacts.insertContact(
                                                c);
                                        await FlutterContacts.openExternalEdit(
                                            c1.id);
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.remove("my_id");
                                        prefs.setString("my_id", c1.id);

                                        setState(() {});
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        await Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage2()));
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text(
                          "Set your contact",
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                  SizedBox(
                    width: screenWidth * 0.0243055,
                    height: screenHeight * 0.0336969,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.4374985,
                        height: screenHeight * 0.33696885,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.lightGreenAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            splashColor: Colors.blue,
                            child: const Center(
                              child: Text(
                                "Scan \nQR Code",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QRScanner2()),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.4374985,
                            height: screenHeight * 0.2246459,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue,
                                child: const Center(
                                  child: Text(
                                    "Contacts",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: () async {
                                  var allContacts =
                                      await FlutterContacts.getContacts();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Try(allContacts: allContacts)),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: screenWidth * 0.4374985,
                            height: screenHeight * 0.2246459,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                child: const Center(
                                  child: Text(
                                    "Groups",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: () async {
                                  debugPrint('Open Groups Flutter Page.');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GroupList()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}

showDialogIfFirstLoaded(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var allContacts = await FlutterContacts.getContacts();
  bool? isFirstLoaded = prefs.getBool('keyIsFirstLoaded');
  if (isFirstLoaded == null) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select Contact"),
            content: SizedBox(
              height: 200,
              width: 300,
              child: ListView.builder(
                  itemCount: allContacts.length,
                  itemBuilder: (context, position) {
                    return ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove("my_id");
                        prefs.setString("my_id", allContacts[position].id);
                      },
                      child: Text(allContacts[position].displayName),
                    );
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Set',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () async {
                  prefs.setBool('keyIsFirstLoaded', false);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage2()));
                },
              ),
              TextButton(
                child: const Text(
                  'Create New',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () async {
                  Contact c = Contact();
                  await FlutterContacts.insertContact(c);
                  await FlutterContacts.openExternalEdit(c.id);
                },
              ),
            ],
          );
        });
  }
}
