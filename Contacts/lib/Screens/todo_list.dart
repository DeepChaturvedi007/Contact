import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list/Models/todo.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:todo_list/Screens/todo_detail_edit.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;
  int is_loading = 1;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    return Scaffold(
      appBar: null,
      body: SafeArea(
              child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: EdgeInsets.only(top: 15, left: 5, right: 10.0, bottom: 20),
                              child: GestureDetector(
                                    onTap: () { moveToLastScreen(); },
                                    child: Text('Back', style: TextStyle(color: Color(0xFF1479f6), fontFamily: 'Roboto', fontSize: 17,)),
                                  ),
                              ),
                      ),
                    Expanded(
                      child: getTodoListView(),
                    ) 
                    ],
              )
            )
      
      
      
    );
  }

  Widget getTodoListView() {
    return 


    
    (this.is_loading == 0) ?
    (this.count > 0) ?
     ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.todoList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.todoList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.todoList[position].description),
           
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.todoList[position], 'Edit Todo');
            },
          ),
        );
      },
    )
    : Center(child: Text("Sorry!, No Records found."))
    :
    Center(child: CircularProgressIndicator());
 
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }
  void _delete(BuildContext context, Todo todo) async {
    //deleteTodo(todo.id);
    
  }

Future<void>  deleteTodo(int id ) async {
        String   idVal = id.toString();
        final http.Response response = await http.delete(
                   'https://samples.field2base.com/apps/contactmanager/api/contactlists/00000000-0000-0000-0000-000000000000/contacts/'+idVal,
           headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
        }
       );
     if (response.statusCode == 200) {
        _showSnackBar(context, 'Contact deleted successfully.');
       updateListView();
        
        } else {
            _showSnackBar(context, 'Error occured while deleting contact.');
        }
        
}

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetailEdit(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

 void moveToLastScreen() {
		Navigator.pop(context, true);
  }

 // Progress indicator widget to show loading.
  Widget loadingView() => Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.red,
        ),
      );

  Future<void> updateListView() async {
    final http.Response response = await http.get(
    'https://samples.field2base.com/apps/contactmanager/api/contactlists/00000000-0000-0000-0000-000000000000/contacts/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }
  );
  if (response.statusCode == 200) {
    List<dynamic> todoMapList = json.decode(response.body);
    List<Todo> todoList = List<Todo>();
		// For loop to create a 'todo List' from a 'Map List'
		for (int i = 0; i < todoMapList.length; i++) {
			todoList.add(Todo.fromMapObject(todoMapList[i]));
		}
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
          this.is_loading = 0;
        });
		//	return;
    //return Todo.fromJson(json.decode(response.body));
  } else {
    setState(() { this.count = 0; this.is_loading = 0;}); 
  }
  }



 
}
