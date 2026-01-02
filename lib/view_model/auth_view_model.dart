import 'package:ai_resume_scanner/utils/routes/routes_name.dart';
import 'package:ai_resume_scanner/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
FirebaseAuth _auth=FirebaseAuth.instance;
DatabaseReference usersData=FirebaseDatabase.instance.ref('Company');

class AuthViewModel extends ChangeNotifier{
  String companyName='Loading';
  bool isLoading=false;

  void setLoading(bool value){
    isLoading=value;
    notifyListeners();
  }
  Future<void> login(String email,String password,BuildContext context)async{
    setLoading(true);
    _auth.signInWithEmailAndPassword(email: email, password: password).then((value){
      setLoading(false);
      Navigator.pushReplacementNamed(context, RoutesName.dashboard);
    }).onError((error,stackTrace){
      setLoading(false);
      Utils.flushBarMessage(error.toString(), context);

    });
  }
  Future<void> register(String email,String password,String name,String companyName,BuildContext context)async{
    setLoading(true);
    _auth.createUserWithEmailAndPassword(email: email, password: password).then((value)async{
      setLoading(false);
       final uid=value.user!.uid;

      await usersData.child(uid).child('Name').set({
        'id':uid,
        'name':name,
        'company':companyName
      }).then((value){
        Utils.flushBarMessage('Account Created Successfully', context);
      }).onError((error,stackTrace){
        Utils.flushBarMessage(error.toString(), context);
      });

      Navigator.pushReplacementNamed(context, RoutesName.dashboard);

    }).onError((error,stackTrace){
      setLoading(false);
      Utils.flushBarMessage(error.toString(), context);

    });
  }
  Future<void> resetPassword(String _emailController,BuildContext context) async {
    setLoading(true);
    if (_emailController.trim().isEmpty) {
      setLoading(false);
      Utils.flushBarMessage('Enter email address', context);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(
        email: _emailController.trim(),
      );
      setLoading(false);

      Utils.flushBarMessage("Email send Successfully", context);
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      Utils.flushBarMessage(e.toString(), context);
    }
  }
  Future<String?> getCompanyName(String uid) async {
    try {
      DatabaseEvent event = await usersData
          .child(uid)
          .child('Name')
          .child('company')
          .once();

      if (event.snapshot.exists && event.snapshot.value != null) {
        return companyName=event.snapshot.value.toString();
      } else {
        return null; // company not found
      }
    } catch (e) {
      debugPrint("Error getting company name: $e");
      return null; // in case of any error
    }
  }

}