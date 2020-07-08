import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list/Models/todo.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class TodoDetailEdit extends StatefulWidget {

	final String appBarTitle;
	final Todo todo;
  int is_loading = 1;
	TodoDetailEdit(this.todo, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return TodoDetailEditState(this.todo, this.appBarTitle);
  }
}

class TodoDetailEditState extends State<TodoDetailEdit> {

	//static var _priorities = ['High', 'Low'];

	DatabaseHelper helper = DatabaseHelper();
  int is_loading = 1;
	String appBarTitle;
	Todo todo;

	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

	TodoDetailEditState(this.todo, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.title;
     titleController.text = todo.title;
        descriptionController.text = todo.description;
        if(todo.extensions["Phone"] != null){
          phoneController.text = todo.extensions["Phone"];  
        }
       if(todo.extensions["Website"] != null){
          websiteController.text = todo.extensions["Website"];  
        }
        if(todo.extensions["Twitter"] != null){
          twitterController.text = todo.extensions["Twitter"];  
        }
    getContactDetail(todo.id);
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
                  child : Text('Edit Contact', style: TextStyle(color: Color(0xFF000000), fontFamily: 'Roboto', fontSize: 17,)),
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
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    // style: textStyle,
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
                
      
                 Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: twitterController,
                    // style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTwitter();
                    },
                    decoration: InputDecoration(
                      labelText: 'Twitter',
                      // labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller:  phoneController,
                    // style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updatePhone();
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      // labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller:  websiteController,
                    // style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateWebsite();
                      
                    },
                    decoration: InputDecoration(
                      labelText: 'Website',
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
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Center(child:  GestureDetector(
                      onTap: () { setState(() {
                              debugPrint("Save button clicked");
                             _save();
                            }); },
                      child: Text('Save Contact', style: TextStyle(color: Color(0xFF1479f6), fontFamily: 'Roboto', fontSize: 16,)),
                    ),)),
                    Expanded(child: Center(child:  GestureDetector(
                      onTap: () { setState(() {
                              debugPrint("Delete button clicked");
                              deleteTodo();
                            }); },
                      child: Text('Delete Contact', style: TextStyle(color: Color(0xFF1479f6), fontFamily: 'Roboto', fontSize: 16,)),
                    ),)),
    
                    ],
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

      void updateTitle(){
        todo.title = titleController.text;
      }
      void updateTwitter(){
        todo.extensions["Twitter"] = twitterController.text;
      }
      void updateWebsite(){
        todo.extensions["Website"] = websiteController.text;
      }
      void updatePhone(){
        todo.extensions["Phone"] = phoneController.text;
      }

      void updateDescription() {
        todo.description = descriptionController.text;
      }
    
      void _save() async {
    
    
        todo.date = DateFormat.yMMMd().format(DateTime.now());
       
        if (todo.id != null) {  
          updateContact();
        } 
    
       }
    
    void updateContact() async {
        String   idVal = todo.id.toString();
        Map jsonEn = todo.toMapNew();

    final http.Response response = await http.post(
    'https://samples.field2base.com/apps/contactmanager/api/contactlists/00000000-0000-0000-0000-000000000000/contacts/'+idVal,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(jsonEn ),
  );

  if (response.statusCode == 200) {
    	_showAlertDialog('Status', 'Contact updated succesfully');
			return;
    //return Todo.fromJson(json.decode(response.body));
  } else {
    _showAlertDialog('Status', 'Problem saving contact.');
  }
}

    
         

       Future<void>  deleteTodo( ) async {
        String   idVal = todo.id.toString();
        final http.Response response = await http.delete(
                   'https://samples.field2base.com/apps/contactmanager/api/contactlists/00000000-0000-0000-0000-000000000000/contacts/'+idVal,
           headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
        }
       );
     if (response.statusCode == 200) {
         // _showAlertDialog('Status', 'Contact Deleted Successfully.');
           moveToLastScreen();
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
    
      Future<void> getContactDetail(int id) async {
     String   idVal = todo.id.toString();
    final http.Response response = await http.get(
                   'https://samples.field2base.com/apps/contactmanager/api/contactlists/00000000-0000-0000-0000-000000000000/contacts/'+idVal,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }
  );
  if (response.statusCode == 200) {
    dynamic todoMap = json.decode(response.body);
     todo = Todo.fromMapObject(todoMap);
      
        titleController.text = todo.title;
        descriptionController.text = todo.description;
        if(todo.extensions["Phone"] != null){
          phoneController.text = todo.extensions["Phone"];  
        }
       if(todo.extensions["Website"] != null){
          websiteController.text = todo.extensions["Website"];  
        }
        if(todo.extensions["Twitter"] != null){
          twitterController.text = todo.extensions["Twitter"];  
        }
       
  } else {
    
  }



       }

}










