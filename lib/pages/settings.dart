import 'package:flutter/material.dart';
import 'package:jojo/models/models.dart';
// import 'package:path/path.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../models/database_handler.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class SettingsState extends State<Settings> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Parent parent = Parent();
  List<Child> children = [Child()];
  final DatabaseHandler databaseHandler = DatabaseHandler();
// @override
// void initState(){
//   super.initState();

// }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/robot.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(157, 255, 255, 255),
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: _uiWidget(),
        ),
      ),
    );
  }

  Widget _uiWidget() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FormHelper.inputFieldWidgetWithLabel(
                  context,
                  "firstName",
                  "First Name",
                  "",
                  (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return 'Your first name cant be empty';
                    }
                    return null;
                  },
                  (onSavedVal) {
                    parent.firstName = onSavedVal;
                  },
                  initialValue: parent.firstName ?? "",
                  suffixIcon: const Icon(Icons.group),
                  borderColor: Colors.blueGrey,
                  borderFocusColor: Colors.blueGrey,
                  borderRadius: 25,
                  fontSize: 14,
                  labelFontSize: 14,
                  paddingLeft: 0,
                  paddingRight: 0,
                  contentPadding: 10,
                  validationColor: Colors.greenAccent,
                ),
                FormHelper.inputFieldWidgetWithLabel(
                    context, "lastname", "Last Name", "", (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return 'Your last name cant be empty';
                  }
                  return null;
                }, (onSavedVal) {
                  parent.lastName = onSavedVal;
                },
                    initialValue: parent.lastName ?? "",
                    suffixIcon: const Icon(Icons.group),
                    borderColor: Colors.blueGrey,
                    borderFocusColor: Colors.blueGrey,
                    borderRadius: 25,
                    fontSize: 14,
                    labelFontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    contentPadding: 10,
                    validationColor: Colors.greenAccent),
                _uiChild(),
                Center(
                  child: FormHelper.submitButton(
                    "save",
                    () async {
                      if (validateAndSave()) {
                        // databaseHandler.insertParent(parent);
                        databaseHandler.insertChildren(children);
                        print(parent.toString());
                        print(children.toString());
                        var childrens = await databaseHandler.children();

                        print("-----------");
                        for (var element in childrens) {
                          print(element);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _uiChild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "your children names",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: children.length,
          separatorBuilder: (contex, index) => const Divider(),
          itemBuilder: (context, index) {
            return Column(
              children: [childUi(index)],
            );
          },
        ),
      ],
    );
  }

  Widget childUi(index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: FormHelper.inputFieldWidgetWithLabel(
              context,
              "child_$index",
              "Child Name",
              "",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Child ${index + 1} name cant be empty';
                }
                return null;
              },
              (onSavedVal) {
                children[index].name = onSavedVal;
              },
              initialValue: children[index].name ?? "",
              suffixIcon: const Icon(Icons.group),
              borderColor: Colors.blueGrey,
              borderFocusColor: Colors.blueGrey,
              borderRadius: 25,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              contentPadding: 10,
              validationColor: Colors.greenAccent,
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 30,
                width: 30,
              ),
              Row(
                children: [
                  Visibility(
                    visible: index == children.length - 1,
                    child: SizedBox(
                      width: 35,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.amberAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            children.add(Child());
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: index > 0,
                    child: SizedBox(
                      width: 35,
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            children.removeLast();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
