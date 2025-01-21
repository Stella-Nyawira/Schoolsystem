import 'dart:convert';
import 'dart:io';

import 'package:schoolsystem/schoolsystem.dart';

class Examinations extends SchoolSystem {
  void createExams() {
    schoolData();
    print('Enter the class id to create an exam:');

    for (var schoolClass in classes) {
      print('Id: ${schoolClass['Id']}, Name: ${schoolClass['Name']}');
    }
    int classid = int.parse(stdin.readLineSync()!);

    var schoolClass = classes.where((c) => c['Id'] == classid).toList()[0];

    if (schoolClass['Exams'] == null) {
      schoolClass['Exams'] = [];
    }

    print('Enter the name of the exam');
    String examName = stdin.readLineSync()!;

    int examId =
        schoolClass['Exams'].isEmpty ? 1 : schoolClass['Exams'].last['Id'] + 1;

    Map<String, dynamic> newExam = {
      'Id': examId,
      'Name': examName,
      'Results': [],
    };
    schoolClass['Exams'].add(newExam);
    updateFile();

    while (true) {
      print('Enter the subject name(type "done" to finish):');
      String subjectName = stdin.readLineSync()!;
      if (subjectName.toLowerCase() == "done") {
        break;
      }

      List<Map<String, dynamic>> subjectResults = [];

      for (var student in schoolClass['Student']) {
        print('Enter the student marks for ${student['Name']}:');

        int marks = int.parse(stdin.readLineSync()!);

        if (marks > 100) {
          print('Marks cannot be more than 100.Please enter again.');
        } else {
          Map<String, dynamic> perstudentResults = {
            'Name': student['Name'],
            'Marks': marks,
          };
          subjectResults.add(perstudentResults);
          break;
        }
      }

      Map<String, dynamic> outcome = {
        'Subject': subjectName,
        'Marks': subjectResults,
      };

      schoolClass['Exams'].last['Results'].add(outcome);
    }
    updateFile();
    print('Exam and subject results registered successfully');
  }

  updateExams() {
    schoolData();
    print('Enter the class Id to edit an exam:');
    for (var schoolClass in classes) {
      print('Id: ${schoolClass['Id']}, Name: ${schoolClass['Name']}');
    }
    int classId;
    while (true) {
      try {
        classId = int.parse(stdin.readLineSync()!);
        break;
      } catch (e) {
        print('Please enter a valid integer for Class Id.');
      }
    }

    var schoolClass = classes.where((c) => c['Id'] == classId).toList()[0];

    if (schoolClass['Exams'] == null) {
      schoolClass['Exams'] = [];
    }
    print('Enter the exam ID to edit:');
    int examId = int.parse(stdin.readLineSync()!);
    var exam = schoolClass['Exams']
        .firstWhere((e) => e['Id'] == examId, orElse: () => null);

    if (exam == null) {
      print('Exam with Id $examId not found');
      return;
    }
    print('Enter new name for the exam(or blank to maintain the current):');
    String newName = stdin.readLineSync()!;

    if (newName.isNotEmpty) {
      exam['Name'] = newName;
    }
    //allow user to update subjects and marks
    for (var subject in exam['Results']) {
      print('Updating marks for the subject: ${subject['Subject']}\n');
      for (var studentResult in subject['Marks']) {
        print(
            'Current marks: ${studentResult['Name']} = ${studentResult['Marks']}');
        //ask the user for new marks
        print('Enter new marks for (or press Enter to keep the current marks)');
        String newMarksInput = stdin.readLineSync()!;

        if (newMarksInput.isNotEmpty) {
          try {
            int newMarks = int.parse(newMarksInput);
            studentResult['Marks'] = newMarks;
          } catch (e) {
            print(
                'Invalid marks entered,skipping update for${studentResult['Name']}');
          }
        }
      }
    }
    updateFile();
    print('Exam updated successfully');
  }

  void deleteExam() {
    schoolData();
    print('Enter the class Id to delete an exam:');
    for (var schoolClass in classes) {
      print('Id: ${schoolClass['Id']}, Name: ${schoolClass['Name']}');
    }
    int classId = int.parse(stdin.readLineSync()!);
    var schoolClass = classes.where((c) => c['Id'] == classId).toList()[0];

    if (schoolClass == null) {
      print('Class with Id $classId not found');
      return;
    }
    print('Enter the exam Id to delete');
    int examId = int.parse(stdin.readLineSync()!);

    var exam = schoolClass['Exams']
        .firstWhere((e) => e['Id'] == examId, orElse: () => null);
    if (exam == null) {
      print('Exam with Id $examId not found');
      return;
    }
    schoolClass['Exams'].removeWhere((e) => e['Id'] == examId);
    updateFile();
    print('Exam deleted successfully');
  }

  void viewResults() {
    schoolData();
    print('Select the class Id to view exams:');

    //to display the classes and their id
    for (var schoolClass in classes) {
      print('Id: ${schoolClass['Id']}, Name: ${schoolClass['Name']}');
    }
    int classId = int.parse(stdin.readLineSync()!);
//find the class by id
    var schoolClass = classes.firstWhere((c) => c['Id'] == classId);
    if (schoolClass['Exams'] == null || schoolClass['Exams'].isEmpty) {
      print('No exams found for this class.');
      return;
    }

    //display all available exams
    print('\nAvailable Exams:');
    for (var exam in schoolClass['Exams']) {
      print('Exam ID: ${exam['Id']} - ${exam['Name']}');
    }

    print('\nEnter the exam ID to view details');
    int examId = int.parse(stdin.readLineSync()!);
    //find the exam by id
    var exam = schoolClass['Exams'].firstWhere((e) => e['Id'] == examId);
    //display the exams available.
    print('\nClass: ${schoolClass['Name']}');

    print(
        '--------------------------------------------------------------------------');
    print(
        '\nAdmission No     Name             Eng      Sci     Maths      Mean');
    print(
        '--------------------------------------------------------------------------');

    for (var student in schoolClass['Student']) {
      String resultRow =
          '${'${student['Adm']}'.padRight(13)}  ${'${student['Name']}'.padRight(15)}';

      var englishMarks = 0;
      var scienceMarks = 0;
      var mathsMarks = 0;

      for (var subject in exam['Results']) {
        var studentResult = subject['Marks'].firstWhere(
            (marks) => marks['Name'] == student['Name'],
            orElse: () => null);
        if (studentResult != null) {
          if (subject['Subject'] == 'English') {
            englishMarks = studentResult['Marks'];
          } else if (subject['Subject'] == 'Science') {
            scienceMarks = studentResult['Marks'];
          } else if (subject['Subject'] == 'Mathematics') {
            mathsMarks = studentResult['Marks'];
          }
        }
      }
      //Calculate the mean(average) for the student
      double mean = (englishMarks + scienceMarks + mathsMarks) / 3;

      resultRow +=
          '     ${englishMarks.toString().padRight(7)}  ${scienceMarks.toString().padRight(7)}   ${mathsMarks.toString().padRight(7)}  ${mean.toStringAsFixed(2)}';
      print(resultRow);
    }
  }
}
