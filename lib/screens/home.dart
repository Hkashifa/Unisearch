import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Unisearch/models/university.dart' show University;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<University>? universities;
  bool boarding = true;

  updateData({String name = "", String country = ""}) {
    setState(() {
      universities = null;
      boarding = false;
    });

    University.getData(name: name, country: country).then((value) {
      setState(() {
        universities = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  //  University.getData();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController();
    final _usertextController = TextEditingController();
    String username = '';
    String university = '';
    University? uni;
    return Scaffold(
      appBar: AppBar(
        title: const Text("UniSearch"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration:
                    const InputDecoration(hintText: "Search by name"),
                    onChanged: (String value) {
                      if (value.length >= 3) {
                        updateData(name: value);
                      }
                    },
                  ),
                ),
              ],
            ),
               Autocomplete<University>(
              optionsBuilder: (TextEditingValue textEditingValue) {
    // Create a list of objects that match the user's input

            return universities!.where((University universities) {
            return universities.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
                           }).toList();
          },
                  onSelected: (University universities) {
    // Save the selected object

                      setState(() {
                              uni = universities;
                            });
                             },
    fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return TextFormField(
    controller: textEditingController,
    focusNode: focusNode,
    decoration: const InputDecoration(

    labelText: 'Select a University',
    border: OutlineInputBorder(),

    ),

    );
    },
    displayStringForOption: (University universities) => universities.name!,
               ),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [



                  const Text('Enter a username ',textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),

                  const Text('Enter password ',textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.all(20.0),
                    child:
                    TextFormField(
                      controller: _usertextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                        setState(() {
                          university = _textController.text;
                          username = _usertextController.text;
                        });


                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  Text(university),
                  Text(username)
                ],
              ),
            ),












            Expanded(
              child: boarding
                  ? const Center(
                   child: Text("To get started, search by name or country."))
                  : universities == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                padding: const EdgeInsets.only(top: 20),
                children: universities!.map((University university) {
                  return  Column(
                      children: [
                        Text(

                          university.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(university.country,style: const TextStyle(color: Colors.black),),

                      ],
                    );

                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
