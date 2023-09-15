import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:qrcode/qr_screen.dart';

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

class SelectDetails extends StatefulWidget {
  late List<String> contactIds;
  SelectDetails({Key? key, required this.contactIds}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectDetailsState();
}

class _SelectDetailsState extends State<SelectDetails> {
  late List<String> contactIds = [];
  late List<bool> isSelected = [];
  final List<String> details = [
    "Display Name",
    "First Name",
    "Last Name",
    "Phone Numbers",
    "Emails",
    "Addresses",
    "Organizations",
    "Websites",
    "LinkedIn",
    "Instagram",
    "SnapChat",
    "Discord",
    "Facebook",
    "All Social Media",
    "Notes"
  ];

  @override
  void initState() {
    super.initState();
    contactIds = widget.contactIds;
    setState(() {
      isSelected = List.filled(details.length, true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> selectedDetails;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Contactopus"),
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 147, 223, 130),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Select Details to Share",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: details.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return Card(
                      child: LabeledCheckbox(
                        label: details[position],
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        value: isSelected[position],
                        onChanged: (bool newValue) {
                          setState(() {
                            isSelected[position] = newValue;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
                child: const Text(
                  'Share',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () async => {
                      selectedDetails = [],
                      for (int i = 0; i < details.length; i++)
                        {
                          if (isSelected[i])
                            {
                              selectedDetails.add(details[i]),
                            }
                        },
                      await qrDetails2(selectedDetails, contactIds, context),
                    })
          ]),
        ));
  }
}

Future qrDetails2(
    List<String> details, List<String> contactIds, BuildContext context) async {
  String qrString = "";

  for (String id in contactIds) {
    Contact? c = await FlutterContacts.getContact(id);
    if (c != null) {
      qrString = qrString + ",new";
      for (String detail in details) {
        switch (detail) {
          case "Display Name":
            qrString = qrString + ",d," + c.displayName;
            break;
          case "First Name":
            qrString = qrString + ",f," + c.name.first;
            break;
          case "Last Name":
            qrString = qrString + ",l," + c.name.last;
            break;
          case "Phone Numbers":
            for (Phone p in c.phones) {
              qrString = qrString + ",p," + p.number + ",";
              var temp = p.label.toString().split(".");
              temp[1] = capitalize(temp[1]);
              if (temp[1] == "Custom") {
                qrString = qrString + p.customLabel;
              } else {
                qrString = qrString + temp[1];
              }
            }
            break;
          case "Emails":
            for (Email m in c.emails) {
              qrString = qrString + ",m," + m.address + ",";
              var temp = m.label.toString().split(".");
              temp[1] = capitalize(temp[1]);
              if (temp[1] == "Custom") {
                qrString = qrString + m.customLabel;
              } else {
                qrString = qrString + temp[1];
              }
            }
            break;
          case "Addresses":
            for (Address a in c.addresses) {
              qrString = qrString + ",a," + a.address + ",";
              var temp = a.label.toString().split(".");
              temp[1] = capitalize(temp[1]);
              if (temp[1] == "Custom") {
                qrString = qrString + a.customLabel;
              } else {
                qrString = qrString + temp[1];
              }
            }
            break;
          case "Organizations":
            for (Organization o in c.organizations) {
              qrString = qrString +
                  ",c," +
                  o.company +
                  "," +
                  o.department +
                  "," +
                  o.title;
            }
            break;
          case "Websites":
            for (Website w in c.websites) {
              qrString = qrString + ",w," + w.url;
            }
            break;
          case "LinkedIn":
            for (SocialMedia sm in c.socialMedias) {
              if (sm.label.toString() == "linkedIn") {
                qrString =
                    qrString + ",s," + sm.userName + "," + sm.label.toString();
              }
            }
            break;

          case "Instagram":
            for (SocialMedia sm in c.socialMedias) {
              if (sm.label.toString() == "linkedIn") {
                qrString =
                    qrString + ",s," + sm.userName + "," + sm.label.toString();
              }
            }
            break;
          case "SnapChat":
            for (SocialMedia sm in c.socialMedias) {
              if (sm.label.toString() == "snapchat") {
                qrString =
                    qrString + ",s," + sm.userName + "," + sm.label.toString();
              }
            }
            break;
          case "Discord":
            for (SocialMedia sm in c.socialMedias) {
              if (sm.label.toString() == "discord") {
                qrString =
                    qrString + ",s," + sm.userName + "," + sm.label.toString();
              }
            }
            break;
          case "Facebook":
            for (SocialMedia sm in c.socialMedias) {
              if (sm.label.toString() == "facebook") {
                qrString =
                    qrString + ",s," + sm.userName + "," + sm.label.toString();
              }
            }
            break;
          case "All Social Media":
            for (SocialMedia sm in c.socialMedias) {
              qrString =
                  qrString + ",s," + sm.userName + "," + sm.label.toString();
            }
            break;
          case "Notes":
            for (Note n in c.notes) {
              qrString = qrString + ",n," + n.note;
            }
            break;

          default:
            print("string not matched");
        }
      }
    }
  }

  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => QRScreen(
              QRData: qrString,
            )),
  );
}

String capitalize(String value) {
  var result = value[0].toUpperCase();
  bool cap = true;
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " " && cap == true) {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
      cap = false;
    }
  }
  return result;
}
