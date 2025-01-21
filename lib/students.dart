import 'package:schoolsystem/schoolsystem.dart';
import 'dart:io';
import 'dart:math';

class Students extends SchoolSystem {
  void register() {
    String generateAdm() {
      //method to generate admission number.
      int admNumber = 1000 + random.nextInt(5000);
      int year = 2024;
      return '$admNumber/$year';
    }

    String admNumber = generateAdm();

    print('Enter the first name:');
    String firstName = stdin.readLineSync()!;

    print('Enter the last name:');
    String lastName = stdin.readLineSync()!;

    String names = '$firstName $lastName';

    print('Enter gender:\n 1.Female\n 2.Male');
    int choice = int.parse(stdin.readLineSync()!);
    String gender;
    if (choice == 1) {
      gender = 'Female';
    } else if (choice == 2) {
      gender = 'Male';
    } else {
      print('Invalid choice,try again');
      return;
    }
    //viewClass();
    print('Select a class to join by choosing the class Id:');

    for (var schoolClass in classes) {
      print('Id:${schoolClass['Id']}, Name: ${schoolClass['Name']}');
    }

    int selectedId = int.parse(stdin.readLineSync()!);

    for (var schoolClass in classes) {
      if (schoolClass['Id'] == selectedId) {
        Map<dynamic, dynamic> students = {
          'Adm': admNumber,
          'Name': names,
          'Gender': gender,
        };
        schoolClass['Student'].add(students);
        updateFile();
        print('Student registered successfully.');
        return;
      }
    }
    print('Class with Id $selectedId not found');
  }

  void editStudent() {
    print('Enter student admission number to edit');
    String admissionInput = stdin.readLineSync()!;

    for (var schoolClass in classes) {
      //to loop through each class.
      for (var student in schoolClass['Student']) {
        //loop through each student in the class.
        if (student['Adm'] == admissionInput) {
          print('Enter new names for the student');
          print('Enter the first name:');
          String firstName = stdin.readLineSync()!;

          print('Enter the last name:');
          String lastName = stdin.readLineSync()!;

          String names = '$firstName $lastName';

          print('Enter gender:\n 1.Female\n 2.Male');
          int choice = int.parse(stdin.readLineSync()!);
          String gender;
          if (choice == 1) {
            gender = 'Female';
          } else if (choice == 2) {
            gender = 'Male';
          } else {
            print('Invalid choice,try again');
            return;
          }
          student['Name'] = names;
          student['Gender'] = gender;
          updateFile();
          print('Student details updated successfully.');
          return;
        }
      }
    }
  }

  void deleteStudent() {
    print('Enter student admission number to delete');
    String admissionInput = stdin.readLineSync()!;

    for (var schoolClass in classes) {
      schoolClass['Student']
          .removeWhere((student) => student['Adm'] == admissionInput);
    }
    updateFile();
    print('Student with admission number $admissionInput has been deleted');
  }

  void viewStudents() {
    if (classes.isNotEmpty) {
      updateFile();
      for (var schoolClass in classes) {
        print('${schoolClass['Id']}.  ${schoolClass['Name']}');
        print('Admission  Student Name  Student Gender\n');

        for (var student in schoolClass['Student']) {
          print(
              '${student['Adm']},  ${student['Name']},   ${student['Gender']}');
        }
      }
    }
  }
}
