import 'dart:convert';
import 'dart:io';
import 'dart:math';

class SchoolSystem {
  File file = File('info.json');
  List<Map<String, dynamic>> classes = [];
  Random random = Random();

  schoolData() {
    //loading existing classes from file
    if (file.existsSync()) {
      try {
        String contents = file.readAsStringSync();
        if (contents.isNotEmpty) {
          classes = List<Map<String, dynamic>>.from(jsonDecode(contents));
        }
      } catch (e) {
        print("Error loading file: $e");
      }
    } else {
      print("File not found.");
    }
  }

  void updateFile() {
    String jsonString = jsonEncode(classes);
    file.writeAsStringSync(jsonString);
  }
}

class SchoolClass extends SchoolSystem {
  void createClass(String name) {
    int id = classes.isEmpty ? 1 : classes.last['Id'] + 1;

    Map<String, dynamic> newClass = {
      'Id': id,
      'Name': name,
      'Student': [],
      'Exams': [],
    };

    classes.add(newClass); //method to add the new classes
    updateFile();
    print('id:$id: $name created successfully');
  }

//a  method to edit a class by the name
  void editClass() {
    print('Enter the class id: ');
    int id = int.parse(stdin.readLineSync()!);

    for (var SchoolClass in classes) {
      if (SchoolClass['Id'] == id) {
        print('Enter new name for $id');
        String newName = stdin.readLineSync()!;

        if (newName.isNotEmpty) {
          SchoolClass['Name'] = newName;
          updateFile();
          print('Edited class successfully');
        } else {
          print('Invalid name');
        }
      }
      /* if (!found) {
        print('Class with $id not found');
      } */
    }
  }

  void deleteClass() {
    print('Enter the class id:');
    int id = int.parse(stdin.readLineSync()!);

    for (int i = 0; i < classes.length; i++) {
      if (classes[i]['Id'] == id) {
        classes.removeAt(i);
        updateFile();
        print('class with Id $id deleted successfully');
        return;
      }
    }
  }

  void viewClass() {
    if (classes.isNotEmpty) {
      updateFile();
      print('Available classes are:');
      for (var schoolClass in classes) {
        print('Id:${schoolClass['Id']}, Name: ${schoolClass['Name']}');
      }
    } else {
      print('No classes found');
    }
  }
}
