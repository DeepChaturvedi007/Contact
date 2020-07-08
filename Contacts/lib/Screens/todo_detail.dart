import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list/Models/todo.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class TodoDetail extends StatefulWidget {

	final String appBarTitle;
	final Todo todo;

	TodoDetail(this.todo, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return TodoDetailState(this.todo, this.appBarTitle);
  }
}

class TodoDetailState extends State<TodoDetail> {

	//static var _priorities = ['High', 'Low'];

	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Todo todo;

	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();

	TodoDetailState(this.todo, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.title;

		titleController.text = todo.title;
		descriptionController.text = todo.description;

    return WillPopScope(

	    onWillPop: () {
	    	// Write some code to control things, when user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: null,
	    body: Padding(
		    padding: EdgeInsets.only(top: 0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[
				    // Second Element
            Padding(padding: EdgeInsets.only(top: 15, left: 0, right: 10.0, bottom: 20),
            child: GestureDetector(
                  onTap: () { moveToLastScreen(); },
                  child: Text('Back', style: TextStyle(color: Color(0xFF1479f6), fontFamily: 'Roboto', fontSize: 17,)),
                ),
            ),
            Center(
              child: Padding(padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 20.0),
              child : Text('Add New Contact', style: TextStyle(color: Color(0xFF000000), fontFamily: 'Roboto', fontSize: 18,)),
              ),
            ),
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: titleController,
						    // style: textStyle,
						    onChanged: (value) {
						    	debugPrint('Something changed in Title Text Field');
						    	updateTitle();
						    },
						    decoration: InputDecoration(
							    labelText: 'Name',
							    // labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
					    ),
				    ),

				    // Third Element
				    Padding( // style: textStyle,
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: descriptionController,
						   
						    onChanged: (value) {
							    debugPrint('Something changed in email field');
							    updateDescription();
						    },
						    decoration: InputDecoration(
								    labelText: 'Email Address',
								    // labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(5.0)
								    )
						    ),
					    ),
				    ),

				    // Fourth Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Center(
              child: Padding(padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 20.0),
              child : GestureDetector(
                  onTap: () { setState(() {
									    	  debugPrint("Save button clicked");
									    	  _save();
									    	}); },
                  child: Text('Add Contact', style: TextStyle(color: Color(0xFF1479f6), fontFamily: 'Roboto', fontSize: 16,)),
                ),
              ),
            ),
              
              
				    ),


			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }
	// Update the title of todo object
  void updateTitle(){
    todo.title = titleController.text;
  }

	// Update the description of todo object
	void updateDescription() {
		todo.description = descriptionController.text;
	}



void crateContact(String name , String email) async {
  final http.Response response = await http.post(
    'https://samples.field2base.com/apps/contactmanager/api/contactlists/00000000-0000-0000-0000-000000000000/contacts/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      	"name": name,
		    "email": email
    }),
  );

  if (response.statusCode == 200) {
    	_showAlertDialog('Status', 'Contact created succesfully');
			return;
    //return Todo.fromJson(json.decode(response.body));
  } else {
    _showAlertDialog('Status', 'Problem saving contact.');
  }
}



	// Save data to database
	void _save() async {
    crateContact(todo.title , todo.description);
		moveToLastScreen();

	}


	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW todo i.e. he has come to
		// the detail page by pressing the FAB of todoList page.
		if (todo.id == null) {
			_showAlertDialog('Status', 'No contact was deleted.');
			return;
		}

		// Case 2: User is trying to delete the old todo that already has a valid ID.
		int result = await helper.deleteTodo(todo.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Contact Deleted Successfully.');
		} else {
			_showAlertDialog('Status', 'Error occured while deleting contact.');
		}
	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

}










