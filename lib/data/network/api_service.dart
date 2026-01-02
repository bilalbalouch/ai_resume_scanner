import 'dart:io';
import 'dart:convert';
import 'package:ai_resume_scanner/data/network/resume_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
 /// Upload multiple resumes and get combined ranking
 Future<ResumeModel> analyzeMultipleResumes(
     List<File> files, String description) async {
  var uri = Uri.parse('https://cbafefdfa4b6.ngrok-free.app/analyze-resumes');

  var request = http.MultipartRequest('POST', uri);

  // Add description field
  request.fields['job_description'] = description;

  // Add all files
  for (File file in files) {
   request.files.add(await http.MultipartFile.fromPath(
    'resumes', // Server side field name for multiple files
    file.path,
    filename: file.path.split('/').last,
   ));
  }

  // Send request
  var streamedResponse = await request.send();

  // Convert response to string
  var response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
   // Parse JSON to ResumeModel
   var data = jsonDecode(response.body);
   return ResumeModel.fromJson(data);
  } else {
   throw Exception(
       'Failed to analyze resumes: ${response.statusCode} ${response.reasonPhrase}');
  }
 }
}
