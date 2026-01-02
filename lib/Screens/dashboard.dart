import 'package:ai_resume_scanner/utils/routes/routes_name.dart';
import 'package:ai_resume_scanner/view_model/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String uid;
  final DatabaseReference database =
  FirebaseDatabase.instance.ref('Company');

 // String companyName = "Loading...";

  int totalResumes = 0;
  int shortlisted = 0;
  int rejected = 0;
  int pending = 0;

  List<String> recentActivity = [];

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
      context.read<AuthViewModel>().getCompanyName(uid);
   // getCompanyName();
    setupRealtimeDashboard();
  }


  // void getCompanyName() async {
  //   DatabaseEvent event = await database
  //       .child(uid)
  //       .child('Name')
  //       .child('company')
  //       .once();
  //
  //   if (event.snapshot.exists) {
  //     setState(() {
  //       companyName = event.snapshot.value.toString();
  //     });
  //   }
  // }

  void setupRealtimeDashboard() {
    database.child(uid).child('Candidates').onValue.listen((event) {
      if (event.snapshot.exists) {
        final Map data = event.snapshot.value as Map;

        int total = 0, short = 0, reject = 0, pend = 0;
        List<String> activity = [];

        data.forEach((key, value) {
          total++;
          switch (value['status']) {
            case 'Shortlisted':
              short++;
              activity.add("${value['name']} shortlisted");
              break;
            case 'Rejected':
              reject++;
              activity.add("${value['name']} rejected");
              break;
            default:
              pend++;
              activity.add("${value['name']} uploaded");
          }
        });

        if (activity.length > 5) activity = activity.sublist(activity.length - 5);

        setState(() {
          totalResumes = total;
          shortlisted = short;
          rejected = reject;
          pending = pend;
          recentActivity = activity.reversed.toList();
        });
      } else {
        setState(() {
          totalResumes = 0;
          shortlisted = 0;
          rejected = 0;
          pending = 0;
          recentActivity = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: Text(
          "AI Resume Scanner",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.white,),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, RoutesName.login);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Welcome Back 👋",
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Consumer<AuthViewModel>(builder: (context,name,child){
                    return  Text(
                      name.companyName,
                      style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }),

                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                animatedDashboardCard("Total Resumes", totalResumes, Icons.description, Colors.orange),
                animatedDashboardCard("Shortlisted", shortlisted, Icons.check_circle, Colors.green),
                animatedDashboardCard("Rejected", rejected, Icons.cancel, Colors.red),
                animatedDashboardCard("Pending", pending, Icons.hourglass_bottom, Colors.blue),
              ],
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.upload_file,color: Colors.white,),
                    label: const Text("Upload Resume",style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.uploadScreen);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.people,color: Colors.white,),
                    label: const Text("View Candidates",style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.candidateList);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity
            Text(
              "Recent Activity",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...recentActivity.map((text) => SlideInLeft(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(text),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // Animated Dashboard Card
  Widget animatedDashboardCard(String title, int value, IconData icon, Color color) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              "$value",
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
