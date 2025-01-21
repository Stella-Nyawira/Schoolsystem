import 'dart:io';

import 'package:schoolsystem/schoolsystem.dart';
import 'package:schoolsystem/exams.dart';
import 'package:schoolsystem/students.dart';

void main() {
  File file = File('info.json');

  SchoolClass schoolClass = SchoolClass();
  Students students = Students();
  Examinations exams = Examinations();
  // Load the classes from the file when the program starts
  schoolClass.schoolData();
  students.schoolData();

  while (true) {
    print('****Main Menu****\n Choose the options given');
    print(
        '1. Class Management\n2. Student Management\n3. Exam Management\n4. Exit');
    int option = int.parse(stdin.readLineSync()!);
    switch (option) {
      case 1:
        manageClass(schoolClass);
        break;
      case 2:
        manageStudents(students);
        break;
      case 3:
        manageExams(exams);
        break;
      default:
        print('Invalid option.Please try again.');
    }
  }
}

void manageStudents(Students students) {
  print('1. Register Students');
  print('2. Edit student');
  print('3. Delete a student');
  print('4. View students');
  print('5. Exit program');
  int option = int.parse(stdin.readLineSync()!);
  switch (option) {
    case 1:
      print('Student Registration.');
      students.register();
      break;
    case 2:
      students.editStudent();
      break;
    case 3:
      students.deleteStudent();
      break;
    case 4:
      students.viewStudents();
      break;
  }
}

void manageClass(SchoolClass schoolClass) {
  print(
      '\n ***Welcome to managing Classes***\n1. Create class\n2. Edit class\n3. Delete class\n4. View classes\n5.Exit');
  int option = int.parse(stdin.readLineSync()!);
  if (option == 5) {
  } else if (option == 1) {
    print('Enter the class name');
    String className = stdin.readLineSync()!;
    schoolClass.createClass(className);
  } else if (option == 2) {
    schoolClass.editClass();
  } else if (option == 3) {
    schoolClass.deleteClass();
  } else if (option == 4) {
    schoolClass.viewClass();
  }
}

void manageExams(Examinations exams) {
  print(
      '**Welcome to managing Exams**\n1. Create Exam \n2. Update Exam\n3. Delete Exam\n4. View Exam Results\n5. Exit');
  int option = int.parse(stdin.readLineSync()!);
  switch (option) {
    case 1:
      exams.createExams();
      break;
    case 2:
      exams.updateExams();
      break;
    case 3:
      exams.deleteExam();
    case 4:
      exams.viewResults();
  }
}
