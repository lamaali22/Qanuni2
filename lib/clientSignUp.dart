import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'package:qanuni/models/clientModel.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
=======
import 'package:qanuni/data/models/clientModel.dart';
import 'package:qanuni/models/clientModel.dart';
>>>>>>> main
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:email_validator/email_validator.dart';
import 'package:qanuni/providers/boarding/cubit/boarding_cubit.dart';
import '../../../providers/auth/login/cubit/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Client Sign Up';
    ColorScheme.fromSeed(seedColor: Color.fromARGB(103, 0, 132, 132));
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: const MyAppp(),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyAppp extends StatelessWidget {
  const MyAppp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Sign Up',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(103, 0, 132, 132)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//controllers
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final dOBController = TextEditingController();
  final phoneNumController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final genderController = TextEditingController();

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

//phone validation
  bool validatePhoneNum(String phoneNum) {
    bool isvalid = false;
    String phoneNumStr = phoneNum.substring(0, 2);
    if (phoneNumStr == '05' && phoneNum.length == 10) isvalid = true;

    return isvalid;
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

//is a number validation
  bool isNumericUsingRegularExpression(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
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

  createUser(clientModel client) async {
    await _db.collection("Clients").add(client.toJson());
  }

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
  }

//check if phone is used
  List<String> phones = [];
  Future<void> fetchPhonesAsync() async {
    final QuerySnapshot querySnapshot = await _db.collection('Clients').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('phoneNumber')) {
        final phone = data['phoneNumber'] as String;
        phones.add(phone);
      }
    }

    final QuerySnapshot querySnapshot2 = await _db.collection('lawyers').get();
    final List<QueryDocumentSnapshot> documents2 = querySnapshot2.docs;

    for (QueryDocumentSnapshot doc in documents2) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('phoneNumber')) {
        final phone = data['phoneNumber'] as String;
        phones.add(phone);
      }
    }
  }

  ////////////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
            body: Container(
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
                            fontSize: 13, height: 1.1, color: Colors.black),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "تاريخ الميلاد",
                            prefixIcon: Icon(Icons.calendar_month_rounded)),
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
                              initialDate: DateTime.now(),
<<<<<<< HEAD
                              firstDate: DateTime(1950),
=======
                              firstDate: DateTime(
                                  1930), //DateTime.now() - not to allow to choose before today.
>>>>>>> lama-sprint
                              lastDate: DateTime.now());

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              dOBController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
<<<<<<< HEAD
                      onTap: () async {
                        print("ontap");
                        await fetchPhonesAsync();
                      },
=======
>>>>>>> main
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
                          fetchPhonesAsync();
                          if (phones.contains(value)) return 'هذا الرقم مستخدم';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
<<<<<<< HEAD
                      onTap: () async {
                        print("ontap");
                        await fetchEmailsAsync();
                      },
=======
>>>>>>> main
                      controller: emailController,
                      style: TextStyle(
                          fontSize: 13, height: 1.1, color: Colors.black),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: '(example@gmail.com) البريد الالكتروني',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تعبأة الخانة';
                        } else if (value.length > 50)
                          return ' الرجاء تعبأة الخانة بشكل صحيح';
                        else if (!validateEmail(value))
                          return 'الرجاء ادخال بريد الكتروني صحيح';
                        else {
                          fetchEmailsAsync();
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
                              SizedBox(
                                width: 130,
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: 20,
                                height: 20,
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
                                      fontSize: 13,
                                      color: Color.fromRGBO(104, 102, 102, 1)))
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 123,
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: 20,
                                height: 20,
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
                                      fontSize: 13,
                                      color: Color.fromRGBO(104, 102, 102, 1)))
                            ],
                          ),
                        ])),
                    SizedBox(
                      height: 15,
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //authentication
                            createUserWithEmailAndPassword(
                                emailController.text.trim(),
                                passwordController.text.trim());

                            //storing in DB

                            final client = clientModel(
                                firstName: fNameController.text.trim(),
                                lastName: lNameController.text.trim(),
                                dateOfBirth: dOBController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                phone: phoneNumController.text.trim(),
                                gender: selectedItem);

                            createUser(client);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ));

                            //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')),);
                          }
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
