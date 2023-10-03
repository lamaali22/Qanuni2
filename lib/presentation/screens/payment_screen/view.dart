import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
import 'package:qanuni/presentation/widgets/custom_text_form_field2.dart';
import 'package:qanuni/providers/payment/cubit/payment_cubit.dart';
import 'package:qanuni/utils/colors.dart';
import 'package:qanuni/utils/images.dart';

// pass lawyer price to include in the summary
// pass timeslot to make it available=false 

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);
///
// void bookSelectedTimeSlot(String selectedTimeSlot) async {
//   DateTime startOfDay = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

//   try {
//     // Get the client's email from the current user
//     String? clientEmail = _user?.email;

//     if (clientEmail != null) {
//       // Query the available time slot
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('timeSlots')
//           .where('available', isEqualTo: true)
//           .where('lawyerEmail', isEqualTo: widget.lawyer.email)
//          // .where('startTime', isEqualTo: Timestamp.fromDate(startOfDay))
//           .get();

//       print('Query snapshot size: ${querySnapshot.size}');

//       if (querySnapshot.size > 0) {
//         String timeSlotId = querySnapshot.docs[0].id;

//         print('Selected time slot: $selectedTimeSlot');

//         // Ensure that the selected time slot matches the available time slots
//         if (querySnapshot.docs.any((doc) => _formatTime((doc['startTime'] as Timestamp).toDate()) == selectedTimeSlot)) {
//           // Update 'available' status in 'timeSlots' collection
//           await FirebaseFirestore.instance
//               .collection('timeSlots')
//               .doc(timeSlotId)
//               .update({'available': false});

//           // Add a new document to 'bookings' collection
//           await FirebaseFirestore.instance.collection('bookings').add({
//             'clientEmail': clientEmail,
//             'lawyerEmail': widget.lawyer.email,
//             'startTime': startOfDay,
//             'endTime': startOfDay.add(Duration(hours: 1)),
//             'timeSlotId': timeSlotId,
//           });

//           showToast(
//             'Your session is booked',
//             position: ToastPosition.center,
//             backgroundColor: Colors.green,
//             textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
//             duration: Duration(seconds: 3),
//           );

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//           );
//         } else {
//           showToast(
//             'Error: Selected time slot is not valid. Please try again.',
//             position: ToastPosition.bottom,
//             backgroundColor: Colors.red,
//             textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
//             duration: Duration(seconds: 5),
//           );
//         }
//       } else {
//         showToast(
//           'Error: Time slot not available. Please choose another time slot.',
//           position: ToastPosition.bottom,
//           backgroundColor: Colors.red,
//           textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
//           duration: Duration(seconds: 5),
//         );
//       }
//     } else {
//       print('Client email is null. Provide a default value or handle accordingly.');
//     }
//   } catch (e) {
//     print('Error booking time slot: $e');
//     showToast(
//       'Error: Something went wrong. Please try again.',
//       position: ToastPosition.bottom,
//       backgroundColor: Colors.red,
//       textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
//       duration: Duration(seconds: 5),
//     );
//   }
// }





// void addBookingToFirestore(DateTime startTime, String timeSlotId) {
//    // Get the client's email from LoginCubit
//   //  String clientEmail = LoginCubit.get(context).email;

//   DateTime endTime = startTime.add(Duration(hours: 1)); // Assuming each session is 1 hour

//   // Add a new document to 'bookings' collection
//   FirebaseFirestore.instance.collection('bookings').add({
//     'clientEmail': _user!.email,
//     'lawyerEmail': widget.lawyer.email,
//     'startTime': startTime,
//     'endTime': endTime,
//     'timeSlotId': timeSlotId,
//   }).then((_) {
//     print('Booking added to Firestore successfully');
//   }).catchError((error) {
//     print('Failed to add booking to Firestore: $error');
//   });
// }




//   void showOkToast() {
//     showToast(
//       'Your session is booked',
//       position: ToastPosition.center,
//       backgroundColor: Colors.green,
//       textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
//       duration: Duration(seconds: 3),
//     );
//   }

///
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is PaymentSuccess) {
          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            showCloseIcon: true,
            title: 'تم حجز الجلسة بنجاح',
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
            desc: '',
            onDismissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
            //make availble = false , add booking to 'bookings'
          ).show().then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              )));
        }
        if (state is Error) {
          showToast(state.error, position: ToastPosition.bottom);
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: ElevatedButton(
                onPressed: () {
                  PaymentCubit.get(context).makePayment();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fixedSize: Size(1.sw, 50),
                  backgroundColor: ColorConstants.primaryColor,
                ),
                child: state is ProcessingPayment
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'إدفع',
                        style: TextStyle(fontSize: 18),
                      )),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: ColorConstants.primaryColor,
                          ),
                        ),
                        10.horizontalSpace,
                        const Text('صفحة الدفع',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: ColorConstants.primaryColor),
                                textAlign: TextAlign.center,),
                        10.horizontalSpace,
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  if (state is InvalidCard)
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0xFFAB0000).withOpacity(0.08)),
                            color: Color(0xFFAB0000).withOpacity(0.05)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.error,
                                color: Color(0xFF930000),
                                size: 30,
                              ),
                              10.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('بيانات البطاقة خاطئة',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color(0xFF930000))),
                                  5.verticalSpace,
                                  Text('يرجى إعادة ادخال البيانات الصحيحة',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Color(0xFF930000)))
                                ],
                              )
                            ]),
                      ),
                    ),
                  15.verticalSpace,
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Form(
                      key: PaymentCubit.get(context).formKey,
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color(0xFF008080).withOpacity(0.25)),
                              color: Color(0xFF008080).withOpacity(0.04)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('  اسم حامل البطاقة',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF008080))),
                              10.verticalSpace,
                              CustomTextFormField2(
                                hinttext: 'الاسم الموجود على البطاقة',
                                prefixWidget: null,
                                suffixWidget: null,
                                filledColor: Colors.white,
                                textDirection: TextDirection.rtl,
                                mycontroller: PaymentCubit.get(context)
                                    .cardHoldeNameController,
                                valid: (text) {
                                  print(text);
                                  if (text!.isEmpty) {
                                    return 'يجب ادخال الإسم';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              20.verticalSpace,
                              Text('  رقم البطاقة',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF008080))),
                              10.verticalSpace,
                              CustomTextFormField2(
                                hinttext: 'XXXX XXXX XXXX XXXX',
                                isNumber: true,
                                prefixWidget: Image.asset(
                                  ImageConstants.credit,
                                  height: 30,
                                  width: 30,
                                ),
                                suffixWidget: null,
                                filledColor: Colors.white,
                                textDirection: TextDirection.rtl,
                                mycontroller: PaymentCubit.get(context)
                                    .cardNumberController,
                                valid: (text) {
                                  print(text);
                                  if (text!.isEmpty) {
                                    return 'يجب ادخال رقم البطاقة';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              20.verticalSpace,
                              Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('  تاريخ الانتهاء',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color(0xFF008080))),
                                          10.verticalSpace,
                                          CustomTextFormField2(
                                            hinttext: 'MM/YYYY',
                                            prefixWidget: null,
                                            suffixWidget: null,
                                            filledColor: Colors.white,
                                            textDirection: TextDirection.rtl,
                                            mycontroller:
                                                PaymentCubit.get(context)
                                                    .expiryController,
                                            valid: (text) {
                                              print(text);
                                              if (text!.isEmpty) {
                                                return '';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ],
                                      )),
                                  Expanded(flex: 2, child: Container()),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text('CVV  ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color(0xFF008080))),
                                          10.verticalSpace,
                                          CustomTextFormField2(
                                            hinttext: '123',
                                            prefixWidget: null,
                                            isNumber: true,
                                            maxLength: 3,
                                            suffixWidget: Image.asset(
                                              ImageConstants.credit,
                                              height: 30,
                                              width: 30,
                                            ),
                                            filledColor: Colors.white,
                                            textDirection: TextDirection.ltr,
                                            mycontroller:
                                                PaymentCubit.get(context)
                                                    .cvvController,
                                            valid: (text) {
                                              print(text);
                                              if (text!.isEmpty) {
                                                return '';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                              10.verticalSpace,
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}