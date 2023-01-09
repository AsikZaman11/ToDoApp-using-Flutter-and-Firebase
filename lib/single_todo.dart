import 'package:flutter/material.dart';

class SingleTodo extends StatelessWidget {
  const SingleTodo(
      {super.key,
      required this.todo,
      required this.id,
      required this.delefunction,
      required this.editFunction});
  final String todo;
  final String id;
  final Function delefunction;
  final Function editFunction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                todo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    editFunction(id);
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: () {
                    delefunction(id);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 25,
                    color: Colors.red,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
