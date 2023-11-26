import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/firebase_options.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountInfoScreenLawyer(),
    );
  }
}

class AccountInfoScreenLawyer extends StatefulWidget {
  @override
  _AccountInfoScreenLawyerState createState() =>
      _AccountInfoScreenLawyerState();
}

class _AccountInfoScreenLawyerState extends State<AccountInfoScreenLawyer> {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final dOBController = TextEditingController();
  final phoneNumController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final ibanController = TextEditingController();
  final priceController = TextEditingController();
  final bioController = TextEditingController();
  final photoURLController = TextEditingController();
  List<dynamic> specialitiesController = [];
  List<String> itemsList = ['أنثى', 'ذكر'];
  String selectedItem = 'أنثى'; // Default value

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode dOBFocus = FocusNode();
  FocusNode phoneNumFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode ibanFocus = FocusNode();
  FocusNode priceFocus = FocusNode();

  late String initialFirstName;
  late String initialLastName;
  late String initialDOB;
  late String initialPhoneNum;
  late String initialEmail;
  late String initialGender;
  late String initialIban;
  late String initialPrice;
  late String initialBio;
  late String initialPhotoURL;
  late List<String> initialSpectialities;

  //specialities
  bool isChecked0 = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
  bool isChecked7 = false;

  @override
  void dispose() {
    fNameFocus.dispose();
    lNameFocus.dispose();
    dOBFocus.dispose();
    phoneNumFocus.dispose();
    emailFocus.dispose();
    ibanFocus.dispose();
    priceFocus.dispose();

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
    ibanFocus = FocusNode();
    priceFocus = FocusNode();

    // Add listeners to focus nodes
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

    ibanFocus.addListener(() {
      if (!ibanFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });

    priceFocus.addListener(() {
      if (!priceFocus.hasFocus) {
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
    initialPrice = priceController.text;
    initialIban = ibanController.text;
    initialBio = bioController.text;
    initialPhotoURL = "";
    initialSpectialities = [];
  }

  String? email = "";
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update the email variable with the current user's email
      email = user.email!;
      print('User email: $email');

      QuerySnapshot querySnapshot = await _db
          .collection('lawyers')
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
          priceController.text = userData['price'] ?? '';
          ibanController.text = userData['iban'].toString().substring(2) ?? '';
          bioController.text = userData['bio'] ?? '';
          photoURLController.text = userData['photoURL'] ?? '';
          specialitiesController = userData['specialties'] ?? '';
        });
      }
    }
    //check what are the lawyer's Specialties
    for (int i = 0; i < specialitiesController.length; i++) {
      if (specialitiesController.contains("القانون المدني")) isChecked0 = true;
      if (specialitiesController.contains("قانون العمل")) isChecked1 = true;
      if (specialitiesController.contains("القانون التجاري")) isChecked2 = true;
      if (specialitiesController.contains("القانون الدولي")) isChecked3 = true;
      //
      if (specialitiesController.contains("القانون الاداري")) isChecked4 = true;
      if (specialitiesController.contains("قانون المواريث")) isChecked5 = true;
      if (specialitiesController.contains("القانون المالي")) isChecked7 = true;
    }
  }

  bool spectialitiesChanged = false;

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
        // showToast(
        //   "تم تحديث المعلومات بنجاح",
        //   backgroundColor: Colors.green,
        //   radius: 10.0,
        //   textStyle: TextStyle(color: Colors.white),
        //   textPadding: EdgeInsets.all(10.0),
        //   position: ToastPosition.bottom,
        //   duration: Duration(seconds: 2),
        // );
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
// Show the toast message immediately after updating user data
    showToast(
      "تم تحديث المعلومات بنجاح",
      backgroundColor: Colors.green,
      radius: 10.0,
      textStyle: TextStyle(color: Colors.white),
      textPadding: EdgeInsets.all(10.0),
      position: ToastPosition.bottom,
      duration: Duration(seconds: 2),
    );

    if (imgChanged) {
      uploadImageToStorage("$email ProfilePicture", img!);
    }
    //To Remove a speciality
    if (isChecked0 == false &&
        specialitiesController.contains("القانون المدني")) {
      specialitiesController.remove("القانون المدني");
      spectialitiesChanged = true;
    }

    if (isChecked1 == false && specialitiesController.contains("قانون العمل")) {
      specialitiesController.remove("قانون العمل");
      spectialitiesChanged = true;
    }
    if (isChecked2 == false &&
        specialitiesController.contains("القانون التجاري")) {
      specialitiesController.remove("القانون التجاري");
      spectialitiesChanged = true;
    }
    if (isChecked3 == false &&
        specialitiesController.contains("القانون الدولي")) {
      specialitiesController.remove("القانون الدولي");
      spectialitiesChanged = true;
    }
    if (isChecked4 == false &&
        specialitiesController.contains("القانون الاداري")) {
      specialitiesController.remove("القانون الاداري");
      spectialitiesChanged = true;
    }
    if (isChecked5 == false &&
        specialitiesController.contains("قانون المواريث")) {
      specialitiesController.remove("قانون المواريث");
      spectialitiesChanged = true;
    }
    if (isChecked6 == false &&
        specialitiesController.contains("القانون الجنائي")) {
      specialitiesController.remove("القانون الجنائي");
      spectialitiesChanged = true;
    }
    if (isChecked7 == false &&
        specialitiesController.contains("القانون المالي")) {
      specialitiesController.remove("القانون المالي");
      spectialitiesChanged = true;
    }
    //To add new speciality
    if (isChecked0 == true &&
        !specialitiesController.contains("القانون المدني")) {
      specialitiesController.add("القانون المدني");
      spectialitiesChanged = true;
    }

    if (isChecked1 == true && !specialitiesController.contains("قانون العمل")) {
      specialitiesController.add("قانون العمل");
      spectialitiesChanged = true;
    }
    if (isChecked2 == true &&
        !specialitiesController.contains("القانون التجاري")) {
      specialitiesController.add("القانون التجاري");
      spectialitiesChanged = true;
    }
    if (isChecked3 == true &&
        !specialitiesController.contains("القانون الدولي")) {
      spectialitiesChanged = true;
      specialitiesController.add("القانون الدولي");
    }
    if (isChecked4 == true &&
        !specialitiesController.contains("القانون الاداري")) {
      spectialitiesChanged = true;
      specialitiesController.add("القانون الاداري");
    }
    if (isChecked5 == true &&
        !specialitiesController.contains("قانون المواريث")) {
      spectialitiesChanged = true;
      specialitiesController.add("قانون المواريث");
    }
    if (isChecked6 == true &&
        !specialitiesController.contains("القانون الجنائي")) {
      spectialitiesChanged = true;
      specialitiesController.add("القانون الجنائي");
    }
    if (isChecked7 == true &&
        !specialitiesController.contains("القانون المالي")) {
      spectialitiesChanged = true;
      specialitiesController.add("القانون المالي");
    }
    // Now update other user data in Firestore
    QuerySnapshot querySnapshot = await _db
        .collection('lawyers')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String userId = querySnapshot.docs.first.id;

      // Print the user email right before updating
      print('User email before update in Firestore: $email');

      await _db.collection('lawyers').doc(userId).update({
        'firstName': fNameController.text.trim(),
        'lastName': lNameController.text.trim(),
        'dateOfBirth': dOBController.text.trim(),
        'phoneNumber': phoneNumController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedItem,
        'price': priceController.text.trim(),
        'iban': "SA" + ibanController.text.trim(),
        'bio': bioController.text.trim(),
        'photoURL': photoURLController.text.trim(),
        'specialties': specialitiesController,
      });

      QuerySnapshot bookingsQuery = await _db
          .collection('bookings')
          .where('lawyerEmail', isEqualTo: user.email)
          .get();

      for (QueryDocumentSnapshot appointmentDoc in bookingsQuery.docs) {
        await appointmentDoc.reference.update({
          'lawyerEmail': emailController.text.trim(),
        });
      }

      QuerySnapshot reviewsQuery = await _db
          .collection('reviews')
          .where('lawyerEmail', isEqualTo: user.email)
          .get();

      for (QueryDocumentSnapshot appointmentDoc in reviewsQuery.docs) {
        await appointmentDoc.reference.update({
          'lawyerEmail': emailController.text.trim(),
        });
      }

      QuerySnapshot userReportsQuery = await _db
          .collection('userReports')
          .where('email', isEqualTo: user.email)
          .get();

      for (QueryDocumentSnapshot appointmentDoc in userReportsQuery.docs) {
        await appointmentDoc.reference.update({
          'email': emailController.text.trim(),
        });
      }

      QuerySnapshot reportersQuery = await _db
          .collection('reporters')
          .where('lawyerEmail', isEqualTo: user.email)
          .get();

      for (QueryDocumentSnapshot appointmentDoc in reportersQuery.docs) {
        await appointmentDoc.reference.update({
          'lawyerEmail': emailController.text.trim(),
        });
      }
      initialFirstName = fNameController.text;
      initialLastName = lNameController.text;
      initialDOB = dOBController.text;
      initialPhoneNum = phoneNumController.text;
      initialEmail = emailController.text;
      initialGender = selectedItem;
      initialPrice = priceController.text;
      initialIban = ibanController.text;
      initialBio = bioController.text;
      initialPhotoURL = photoURLController.text;
      // Display a message or navigate to another screen after successful update
      print('User data updated successfully');
      // showToast(
      //   "تم تحديث المعلومات بنجاح",
      //   backgroundColor: Colors.green,
      //   radius: 10.0,
      //   textStyle: TextStyle(color: Colors.white),
      //   textPadding: EdgeInsets.all(10.0),
      //   position: ToastPosition.bottom,
      //   duration: Duration(seconds: 2),
      // );
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

  //is a number validation
  bool isNumericUsingRegularExpression(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

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

  ///////try 3
  bool imgChanged = false;
  pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();

    XFile? _file = await _picker.pickImage(
      source: source,
    );

    if (_file != null) {
      imgChanged = true;
      print("imgchanged = $imgChanged before return");
      return await _file.readAsBytes();
    }
    print("imgchanged = $imgChanged _file == null");
  }

  Uint8List? img;
  void selectImage() async {
    img = await pickImage(ImageSource.gallery);
    print("imgChanged $imgChanged end of selectImage()");
  }

  //For storing the image
  Future<void> uploadImageToStorage(String childName, Uint8List file) async {
    try {
      final FirebaseStorage _storage = FirebaseStorage.instance;

      Reference ref = _storage.ref().child(childName);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      photoURLController.text = downloadURL;
      print(" downloadURL   $downloadURL");
      photoURLController.text = downloadURL;
    } catch (error) {
      print('Error uploading image: $error');
      // Handle the error as needed (e.g., show an error message to the user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF008080),
          title: Text('الملف الشخصي'),
          centerTitle: true,
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 30),
              alignment: Alignment.centerRight,
              icon: Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
// Navigate back to the previous page
              },
            ),
          ],
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
                            Center(
                              child: InkWell(
                                onTap: () {
                                  // _changeProfileImage();
                                  // takePhoto(ImageSource.gallery);
                                  selectImage();
                                  print(
                                      "imgchanged = $imgChanged after return");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    img == null
                                        ? CircleAvatar(
                                            radius: 64,
                                            backgroundImage: NetworkImage(
                                                photoURLController.text),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    0, 255, 255, 255),
                                          )
                                        : CircleAvatar(
                                            radius: 64,
                                            backgroundImage: MemoryImage(img!),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    0, 255, 255, 255),
                                          ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 0,
                                              blurRadius: 3,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 29,
                                          color:
                                              Color.fromARGB(181, 0, 150, 135),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'الاسم الأول',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(
                                  255,
                                  78,
                                  76,
                                  76,
                                ),
                              ),
                            ),
                            // SizedBox(height: 5),
                            TextFormField(
                              controller: fNameController,
                              focusNode: fNameFocus,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 0.9,
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
                        height: 9,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'الاسم الأخير',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 78, 76, 76),
                              ),
                            ),
                            // SizedBox(height: 5),
                            TextFormField(
                              controller: lNameController,
                              focusNode: lNameFocus,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 0.9,
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
                                      lNameController.clear();
                                    });
                                  },
                                ),
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
                        height: 9,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'تاريخ الميلاد ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 78, 76, 76),
                              ),
                            ),
                            // SizedBox(height: 5),
                            Container(
                              child: TextFormField(
                                controller: dOBController,
                                focusNode: dOBFocus,
                                style: TextStyle(
                                    fontSize: 13,
                                    height: 1.1,
                                    color: Colors.black),
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
                                    suffixIcon:
                                        Icon(Icons.calendar_month_rounded)),
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
                                    initialDate: DateTime(2007),
                                    firstDate: DateTime(1930),
                                    lastDate: DateTime(2007),
                                    builder:
                                        (BuildContext context, Widget? child) {
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
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
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
                        height: 9,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'رقم الهاتف ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 78, 76, 76),
                              ),
                            ),
                            // SizedBox(height: 5),
                            TextFormField(
                              controller: phoneNumController,
                              focusNode: phoneNumFocus,
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
                                      phoneNumController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبئة الخانة';
                                } else if (!validatePhoneNum(value))
                                  return 'الرجاء ادخال رقم هاتف صحيح';
                                else if (!isNumericUsingRegularExpression(
                                    value))
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
                        height: 9,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'البريد الالكتروني ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 78, 76, 76),
                              ),
                            ),
                            // SizedBox(height: 5),
                            TextFormField(
                              onTap: () async {
                                print("ontap");
                                await fetchEmailsAsync();
                              },
                              controller: emailController,
                              focusNode: emailFocus,
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
                                if (value == null || value.trim().isEmpty) {
                                  return 'الرجاء تعبئة الخانة';
                                } else if (value.length > 50)
                                  return ' الرجاء تعبئة الخانة بشكل صحيح';
                                else if (!validateEmail(value))
                                  return '( Example@gmail.com )الرجاء ادخال بريد الكتروني صحيح';
                                else {
                                  if (emails.contains(value) &&
                                      value != initialEmail)
                                    return 'هذا البريد الإلكتروني مستخدم';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'الجنس ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 78, 76, 76),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FractionallySizedBox(
                                widthFactor: 1,
                                child: Container(
                                  height: 95,
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 4, 2, 2),
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
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                height: 250,
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
                                margin: EdgeInsets.fromLTRB(2, 2, 2, 9),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(
                                      12), // Set the border radius
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    ' رقم الايبان ',
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
                                  focusNode: ibanFocus,
                                  maxLength: 24,
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
                                    else if (value.length > 27 ||
                                        value.length < 22)
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
                                    "سعر جلسة الاستشارة للساعة الواحدة",
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
                                  focusNode: priceFocus,
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
                                  maxLines: 7,
                                  style: TextStyle(
                                      fontSize: 13,
                                      height: 1.1,
                                      color: Colors.black),
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
                                          bioController.clear();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )),
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
                                  if (_formKey.currentState!.validate() &&
                                      atLeastOneCheckboxSelected()) {
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
                                        textStyle:
                                            TextStyle(color: Colors.black),
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
                    ]))));
  }

  bool isFormChanged() {
    return initialFirstName != fNameController.text ||
        initialLastName != lNameController.text ||
        initialDOB != dOBController.text ||
        initialPhoneNum != phoneNumController.text ||
        initialEmail != emailController.text ||
        initialGender != selectedItem ||
        initialPrice != priceController ||
        initialIban != ibanController ||
        initialPhotoURL != photoURLController ||
        initialBio != bioController ||
        spectialitiesChanged;
    ;
  }
}
