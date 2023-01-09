import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/single_todo.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final _textField = TextEditingController();
  final _todoUpdate = TextEditingController();

  Future<void> _addtodo() async {
    if (_textField.text.length <= 0) {
      return;
    }

    final collucrin = FirebaseFirestore.instance.collection("todo");

    await collucrin.add({
      "title": _textField.text,
    });

    _textField.text = '';
    Navigator.of(context).pop();
  }

  Future<void> _deletetodo(String id) async {
    try {
      final collucrin = FirebaseFirestore.instance.collection("todo").doc(id);
      await collucrin.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updatetodo(String id) async {
    String updateText = _todoUpdate.text;
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("todo").doc(id);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        // DocumentSnapshot documentSnapshot =
        await transaction.get(documentReference);
        transaction.update(documentReference, {
          'title': updateText,
        });
      });
      Navigator.of(context).pop();
      _todoUpdate.text = '';
    } catch (e) {}
  }

  Future<void> _editButton(String id) async {
    final collucrin = FirebaseFirestore.instance.collection("todo").doc(id);
    await collucrin.get().then((value) {
      _todoUpdate.text = value['title'];
    });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("UPDATE TO-DO"),
            content: TextField(
              controller: _todoUpdate,
              decoration: InputDecoration(
                hintText: "UPDATE YOUR TO-DO",
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("CANCLE"),
              ),
              ElevatedButton(
                onPressed: () {
                  _updatetodo(id);
                },
                child: Text("UPDATE"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO-DO-APP"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("todo").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("NO DATA FOUND !"),
            );
          }
          return ListView(
            children: snapshot.data!.docs
                .map(
                  (todoData) => SingleTodo(
                    todo: todoData['title'],
                    id: todoData.id,
                    delefunction: _deletetodo,
                    editFunction: _editButton,
                  ),
                )
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("ADD TO-DO"),
                  content: TextField(
                    controller: _textField,
                    decoration: InputDecoration(
                      hintText: "ADD A TO-DO",
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("CANCLE"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _addtodo();
                      },
                      child: Text("ADD"),
                    )
                  ],
                );
              });
        },
      ),
    );
  }
}
