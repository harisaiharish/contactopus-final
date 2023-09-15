import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void showPopup(BuildContext context, String data, int n) {
  var allFields = data.split(",");
  var str = allFields[3] + "'s contact?";
  if (n > 1) {
    str = "all contacts?";
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Save " + str),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            onPressed: () async {
              var temp = data.split(",new,");
              if (n > 1) {
                for (int i = 1; i <= n; i++) {
                  var fields = temp[i].split(",");
                  saveContactInPhone(context, fields);
                }
              } else {
                var fields = temp[1].split(",");
                saveContactInPhone(context, fields);
              }
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> saveContactInPhone(
    BuildContext context, List<String> allFields) async {
  String dname = "";
  String fname = "";
  String lname = "";
  String comp = "";
  String dept = "";
  String title = "";
  String notes = "";
  List<String> websites = [];
  List<String> addresses = [];
  List<String> addresstype = [];
  List<String> socmed = [];
  List<String> media = [];
  List<String> numbers = [];
  List<String> labels = [];
  List<String> mails = [];
  List<String> mailtype = [];
  for (int i = 0; i < allFields.length; i = i + 2) {
    switch (allFields[i]) {
      case ' d':
      case 'd':
        dname = allFields[i + 1];
        break;
      case 'f':
        fname = allFields[i + 1];
        break;
      case 'l':
        lname = allFields[i + 1];
        break;
      case 'c':
        comp = allFields[i + 1];
        dept = allFields[i + 2];
        title = allFields[i + 3];
        i++;
        i++;
        break;
      case 'p':
        numbers.add(allFields[i + 1]);
        labels.add(allFields[i + 2]);
        i++;
        break;
      case 'm':
        mails.add(allFields[i + 1]);
        mailtype.add(allFields[i + 2]);
        i++;
        break;
      case 's':
        socmed.add(allFields[i + 1]);
        media.add(allFields[i + 2]);
        i++;
        break;
      case 'a':
        addresses.add(allFields[i + 1]);
        addresstype.add(allFields[i + 2]);
        i++;
        break;
      case "w":
        websites.add(allFields[i + 1]);
        break;
      case "n":
        notes = allFields[i + 1];
        break;
      default:
        break;
    }
  }
  try {
    if (await FlutterContacts.requestPermission()) {
      Contact newContact = Contact();
      newContact.displayName = dname;
      newContact.name.first = fname;
      newContact.name.last = lname;

      newContact.notes.add(Note(notes));
      newContact.organizations
          .add(Organization(company: comp, department: dept, title: title));
      for (int i = 0; i < websites.length; i++) {
        newContact.websites.add(Website(websites[i]));
      }

      for (int i = 0; i < numbers.length; i++) {
        switch (labels[i]) {
          case "mobile":
            newContact.phones.add(Phone(numbers[i], label: PhoneLabel.mobile));
            break;
          case "home":
            newContact.phones.add(Phone(numbers[i], label: PhoneLabel.home));
            break;
          case "work":
            newContact.phones.add(Phone(numbers[i], label: PhoneLabel.work));
            break;
          case "faxWork":
            newContact.phones.add(Phone(numbers[i], label: PhoneLabel.faxWork));
            break;
          case "faxHome":
            newContact.phones.add(Phone(numbers[i], label: PhoneLabel.faxHome));
            break;
          case "pager":
            newContact.phones.add(Phone(numbers[i], label: PhoneLabel.pager));
            break;
          case "none":
            newContact.phones.add(Phone(numbers[i]));
            break;
          default:
            newContact.phones.add(Phone(numbers[i],
                customLabel: labels[i], label: PhoneLabel.custom));
            break;
        }
      }

      for (int i = 0; i < mails.length; i++) {
        switch (mailtype[i]) {
          case "home":
            newContact.emails.add(Email(mails[i], label: EmailLabel.home));
            break;
          case "work":
            newContact.emails.add(Email(mails[i], label: EmailLabel.work));
            break;
          case "mobile":
            newContact.emails.add(Email(mails[i], label: EmailLabel.mobile));
            break;
          case "none":
            newContact.emails.add(Email(mails[i]));
            break;
          default:
            newContact.emails.add(Email(mails[i],
                customLabel: mailtype[i], label: EmailLabel.custom));
            break;
        }
      }

      for (int i = 0; i < socmed.length; i++) {
        switch (media[i]) {
          case "linkedIn":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.linkedIn));
            break;
          case "instagram":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.instagram));
            break;
          case "facebook":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.facebook));
            break;
          case "twitter":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.twitter));
            break;
          case "snapchat":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.snapchat));
            break;
          case "discord":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.discord));
            break;
          case "tiktok":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.tikTok));
            break;
          case "reddit":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.reddit));
            break;
          case "skype":
            newContact.socialMedias
                .add(SocialMedia(socmed[i], label: SocialMediaLabel.skype));
            break;
          case "none":
            newContact.socialMedias.add(SocialMedia(socmed[i]));
            break;
          default:
            newContact.socialMedias.add(SocialMedia(socmed[i],
                customLabel: media[i], label: SocialMediaLabel.custom));
            break;
        }
      }

      for (int i = 0; i < addresses.length; i++) {
        switch (addresstype[i]) {
          case "home":
            newContact.addresses
                .add(Address(addresses[i], label: AddressLabel.home));
            break;
          case "work":
            newContact.addresses
                .add(Address(addresses[i], label: AddressLabel.work));
            break;
          case "school":
            newContact.addresses
                .add(Address(addresses[i], label: AddressLabel.school));
            break;
          case "none":
            newContact.addresses.add(Address(addresses[i]));
            break;
          default:
            newContact.addresses.add(Address(addresses[i],
                customLabel: addresstype[i], label: AddressLabel.custom));
            break;
        }
      }
      Contact c1 = await newContact.insert();
      await FlutterContacts.openExternalEdit(c1.id);
    }
  } catch (e) {}
}
