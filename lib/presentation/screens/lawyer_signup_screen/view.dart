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

//DOB
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

//iban validation
  bool validateIban(String iban) {
    bool isvalid = false;
    String ibanStr = iban.substring(0, 2).toLowerCase();
    String ibanStr2 = iban.substring(2);
    if (ibanStr == "sa" && isNumericUsingRegularExpression(ibanStr2))
      isvalid = true;

    return isvalid;
  }

//phone validation
  bool validatePhoneNum(String phoneNum) {
    bool isvalid = false;
    String phoneNumStr = phoneNum.substring(0, 2);
    if (phoneNumStr == '05' && phoneNum.length == 10) isvalid = true;

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
  bool otherIsChecked = false;

  bool atLeastOneCheckboxSelected() {
    return isChecked0 ||
        isChecked1 ||
        isChecked2 ||
        isChecked3 ||
        isChecked4 ||
        otherIsChecked;
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

    final QuerySnapshot querySnapshot2 = await _db.collection('Clients').get();
    final List<QueryDocumentSnapshot> documents2 = querySnapshot2.docs;

    for (QueryDocumentSnapshot doc in documents2) {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 128, 128),
              elevation: 0,
              title: const Text("انشاء حساب جديد", 
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500, color: Colors.white)
              ),
              centerTitle: true,
            actions: [
            IconButton(
              padding: EdgeInsets.only(right: 30),
              alignment: Alignment.centerRight,
              icon: Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
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
                    TextFormField(
                      controller: fNameController,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "الأسم الأول",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تعبأة الخانة';
                        } else if (value.length > 50)
                          return ' الرجاء تعبأة الخانة بشكل صحيح';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: lNameController,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "الأسم الأخير",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تعبأة الخانة';
                        } else if (value.length > 50)
                          return ' الرجاء تعبأة الخانة بشكل صحيح';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
Container(
  child: TextFormField(
    controller: dOBController,
    style: TextStyle(
      fontSize: 13,
      height: 1.1,
      color: Colors.black,
    ),
    textAlign: TextAlign.right,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintStyle: TextStyle(color: Colors.grey[800]),
      hintText: "تاريخ الميلاد",
      prefixIcon: Icon(Icons.calendar_month_rounded),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'الرجاء تعبأة الخانة';
      } else if (value.length > 50) {
        return 'الرجاء تعبأة الخانة بشكل صحيح';
      }
      return null;
    },
    readOnly: true,
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1930),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.teal, // Change the primary color to teal
              ),
              textTheme: TextTheme(
                headline1: TextStyle(
                  color: Colors.teal, // Change the year text color to teal
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        setState(() {
          dOBController.text = formattedDate;
        });
      }
    },
  ),
),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onTap: () async {
                        print("ontap");
                        await fetchPhonesAsync();
                      },
                      controller: phoneNumController,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: ' (05x xxxx xxx) رقم الهاتف',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تعبأة الخانة';
                        } else if (!validatePhoneNum(value))
                          return 'الرجاء ادخال رقم هاتف صحيح';
                        else if (!isNumericUsingRegularExpression(value))
                          return '(الرجاء تعبأة الخانة بأعداد فقط (من 0-9';
                        else {
                          if (phones.contains(value)) return 'هذا الرقم مستخدم';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: emailController,
                      onTap: () async {
                        print("ontap");
                        await fetchEmailsAsync();
                      },
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: '(example@example.com) البريد الالكتروني',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تعبأة الخانة';
                        } else if (value.length > 50)
                          return ' الرجاء تعبأة الخانة بشكل صحيح';
                        else if (!validateEmail(value))
                          return 'الرجاء ادخال بريد الكتروني صحيح';
                        else {
                          if (emails.contains(value))
                            return 'هذا البريد الإلكتروني مستخدم';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: TextFormField(
                          controller: passwordController,
                          onChanged: (password) => onPasswordChanged(password),
                          obscureText: !passwordVisible,
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.1,
                              color: Colors.black,
                              backgroundColor: null),
                          textAlign: TextAlign.right,
                           maxLength: 20,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'كلمة المرور',
                            //hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: IconButton(
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: TextFormField(
                          controller: passwordConfirmController,
                          onChanged: (password) => onPasswordChanged(password),
                          obscureText: !passwordVisible,
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.1,
                              color: Colors.black,
                              backgroundColor: null),
                          textAlign: TextAlign.right,
                           maxLength: 20,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'تأكيد كلمة المرور',
                            //hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: IconButton(
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedContainer(
                                alignment: Alignment.topRight,
                                duration: Duration(milliseconds: 500),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                    color: _isPasswordEightCharacters
                                        ? Colors.green
                                        : Colors.transparent,
                                    border: _isPasswordEightCharacters
                                        ? Border.all(color: Colors.transparent)
                                        : Border.all(
                                            color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(50)),
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
                              Text("تتكون من 8 خانات على الأقل",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(104, 102, 102, 1)))
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
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                    color: _hasPasswordOneNumber
                                        ? Colors.green
                                        : Colors.transparent,
                                    border: _hasPasswordOneNumber
                                        ? Border.all(color: Colors.transparent)
                                        : Border.all(
                                            color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(50)),
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
                                      fontSize: 12,
                                      color: Color.fromRGBO(104, 102, 102, 1)))
                            ],
                          ),
                        ])),
                    SizedBox(
                      height: 17,
                    ),
                    Align(
                      alignment: Alignment
                          .centerRight, // Align the FractionallySizedBox to the right
                      child: FractionallySizedBox(
                        widthFactor: 1, // Set to 50% of the screen width
                        child: Container(
                          height: 95,
                          padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
                          margin: EdgeInsets.all(2),
                          /*decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1.7,
                              color: Color.fromARGB(71, 32, 31, 31)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),*/
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                            value: selectedItem,
                            items: itemsList
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Align(
                                      alignment: Alignment
                                          .centerRight, // Right-align the text
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromRGBO(123, 121, 121, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (item) =>
                                setState(() => selectedItem = item.toString()),
                            validator: (value) {
                              if (value == "الجنس")
                                return 'الرجاء تحديد الجنس';
                              else
                                return null;
                            },
                            // Set the maximum dropdown menu height
                            isExpanded:
                                true, // Expand the dropdown to the maximum width
                          ),
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
                        style: TextStyle(
                            fontSize: 13, height: 1.1, color: Colors.black),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "رقم ترخيص المحاماة",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء تعبأة الخانة';
                          } else if (value.length != 5) {
                            return 'الرجاء ادخال رقم الرخصة بالصيغة الصحيحة';
                          } else if (!isNumericUsingRegularExpression(value)) {
                            return 'الرجاء ادخال رقم الرخصة بالصيغة الصحيحة';
                          } else if (licenses.contains(value)) {
                            return "هذا الرقم مستخدم";
                          }
                          if (!mockLicenses.contains(value)) {
                            return 'الرجاء ادخال رقم صحيح ';
                          }

                          return null;
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        height: 100,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
                        margin: EdgeInsets.fromLTRB(2, 2, 2, 9),
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1.7,
                              color: Color.fromARGB(71, 32, 31, 31)),
                          borderRadius: BorderRadius.circular(15),
                        )),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    " المجالات التي أود تقديم إستشارات فيها",
                                    style: TextStyle(fontSize: 13.5),
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    // Text(
                                    //   'أخرى',
                                    //   style: TextStyle(fontSize: 13),
                                    // ),
                                    // SizedBox(height: 10),
                                    // Checkbox(
                                    //   activeColor: Color(0xFF008080),
                                    //   value: otherIsChecked,
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       otherIsChecked = value!;
                                    //     });
                                    //   },
                                    // ),
                                    // SizedBox(
                                    //   width: 20,
                                    // ),
                                    // Text(
                                    //   'جنائي',
                                    //   style: TextStyle(fontSize: 13),
                                    // ),
                                    // //SizedBox(height: 10),
                                    // Checkbox(
                                    //   activeColor: Color(0xFF008080),
                                    //   value: isChecked0,
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       isChecked0 = value!;
                                    //     });
                                    //   },
                                    // ),
                                    // SizedBox(
                                    //   width: 20,
                                    //),
                                    Text(
                                      'مواريث',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    // SizedBox(height: 10),
                                    Checkbox(
                                      activeColor: Color(0xFF008080),
                                      value: isChecked1,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked1 = value!;
                                        });
                                      },
                                    ),
                                    // SizedBox(
                                    //   width: 20,
                                    // ),
                                    Text(
                                      'إداري',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    // SizedBox(height: 10),
                                    Checkbox(
                                      activeColor: Color(0xFF008080),
                                      value: isChecked2,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked2 = value!;
                                        });
                                      },
                                    ),
                                    // SizedBox(
                                    //   width: 20,
                                    // ),
                                    Text(
                                      'مدني',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    // SizedBox(height: 10),
                                    Checkbox(
                                      activeColor: Color(0xFF008080),
                                      value: isChecked3,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked3 = value!;
                                        });
                                      },
                                    ),
                                    // SizedBox(
                                    //   width: 20,
                                    // ),
                                    Text(
                                      'تجاري',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    //SizedBox(height: 10),
                                    Checkbox(
                                      activeColor: Color(0xFF008080),
                                      value: isChecked4,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked4 = value!;
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
                            ]
                          )
                        ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: ibanController,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "(SA __________ )  رقم الأيبان",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تعبأة الخانة';
                        } else if (value.length > 27 || value.length < 22)
                          return 'يجب أن يكون عدد خانات الأيبان من 23-26 خانة';
                        else if (!validateIban(value))
                          return ' (SA _______  )  الرجاء إدخال رقم ايبان صحيح';

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: priceController,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "حدد/ي سعر جلسة الاستشارة للساعة الواحدة",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تعبأة الخانة';
                        } else if (value.length > 50)
                          return ' الرجاء تعبأة الخانة بشكل صحيح';
                        else if (!isNumericUsingRegularExpression(value))
                          return '(الرجاء تعبأة الخانة بأعداد فقط (من 0-9';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: bioController,
                      keyboardType: TextInputType.multiline,
                      minLines: 3, //Normal textInputField will be displayed
                      maxLines: 5,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText:
                            "(الخبرات السابقة ,التعليم, المهارات)  السيرة الذاتية",
                      ),
                    ),
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

                            if (isChecked0 == true) specialities.add("جنائي");
                            if (isChecked1 == true) specialities.add("مواريث");
                            if (isChecked2 == true) specialities.add("إداري");
                            if (isChecked3 == true) specialities.add("مدني");
                            if (isChecked4 == true) specialities.add("تجاري");
                            if (otherIsChecked == true)
                              specialities.add("أخرى");

                            final lawyer = lawyerModel(
                                firstName: fNameController.text.trim(),
                                lastName: lNameController.text.trim(),
                                dateOfBirth: dOBController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                phone: phoneNumController.text.trim(),
                                gender: selectedItem,
                                licenseNumber:
                                    licenseNumberController.text.trim(),
                                iban: ibanController.text.trim(),
                                price: priceController.text.trim(),
                                specialties: specialities,
                                bio: bioController.text.trim(),
                                photoURL: "");

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
                          if (!atLeastOneCheckboxSelected()) changeTextColor();
                          if (atLeastOneCheckboxSelected()) changeTextColor();
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
