import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/models/clientModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountInfoScreen(),
    );
  }
}

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final dOBController = TextEditingController();
  final phoneNumController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  List<String> itemsList = ['أنثى', 'ذكر'];
  String selectedItem = 'أنثى'; // Default value

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode dOBFocus = FocusNode();
  FocusNode phoneNumFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  late String initialFirstName;
  late String initialLastName;
  late String initialDOB;
  late String initialPhoneNum;
  late String initialEmail;
  late String initialGender;

  @override
  void dispose() {
    fNameFocus.dispose();
    lNameFocus.dispose();
    dOBFocus.dispose();
    phoneNumFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Fetch user data and populate controllers
    initUserData();

    fNameFocus = FocusNode();
    lNameFocus = FocusNode();
    dOBFocus = FocusNode();
    phoneNumFocus = FocusNode();
    emailFocus = FocusNode();

    // Add listeners to focus nodes
    fNameFocus.addListener(() {
      if (!fNameFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });

    lNameFocus.addListener(() {
      if (!lNameFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });

    dOBFocus.addListener(() {
      if (!dOBFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });

    phoneNumFocus.addListener(() {
      if (!phoneNumFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });

    emailFocus.addListener(() {
      if (!emailFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });
  }

  // Future<void> initUserData() async {
  //   await fetchUserData();

  //   // Make sure selectedItem is a valid item in itemsList
  //   if (!itemsList.contains(selectedItem)) {
  //     setState(() {
  //       selectedItem = itemsList.first; // Set to the first item as a default
  //     });
  //   }
  // }
  Future<void> initUserData() async {
    await fetchUserData();
    // Make sure selectedItem is a valid item in itemsList
    if (!itemsList.contains(selectedItem)) {
      setState(() {
        selectedItem = itemsList.first; // Set to the first item as a default
      });
    }
    initialFirstName = fNameController.text;
    initialLastName = lNameController.text;
    initialDOB = dOBController.text;
    initialPhoneNum = phoneNumController.text;
    initialEmail = emailController.text;
    initialGender = selectedItem;
  }

  String? email = "";
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update the email variable with the current user's email
      email = user.email!;
      print('User email: $email');

      QuerySnapshot querySnapshot = await _db
          .collection('Clients')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          fNameController.text = userData['firstName'] ?? '';
          lNameController.text = userData['lastName'] ?? '';
          dOBController.text = userData['dateOfBirth'] ?? '';
          phoneNumController.text = userData['phoneNumber'] ?? '';
          emailController.text = userData['email'] ?? '';
          selectedItem = userData['gender'] ?? '';
        });
      }
    }
  }

  Future<void> updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print('Current user email before update: ${user.email}');
    } else {
      print('No current user found');
      return;
    }

    // Show a dialog to get the user's current password
    String? password;

    // Check if email is being updated, and request password only in that case
    if (user.email != emailController.text.trim()) {
      password = await showPasswordInputDialog(context);
      if (password == null) {
        print('Password entry canceled');
        return;
      }
    }

    if (password != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      try {
        await user.reauthenticateWithCredential(credential);

        // If updating email, update it first
        if (user.email != emailController.text.trim()) {
          await user.updateEmail(emailController.text.trim());
        }
        showToast(
          "تم تحديث المعلومات بنجاح",
          backgroundColor: Colors.green,
          radius: 10.0,
          textStyle: TextStyle(color: Colors.white),
          textPadding: EdgeInsets.all(10.0),
          position: ToastPosition.bottom,
          duration: Duration(seconds: 2),
        );
      } catch (e) {
        print('Failed to re-authenticate user: $e');
        showToast(
          "كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى",
          backgroundColor: Colors.red,
          radius: 10.0,
          textStyle: TextStyle(color: Colors.white),
          textPadding: EdgeInsets.all(10.0),
          position: ToastPosition.bottom,
          duration: Duration(seconds: 2),
        );
        return;
      }
    }

    // Now update other user data in Firestore
    QuerySnapshot querySnapshot = await _db
        .collection('Clients')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String userId = querySnapshot.docs.first.id;

      // Print the user email right before updating
      print('User email before update in Firestore: $email');

      await _db.collection('Clients').doc(userId).update({
        'firstName': fNameController.text.trim(),
        'lastName': lNameController.text.trim(),
        'dateOfBirth': dOBController.text.trim(),
        'phoneNumber': phoneNumController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedItem,
      });

      // Display a message or navigate to another screen after successful update
      print('User data updated successfully');
      showToast(
        "تم تحديث المعلومات بنجاح",
        backgroundColor: Colors.green,
        radius: 10.0,
        textStyle: TextStyle(color: Colors.white),
        textPadding: EdgeInsets.all(10.0),
        position: ToastPosition.bottom,
        duration: Duration(seconds: 2),
      );
      // Print the user email after updating
      print(
          'User email after update in Firestore: ${emailController.text.trim()}');
    } else {
      print('No user data found in Firestore for email: $email');
    }
  }

// Function to show a password input dialog
  Future<String?> showPasswordInputDialog(BuildContext context) async {
    String? password;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'تأكيد تغيير البريد الإلكتروني',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Cairo',
                color: Color.fromARGB(255, 7, 93, 81)),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الرجاء إدخال كلمة المرور لتأكيد تغيير البريد الإلكتروني.',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  color: Color.fromARGB(255, 7, 93, 81)),
            ),
            TextField(
              obscureText: true,
              onChanged: (value) => password = value,
              style:
                  TextStyle(color: Colors.teal), // Set the text color to teal
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('إلغاء',
                style: TextStyle(color: Colors.teal)), // Customize text color
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(password);
            },
            child: Text('تأكيد',
                style: TextStyle(color: Colors.teal)), // Customize text color
          ),
        ],
      ),
    );

    return password;
  }

//Email validation
  bool validateEmail(String email) {
    bool isvalid = EmailValidator.validate(email);
    return isvalid && !email.trim().isEmpty;
  }

  //phone validation
  bool validatePhoneNum(String phoneNum) {
    bool isvalid = false;
    String phoneNumStr = phoneNum.substring(0, 2);
    if (phoneNumStr == '05' && phoneNum.length == 10) isvalid = true;

    return isvalid && !phoneNum.trim().isEmpty;
  }

  final _db = FirebaseFirestore.instance;
  //check if email is used
  List<String> emails = [];
  Future<void> fetchEmailsAsync() async {
    final QuerySnapshot querySnapshot = await _db.collection('Clients').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('email')) {
        final email = data['email'] as String;
        emails.add(email);
      }
    }

    final QuerySnapshot querySnapshot2 = await _db.collection('lawyers').get();
    final List<QueryDocumentSnapshot> documents2 = querySnapshot2.docs;

    for (QueryDocumentSnapshot doc in documents2) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('email')) {
        final email = data['email'] as String;
        emails.add(email);
      }
    }
  }

  //is a number validation
  bool isNumericUsingRegularExpression(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008080),
        title: Text('الملف الشخصي'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الاسم الأول',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: fNameController,
                      focusNode: fNameFocus,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        //  hintText: "الاسم الأول",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء تعبئة الخانة';
                        } else if (value.length > 50)
                          return ' الرجاء تعبئة الخانة بشكل صحيح';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الاسم الأخير',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: lNameController,
                      focusNode: lNameFocus,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        // hintText: "الاسم الأخير",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء تعبئة الخانة';
                        } else if (value.length > 50)
                          return ' الرجاء تعبئة الخانة بشكل صحيح';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'تاريخ الميلاد ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: TextFormField(
                        controller: dOBController,
                        focusNode: dOBFocus,
                        style: TextStyle(
                            fontSize: 13, height: 1.1, color: Colors.black),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.teal,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            // hintText: "تاريخ الميلاد",
                            prefixIcon: Icon(Icons.calendar_month_rounded)),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء تعبئة الخانة';
                          } else if (value.length > 50)
                            return ' الرجاء تعبئة الخانة بشكل صحيح';

                          return null;
                        },

                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1930),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: Colors.teal, // Head color
                                  hintColor: Colors.teal, // Highlight color
                                  colorScheme:
                                      ColorScheme.light(primary: Colors.teal),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
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
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'رقم الجوال ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: phoneNumController,
                      focusNode: phoneNumFocus,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        // hintText: ' (05x xxxx xxx) رقم الهاتف',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تعبئة الخانة';
                        } else if (!validatePhoneNum(value))
                          return 'الرجاء ادخال رقم هاتف صحيح';
                        else if (!isNumericUsingRegularExpression(value))
                          return '(الرجاء تعبئة الخانة بأعداد فقط (من 0-9';
                        else
                          return null;
                      },
                      maxLength: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'البريد الالكتروني ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      onTap: () async {
                        print("ontap");
                        await fetchEmailsAsync();
                      },
                      controller: emailController,
                      focusNode: emailFocus,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        //hintText: '(example@gmail.com) البريد الالكتروني',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء تعبئة الخانة';
                        } else if (value.length > 50)
                          return ' الرجاء تعبئة الخانة بشكل صحيح';
                        else if (!validateEmail(value))
                          return 'الرجاء ادخال بريد الكتروني صحيح';
                        else {
                          if (emails.contains(value))
                            return 'هذا البريد الإلكتروني مستخدم';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الجنس ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 95,
                          padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
                          margin: EdgeInsets.all(2),
                          child: DropdownButtonFormField<String>(
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
                              if (value == null || value.isEmpty) {
                                return 'الرجاء تحديد الجنس';
                              }
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF008080),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Form is valid, check if any fields are changed
                      if (isFormChanged()) {
                        // Fields are changed, update user data
                        updateUserData();
                      } else {
                        // No changes, show toast message
                        showToast(
                          "لم تقم بتعديل أي معلومات",
                          backgroundColor: Colors.yellow,
                          radius: 10.0,
                          textStyle: TextStyle(color: Colors.black),
                          textPadding: EdgeInsets.all(10.0),
                          position: ToastPosition.bottom,
                          duration: Duration(seconds: 2),
                        );
                      }
                    }
                  },
                  child: Text(
                    'تأكيد التعديل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.12,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
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

  bool isFormChanged() {
    return initialFirstName != fNameController.text ||
        initialLastName != lNameController.text ||
        initialDOB != dOBController.text ||
        initialPhoneNum != phoneNumController.text ||
        initialEmail != emailController.text ||
        initialGender != selectedItem;
  }
}
