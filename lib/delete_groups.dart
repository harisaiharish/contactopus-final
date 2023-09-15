import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
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

class DeleteGroups extends StatefulWidget {
  late List<String> allGroupNames = [];
  DeleteGroups({Key? key, required this.allGroupNames}) : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _DeleteGroupsState(allGroupNames: allGroupNames);
}

class _DeleteGroupsState extends State<DeleteGroups> {
  late List<String> allGroupNames = [];
  late List<bool> isSelected = [];

  _DeleteGroupsState({required this.allGroupNames});

  @override
  void initState() {
    super.initState();
    setState(() {
      isSelected = List.filled(allGroupNames.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> groupNames;
    SharedPreferences prefs;
    return Scaffold(
        appBar: AppBar(title: const Text("Select Groups To Delete")),
        backgroundColor: const Color.fromARGB(255, 147, 223, 130),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            ListView.builder(
              itemCount: allGroupNames.length,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, position) {
                return Card(
                  child: LabeledCheckbox(
                    label: allGroupNames[position],
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
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Confirm Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () async => {
                      groupNames = [],
                      for (int i = 0; i < allGroupNames.length; i++)
                        {
                          if (isSelected[i])
                            {
                              groupNames.add(allGroupNames[i]),
                            }
                        },
                      if (groupNames.length > 0)
                        {
                          prefs = await SharedPreferences.getInstance(),
                          for (String name in groupNames)
                            {
                              allGroupNames.remove(name),
                              prefs.remove(name),
                            },
                          prefs.remove('groupNames'),
                          prefs.setStringList('groupNames', allGroupNames),
                        },
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => GroupList())),
                    })
          ]),
        ));
  }
}
