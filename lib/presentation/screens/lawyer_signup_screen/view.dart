import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/data/models/lawyerModel.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/main.dart';
import 'package:qanuni/models/lawyerModel.dart';

import '../landing_screen/view.dart';

class LawyerSignupScreen extends StatefulWidget {
  const LawyerSignupScreen({Key? key}) : super(key: key);

  @override
  _LawyerSignupScreenState createState() => _LawyerSignupScreenState();
}

class _LawyerSignupScreenState extends State<LawyerSignupScreen> {
  //Lawyer controllers
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final dOBController = TextEditingController();
  final phoneNumController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final ibanController = TextEditingController();
  final priceController = TextEditingController();
  final bioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //gender
  List<String> itemsList = ['الجنس', 'أنثى', 'ذكر'];
  String selectedItem = 'الجنس';

//INITSTATE
  @override
  void initState() {
    dOBController.text = ""; //set the initial value of text field
    super.initState();
  }

//Email validation
  bool validateEmail(String email) {
    bool isvalid = EmailValidator.validate(email);
    return isvalid;
  }

//is a number validation
  bool isNumericUsingRegularExpression(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

//password visibile or not
  bool passwordVisible = false;

//password validation
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;
    });
  }

  //specialities
  List<String> specialities = [];
  bool isChecked0 = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
  bool isChecked7 = false;

  bool atLeastOneCheckboxSelected() {
    return isChecked0 ||
        isChecked1 ||
        isChecked2 ||
        isChecked3 ||
        isChecked4 ||
        isChecked5 ||
        isChecked6 ||
        isChecked7;
  }

  String textSpec = "";
  void changeTextColor() {
    if (!atLeastOneCheckboxSelected()) {
      setState(() {
        // Change the text color when the button is pressed

        textSpec = " يجب اختيار مجال واحد على الأقل   ";
      });
    } else
      setState(() {
        textSpec = "";
      });
  }

  //Authentication
  final _auth = FirebaseAuth.instance;

  Future<void> createUserWithEmailAndPassword(String email, password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      e.code;
    } catch (_) {}
  }

  //Storing data in Firebase
  final _db = FirebaseFirestore.instance;

  createUser(lawyerModel lawyer) async {
    await _db.collection("lawyers").add(lawyer.toJson());
  }

  //signinUser
  Future<void> signInWithEmailAndPassword(String email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      e.code;
    } catch (_) {}
  }

  //check if email exists
  List<String> emails = [];

  Future<void> fetchEmailsAsync() async {
    final QuerySnapshot querySnapshot = await _db.collection('lawyers').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('email')) {
        final email = data['email'] as String;
        emails.add(email);
      }
    }
    final QuerySnapshot querySnapshot2 = await _db.collection('Clients').get();
    final List<QueryDocumentSnapshot> documents2 = querySnapshot2.docs;

    for (QueryDocumentSnapshot doc in documents2) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('email')) {
        final email = data['email'] as String;
        emails.add(email);
      }
    }
  }

  //check if phone exists
  List<String> phones = [];
  Future<void> fetchPhonesAsync() async {
    final QuerySnapshot querySnapshot = await _db.collection('lawyers').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('phoneNumber')) {
        final phone = data['phoneNumber'] as String;
        phones.add(phone);
      }
    }
  }

  //check if license used before
  List<String> licenses = [];
  Future<void> fetchLicenseNumbersUsedAsync() async {
    final QuerySnapshot querySnapshot = await _db.collection('lawyers').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('licenseNumber')) {
        final license = data['licenseNumber'] as String;
        licenses.add(license);
      }
    }
  }

  List<String> mockLicenses = [];
  Future<void> fetchMockLicenseNumbersAsync() async {
    final QuerySnapshot querySnapshot =
        await _db.collection('lawyer license').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('licenseNumber')) {
        final license = data['licenseNumber'] as String;
        mockLicenses.add(license);
      }
    }
  }

  //phone validation
  bool validatePhoneNum(String phoneNum) {
    bool isvalid = false;
    String phoneNumStr = phoneNum.substring(0, 2);
    if (phoneNumStr == '05' && phoneNum.length == 10) isvalid = true;

    return isvalid && !phoneNum.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 128, 128),
              elevation: 0,
              title: const Text("انشاء حساب جديد",
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              centerTitle: true,
              actions: [
                IconButton(
                  padding: EdgeInsets.only(right: 30),
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous page
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                ' * الأسم الاول',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                    255,
                                    78,
                                    76,
                                    76,
                                  ), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: fNameController,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 0.9,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      fNameController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (value.length > 50)
                                  return ' الرجاء تعبأة الخانة بشكل صحيح';
                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* الأسم الأخير',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                    255,
                                    78,
                                    76,
                                    76,
                                  ), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: lNameController,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 0.9,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      lNameController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (value.length > 50)
                                  return ' الرجاء تعبأة الخانة بشكل صحيح';
                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: Column(children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              '* تاريخ الميلاد',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(
                                    255, 78, 76, 76), // Customize label color
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: dOBController,

                            style: TextStyle(
                                fontSize: 13, height: 1.1, color: Colors.black),
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                suffixIcon: Icon(Icons.calendar_month_rounded)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء تعبأة الخانة';
                              } else if (value.length > 50)
                                return ' الرجاء تعبأة الخانة بشكل صحيح';

                              return null;
                            },
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2007),
                                firstDate: DateTime(1930),
                                lastDate: DateTime(2007),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Colors
                                            .teal, // Change the primary color to teal
                                      ),
                                      textTheme: TextTheme(
                                        headline1: TextStyle(
                                          color: Colors
                                              .teal, // Change the year text color to teal
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  dOBController.text = formattedDate;
                                });
                              }
                            },
                          ),
                        ])),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* رقم الهاتف',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              onTap: () async {
                                print("ontap");
                                await fetchPhonesAsync();
                              },
                              controller: phoneNumController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.1,
                                  color: Colors.black),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                prefixStyle: TextStyle(
                                  color: Color.fromARGB(255, 78, 80, 78),
                                ),
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      phoneNumController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (!validatePhoneNum(value))
                                  return 'الرجاء ادخال رقم هاتف صحيح';
                                else if (!isNumericUsingRegularExpression(
                                    value))
                                  return '(الرجاء تعبأة الخانة بأعداد فقط (من 0-9';
                                else {
                                  if (phones.contains(value))
                                    return 'هذا الرقم مستخدم';
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* البريد الإلكتروني',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              onTap: () async {
                                print("ontap");
                                await fetchEmailsAsync();
                              },
                              controller: emailController,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.1,
                                  color: Colors.black),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: "Example@gmail.com",
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                suffixIcon: Icon(Icons.email),
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      emailController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (value.length > 50)
                                  return ' الرجاء تعبأة الخانة بشكل صحيح';
                                else if (!validateEmail(value))
                                  return '( Example@gmail.com )  الرجاء ادخال بريد الكتروني صحيح';
                                else {
                                  if (emails.contains(value))
                                    return 'هذا البريد الإلكتروني مستخدم';
                                }

                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 5,
                        ),

                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* كلمة المرور',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                  controller: passwordController,
                                  onChanged: (password) =>
                                      onPasswordChanged(password),
                                  obscureText: !passwordVisible,
                                  style: TextStyle(
                                      fontSize: 13,
                                      height: 1.1,
                                      color: Colors.black,
                                      backgroundColor: null),
                                  textAlign: TextAlign.right,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.teal),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                          Icons.clear), // Clear button icon
                                      onPressed: () {
                                        setState(() {
                                          passwordController.clear();
                                        });
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                      icon: passwordVisible
                                          ? Icon(
                                              Icons.visibility,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                            ),
                                    ),
                                    alignLabelWithHint: false,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'الرجاء تعبأة الخانة';
                                    else if (value.length < 8)
                                      return '  الرجاء ادخال 8 خانات و رقم واحد على الأقل';
                                    else if (passwordController.text !=
                                        passwordConfirmController.text)
                                      return "لا يوجد تطابق";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* تأكيد كلمة المرور',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                  controller: passwordConfirmController,
                                  obscureText: !passwordVisible,
                                  style: TextStyle(
                                      fontSize: 13,
                                      height: 1.1,
                                      color: Colors.black,
                                      backgroundColor: null),
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.teal),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                          Icons.clear), // Clear button icon
                                      onPressed: () {
                                        setState(() {
                                          passwordConfirmController.clear();
                                        });
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                      icon: passwordVisible
                                          ? Icon(
                                              Icons.visibility,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                            ),
                                    ),
                                    alignLabelWithHint: false,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'الرجاء تعبأة الخانة';
                                    else if (value.length < 8)
                                      return '  الرجاء ادخال 8 خانات و رقم واحد على الأقل';
                                    else if (passwordController.text !=
                                        passwordConfirmController.text)
                                      return "لا يوجد تطابق";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: _isPasswordEightCharacters
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: _isPasswordEightCharacters
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("تتكون من 8 خانات على الأقل",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromRGBO(
                                              104, 102, 102, 1))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: _hasPasswordOneNumber
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: _hasPasswordOneNumber
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("تحتوي على رقم واحد على الأقل",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromRGBO(
                                              104, 102, 102, 1))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ])),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            '* الجنس ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 78, 76, 76),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              height: 95,
                              padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
                              margin: EdgeInsets.all(2),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                                value: selectedItem,
                                items: itemsList
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromRGBO(
                                                  123, 121, 121, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (item) => setState(
                                    () => selectedItem = item.toString()),
                                validator: (value) {
                                  if (value == "الجنس")
                                    return 'الرجاء تحديد الجنس';
                                  else
                                    return null;
                                },
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),

                        ///////////////LAWYER////////////////
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                "* رقم ترخيص المحاماة",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                    255,
                                    78,
                                    76,
                                    76,
                                  ), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                                onTap: () async {
                                  print("ontap");
                                  await fetchMockLicenseNumbersAsync();
                                  await fetchLicenseNumbersUsedAsync();
                                },
                                controller: licenseNumberController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 13,
                                    height: 1.1,
                                    color: Colors.black),
                                textAlign: TextAlign.right,
                                maxLength: 5,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  prefixIcon: IconButton(
                                    icon:
                                        Icon(Icons.clear), // Clear button icon
                                    onPressed: () {
                                      setState(() {
                                        licenseNumberController.clear();
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء تعبأة الخانة';
                                  } else if (value.length != 5) {
                                    return 'الرجاء ادخال رقم الرخصة بالصيغة الصحيحة';
                                  } else if (!isNumericUsingRegularExpression(
                                      value)) {
                                    return 'الرجاء ادخال رقم الرخصة بالصيغة الصحيحة';
                                  } else if (licenses.contains(value)) {
                                    return "هذا الرقم مستخدم";
                                  }
                                  if (!mockLicenses.contains(value)) {
                                    return 'الرجاء ادخال رقم صحيح ';
                                  }

                                  return null;
                                }),
                          ],
                        )),
                        SizedBox(
                          height: 15,
                        ),

                        //////////////////////////     سكيب خفيف ///////////////////////////
                        Container(
                            height: 289,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
                            margin: EdgeInsets.fromLTRB(2, 2, 2, 9),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(
                                  12), // Set the border radius
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "المجالات التي أود تقديم إستشارات فيها",
                                        style: TextStyle(fontSize: 14.5),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'القانون المدني',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        SizedBox(height: 10),
                                        Checkbox(
                                          activeColor: Colors.teal,
                                          value: isChecked0,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked0 = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          'قانون العمل',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        //SizedBox(height: 10),
                                        Checkbox(
                                          activeColor: Colors.teal,
                                          value: isChecked1,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked1 = value!;
                                            });
                                          },
                                        ),
                                      ]),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'القانون التجاري',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        SizedBox(height: 10),
                                        Checkbox(
                                          activeColor: Colors.teal,
                                          value: isChecked2,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked2 = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'القانون الدولي',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        //SizedBox(height: 10),
                                        Checkbox(
                                          activeColor: Colors.teal,
                                          value: isChecked3,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked3 = value!;
                                            });
                                          },
                                        ),
                                      ]),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "القانون الاداري",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        SizedBox(height: 10),
                                        Checkbox(
                                          activeColor: Colors.teal,
                                          value: isChecked4,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked4 = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          'القانون المواريث',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        //SizedBox(height: 10),
                                        Checkbox(
                                          activeColor: Colors.teal,
                                          value: isChecked5,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked5 = value!;
                                            });
                                          },
                                        ),
                                      ]),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'القانون الجنائي',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Checkbox(
                                          activeColor: Colors.teal,
                                          value: isChecked6,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked6 = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 27,
                                        ),
                                        Text(
                                          'القانون المالي',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        //SizedBox(height: 10),
                                        Checkbox(
                                          activeColor: Colors.teal,
                                          value: isChecked7,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked7 = value!;
                                            });
                                          },
                                        ),
                                      ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 60,
                                      ),
                                      Text(
                                        textSpec,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromARGB(
                                                255, 172, 50, 41)),
                                      ),
                                    ],
                                  ),
                                ])),

                        //////////////////////////     سكيب خفيف ///////////////////////////
                        SizedBox(
                          height: 15,
                        ),

                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                ' * رقم الايبان ',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                    255,
                                    78,
                                    76,
                                    76,
                                  ), // Customize label color
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: ibanController,
                              keyboardType: TextInputType.number,
                              maxLength: 24,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.1,
                                  color: Colors.black),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  prefixIcon: IconButton(
                                    icon:
                                        Icon(Icons.clear), // Clear button icon
                                    onPressed: () {
                                      setState(() {
                                        ibanController.clear();
                                      });
                                    },
                                  ),
                                  prefixText: "SA",
                                  prefixStyle: TextStyle(
                                    color: Color.fromARGB(255, 78, 80, 78),
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (!isNumericUsingRegularExpression(
                                    value))
                                  return '  الرجاء إدخال أرقام فقط';
                                else if (value.length > 27 || value.length < 22)
                                  return 'يجب أن يكون عدد خانات الأيبان من 23-26 خانة';

                                return null;
                              },
                            ),
                          ],
                        )),

                        SizedBox(
                          height: 15,
                        ),

                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                "* سعر جلسة الاستشارة للساعة الواحدة",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                    255,
                                    78,
                                    76,
                                    76,
                                  ), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.1,
                                  color: Colors.black),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      fNameController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (value.length > 50)
                                  return ' الرجاء تعبأة الخانة بشكل صحيح';
                                else if (!isNumericUsingRegularExpression(
                                    value))
                                  return '(الرجاء تعبأة الخانة بأعداد فقط (من 0-9';
                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                " السيرة الذاتية",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                    255,
                                    78,
                                    76,
                                    76,
                                  ), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: bioController,
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.1,
                                  color: Colors.black),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText:
                                    'الخبرات السابقة    ,التعليم    , المهارات',
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      bioController.clear();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 60,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF008080),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  atLeastOneCheckboxSelected()) {
                                //authentication
                                createUserWithEmailAndPassword(
                                    emailController.text.trim(),
                                    passwordController.text.trim());

                                //storing in DB

                                if (isChecked0 == true)
                                  specialities.add("القانون المدني");
                                if (isChecked1 == true)
                                  specialities.add("قانون العمل");
                                if (isChecked2 == true)
                                  specialities.add("القانون التجاري");
                                if (isChecked3 == true)
                                  specialities.add("القانون الدولي");
                                if (isChecked4 == true)
                                  specialities.add("القانون الاداري");
                                if (isChecked5 == true)
                                  specialities.add("قانون المواريث");
                                if (isChecked6 == true)
                                  specialities.add("القانون الجنائي");
                                if (isChecked7 == true)
                                  specialities.add("القانون المالي");

                                final lawyer = lawyerModel(
                                    firstName: fNameController.text.trim(),
                                    lastName: lNameController.text.trim(),
                                    dateOfBirth: dOBController.text.trim(),
                                    email: emailController.text
                                        .toLowerCase()
                                        .trim(),
                                    password: passwordController.text.trim(),
                                    phone: phoneNumController.text.trim(),
                                    gender: selectedItem,
                                    licenseNumber:
                                        licenseNumberController.text.trim(),
                                    iban: "SA" + ibanController.text.trim(),
                                    price: priceController.text.trim(),
                                    specialties: specialities,
                                    bio: bioController.text.trim(),
                                    photoURL:
                                        "https://firebasestorage.googleapis.com/v0/b/qanunidb-8a6fc.appspot.com/o/istockphoto-1337144146-170667a.jpg?alt=media&token=ae33fde0-bbcd-4dd5-b04a-add743b5c8be",
                                    AverageRating: "0.0",
                                    token: "");

                                createUser(lawyer);
                                await signInWithEmailAndPassword(
                                    emailController.text.trim(),
                                    passwordController.text.trim());

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LogoutPageLawyer(),
                                ));

// Replace '/login' with your login screen route

                                //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')),);
                              }
                              if (!atLeastOneCheckboxSelected())
                                changeTextColor();
                              if (atLeastOneCheckboxSelected())
                                changeTextColor();
                            },
                            child: Text('تسجيل'),
                          ),
                        ),
                      ] //children
                      ) //column
                  ), //form
            ) //container
            ));
  }
}
