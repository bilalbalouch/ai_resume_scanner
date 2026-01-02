import 'package:ai_resume_scanner/Component/round_button.dart';
import 'package:ai_resume_scanner/constant/my_colors.dart';
import 'package:ai_resume_scanner/utils/routes/routes_name.dart';
import 'package:ai_resume_scanner/utils/utils.dart';
import 'package:ai_resume_scanner/view_model/auth_view_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController=TextEditingController();
TextEditingController companyNameController=TextEditingController();

final _formKey = GlobalKey<FormState>();
final ValueNotifier<bool> hidePassword = ValueNotifier(false);
final ValueNotifier<bool> buttonCheck = ValueNotifier(false);

FocusNode emailFocusNode = FocusNode();
FocusNode passwordFocusNode = FocusNode();
FocusNode nameFocusNode=FocusNode();
FocusNode companyNameFocusNode=FocusNode();
var firebaseDatabase=FirebaseDatabase.instance.ref('Company');



late AnimationController _controller;
late Animation<double> _fadeAnimation;
late Animation<Offset> _slideAnimation;

@override
void initState() {
  super.initState();

  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );

  _slideAnimation = Tween<Offset>(
    begin: const Offset(0, 0.25),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );

  _controller.reset();
  _controller.forward();
}


@override
void dispose() {
  _controller.dispose();
  emailController.dispose();
  passwordController.dispose();
  nameController.dispose();
  companyNameController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  final myHeight = MediaQuery.of(context).size.height;
  final myWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    backgroundColor: Colors.teal.shade900,
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: myHeight*0.05,),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                    'Ai Resume Scanner',
                    textStyle: textHeadingStyle,
                    colors: colorizedColors)
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),

            SizedBox(height: myHeight * 0.01),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      child: Container(
                        height: myHeight * 0.75,
                        width: myWidth * 0.85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///Name
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: TextFormField(
                                  controller: nameController,
                                  focusNode: nameFocusNode,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Full Name';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => checkButtonState(),
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      hintText: 'Enter Full Name',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2),
                      
                                      ),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2))
                                  ),
                                  onFieldSubmitted: (value){
                                    Utils.focusChange(context, nameFocusNode, companyNameFocusNode);
                                  },
                                ),
                              ),
                              //CompanyName
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: TextFormField(
                                  controller: companyNameController,
                                  focusNode: companyNameFocusNode,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Company Name';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => checkButtonState(),
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email_outlined),
                                      hintText: 'Enter Company Name',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2),
                      
                                      ),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2))
                                  ),
                                  onFieldSubmitted: (value){
                                    Utils.focusChange(context, companyNameFocusNode, emailFocusNode);
                                  },
                                ),
                              ),
                      
                              /// EMAIL
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: TextFormField(
                                  controller: emailController,
                                  focusNode: emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter email';
                                    } else if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => checkButtonState(),
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email_outlined),
                                      hintText: 'Email',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2),
                      
                                      ),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2))
                                  ),
                                  onFieldSubmitted: (value){
                                    Utils.focusChange(context, emailFocusNode, passwordFocusNode);
                                  },
                                ),
                              ),
                      
                              /// PASSWORD
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: ValueListenableBuilder(
                                  valueListenable: hidePassword,
                                  builder: (context, value, child) {
                                    return TextFormField(
                                      controller: passwordController,
                                      focusNode: passwordFocusNode,
                                      obscureText: hidePassword.value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter Password';
                                        } else if (value.length < 6) {
                                          return 'Password must be 6 characters';
                                        }
                                        return null;
                                      },
                                      onChanged: (_) => checkButtonState(),
                                      decoration: InputDecoration(
                                          prefixIcon:
                                          const Icon(Icons.lock_outline),
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              hidePassword.value =
                                              !hidePassword.value;
                                            },
                                            child: Icon(
                                              hidePassword.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          ),
                                          hintText: 'Password',
                                          border: const OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2))
                                      ),
                                      onFieldSubmitted: (value) {
                                        Utils.focusChange(
                                          context,
                                          emailFocusNode,
                                          passwordFocusNode,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                      
                              /// BUTTON
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: ValueListenableBuilder(
                                  valueListenable: buttonCheck,
                                  builder: (context, value, child) {
                                    return RoundButton(
                                      color: value ? myColor : Colors.black12,
                                      title: 'Sign Up',
                                      onPress: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthViewModel>().register(
                                              emailController.text,
                                              passwordController.text,
                                              nameController.text,
                                              companyNameController.text,
                                              context);

                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                      
                              /// SIGN UP
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("If you have an account "),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pushNamed(context, RoutesName.login);
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                            color: myColor, fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void checkButtonState() {
  buttonCheck.value =
      emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
}

}