import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerClass {
   // List to store picked PDF files
   List<File> _resumes = [];

   // Getter to access picked files
   List<File> get resumes => _resumes;

   // Function to pick multiple PDF files
   Future<void> pickFiles() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
         allowMultiple: true,
         type: FileType.custom,
         allowedExtensions: ['pdf'], // optional: only allow PDFs
      );

      if (result != null) {
         // Convert picked file paths to File objects
         _resumes = result.paths.map((path) => File(path!)).toList();
      } else {
         // User canceled the picker
         _resumes = [];
      }
   }
}
