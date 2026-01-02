import 'dart:io';
import 'package:ai_resume_scanner/data/network/api_service.dart';
import 'package:ai_resume_scanner/data/network/resume_model.dart';
import 'package:ai_resume_scanner/view_model/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'candidate_list_screen.dart';

class UploadResumeScreen extends StatefulWidget {
  const UploadResumeScreen({super.key});

  @override
  State<UploadResumeScreen> createState() => _UploadResumeScreenState();
}

class _UploadResumeScreenState extends State<UploadResumeScreen> {
  final TextEditingController jobDescriptionController = TextEditingController();
  final FilePickerClass filePicker = FilePickerClass();
  final DatabaseReference database = FirebaseDatabase.instance.ref('Company');

  bool isLoading = false;
  String resumeFileName = "No file selected";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Upload Resume",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            Center(
              child: Text(
                "Upload Resumes for AI Analysis",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900),
              ),
            ),
            const SizedBox(height: 30),

            /// Job Description Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: jobDescriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Enter Job Description',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// File Picker Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        resumeFileName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await filePicker.pickFiles();
                        setState(() {
                          resumeFileName = filePicker.resumes.isNotEmpty
                              ? "${filePicker.resumes.length} files selected"
                              : "No file selected";
                        });
                      },
                      child: const Text("Choose Files",style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// Upload & Analyze Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                icon: const Icon(Icons.smart_toy,color: Colors.white,),
                label: const Text(
                  "Upload & Analyze Resumes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                onPressed: isLoading ? null : () async {
                  if (filePicker.resumes.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select at least one resume")),
                    );
                    return;
                  }
                  if (jobDescriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter job description")),
                    );
                    return;
                  }

                  setState(() => isLoading = true);

                  try {
                    // 1️⃣ Analyze resumes
                    ResumeModel result = await ApiService().analyzeMultipleResumes(
                      filePicker.resumes,
                      jobDescriptionController.text,
                    );

                    // 2️⃣ Save candidates in Firebase
                    await saveCandidatesToFirebase(result);

                    // 3️⃣ Navigate to Candidate List Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CandidateListScreen(result: result),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error: $e")));
                  } finally {
                    setState(() => isLoading = false);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),

            /// Loader
            if (isLoading)
              Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      "AI is analyzing resumes...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Save candidates to Firebase with status
  Future<void> saveCandidatesToFirebase(ResumeModel result) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    for (var candidate in result.rankedResumes!) {
      await database.child(uid).child('Candidates').push().set({
        "name": candidate.candidateName ?? "Unknown",
        "score": candidate.score,
        "skills": candidate.skills ?? [],
        "status": candidate.score! >= 50
            ? "Shortlisted"
            : candidate.score! >= 40
            ? "Pending"
            : "Rejected",
        "createdAt": DateTime.now().toIso8601String(),
      });
    }
  }
}
