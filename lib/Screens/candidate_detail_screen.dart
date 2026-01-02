import 'package:ai_resume_scanner/constant/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/network/resume_model.dart';

class CandidateDetailScreen extends StatelessWidget {
  final RankedResumes candidate;

  const CandidateDetailScreen({super.key, required this.candidate});

  /// Open Gmail / Email app
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Regarding your application',
      },
    );

    if (!await launchUrl(
      emailUri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('Could not open email app');
    }
  }

  /// Open Resume in Browser / PDF viewer
  Future<void> _launchResumeUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('Could not open resume URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(candidate.candidateName ?? "Candidate Details",style: TextStyle(color: Colors.white),),
        backgroundColor: myColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  candidate.candidateName ?? "Unknown",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Rank & Score
                Text("Rank: ${candidate.rank ?? "N/A"}"),
                Text("Score: ${candidate.score ?? "N/A"}%"),
                const SizedBox(height: 12),

                // Skills
                Text(
                  "Skills: ${candidate.skills?.join(', ') ?? 'N/A'}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Email (Clickable)
                if (candidate.email != null &&
                    candidate.email!.isNotEmpty)
                  InkWell(
                    onTap: () => _launchEmail(candidate.email!),
                    child: Row(
                      children: [
                        const Icon(Icons.email, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          candidate.email!,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Resume Button
                if (candidate.resumeUrl != null &&
                    candidate.resumeUrl!.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("View Resume"),
                      onPressed: () =>
                          _launchResumeUrl(candidate.resumeUrl!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
