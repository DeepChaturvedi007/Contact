
class Todo {

	int _id;
	String _title;
	String _description;
	String _date;
  dynamic _extensions;
	Todo(this._title, this._date, [this._description] );

	Todo.withId(this._id, this._title, this._date, [this._description]);

	int get id => _id;

	String get title => _title;

	String get description => _description;

	String get date => _date;


  dynamic get extensions => _extensions;

	set title(String newTitle) {
		if (newTitle.length <= 255) {
			this._title = newTitle;
		}
	}
	set description(String newDescription) {
		if (newDescription.length <= 255) {
			this._description = newDescription;
		}
	}

	set extensions(dynamic newExtension) {
		this._extensions = newExtension;
	}

  set date(String newDate) {
		this._date = newDate;
	}
	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _title;
		map['description'] = _description;
		map['date'] = _date;

		return map;
	}

Map<String, dynamic> toMapNew() {

		var map = Map<String, dynamic>();
	  map['name'] = _title;
		map['email'] = _description;
		map['extensions'] = _extensions;

		return map;
	}
	// Extract a Note object from a Map object
	Todo.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._title = map['name'];
		this._description = map['email'];
    if(map['extensions']!= null){
    this._extensions = map['extensions'];
    for (final name in map['extensions'].keys) {
    final value = map['extensions'][name];
    this._extensions[name] = value;
    // prints entries like "AED,3.672940"
  }
    }
		
	}

 // Todo.fromJson(Map<String, dynamic> json)
      
    //     this._id = json['id'];
		// this._title = json['title'];
		// this._description = json['description'];
		// this._date = json['date'];
}









