import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
import 'package:qanuni/presentation/widgets/custom_text_form_field2.dart';
import 'package:qanuni/providers/payment/cubit/payment_cubit.dart';
import 'package:qanuni/utils/colors.dart';
import 'package:qanuni/utils/images.dart';

// pass lawyer price to include in the summary
// pass timeslot to make it available=false

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  GlobalKey<FormState> cardFormKey = GlobalKey<FormState>();

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
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
            desc: '',
            onDismissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
            //make availble = false , add booking to 'bookings'
          ).show().then((value) {
            PaymentCubit.get(context).clearData();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingClientScreen(),
                ));
          });
        }
        if (state is Error) {
          if (state.error == "Your card's expiration month is invalid.") {
            showToast('تاريخ انتهاء البطاقة غير صحيح',
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white));
          } else if (state.error ==
              "The card number is not a valid credit card number.") {
            showToast("رقم البطاقة غير صحيح",
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white));
          } else if (state.error == 'Your card has insufficient funds.') {
            showToast("لا يوجد رصيد كافي في البطاقة",
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white));
          } else if (state.error == 'Your card was declined.') {
            showToast("تم رفض البطاقة",
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white));
          } else if (state.error == "Your card's expiration year is invalid.") {
            showToast("تاريخ انتهاء البطاقة غير صحيح",
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white));
          } else if (state.error == "Your card number is incorrect.") {
            showToast("البطاقة غير موجودة",
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white));
          } else {
            showToast(state.error,
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white));
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: ElevatedButton(
                onPressed: () {
                  if (cardFormKey.currentState!.validate()) {
                    PaymentCubit.get(context).makePayment();
                  }
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
                    : Text(
                        'إدفع ${PaymentCubit.get(context).price} ريال',
                        style: const TextStyle(fontSize: 18, color: Colors.white),
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
                        const Text(
                          'صفحة الدفع',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: ColorConstants.primaryColor),
                          textAlign: TextAlign.center,
                        ),
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
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    const Color(0xFFAB0000).withOpacity(0.08)),
                            color: const Color(0xFFAB0000).withOpacity(0.05)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.error,
                                color: Color(0xFF930000),
                                size: 30,
                              ),
                              10.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('بيانات البطاقة خاطئة',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color(0xFF930000))),
                                  5.verticalSpace,
                                  const Text(
                                      'يرجى إعادة ادخال البيانات الصحيحة',
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
                      key: cardFormKey,
                      child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFF008080)
                                      .withOpacity(0.25)),
                              color: const Color(0xFF008080).withOpacity(0.04)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('  اسم حامل البطاقة',
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny('  '),
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[a-z A-Z ء-ي]'))
                                ],
                                maxLength: 16,
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
                              const Text('  رقم البطاقة',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF008080))),
                              10.verticalSpace,
                              CustomTextFormField2(
                                hinttext: 'XXXX XXXX XXXX XXXX',
                                isNumber: true,
                                maxLength: 16,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 24,
                                            child: Text('  تاريخ الانتهاء',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Color(0xFF008080))),
                                          ),
                                          10.verticalSpace,
                                          CustomTextFormField2(
                                            hinttext: 'MM/YYYY',
                                            isNumber: true,
                                            prefixWidget: null,
                                            suffixWidget: null,
                                            filledColor: Colors.white,
                                            textDirection: TextDirection.rtl,
                                            mycontroller:
                                                PaymentCubit.get(context)
                                                    .expiryController,
                                            onChanged: (text) {
                                              PaymentCubit.get(context)
                                                  .onCardDateChange(text);
                                            },
                                            valid: (text) {
                                              print(text);
                                              if (text!.isEmpty ||
                                                  !text.contains('/') ||
                                                  (text.length > 2 &&
                                                      (text
                                                              .substring(0, 2)
                                                              .contains('/') ||
                                                          int.parse(text
                                                                  .substring(
                                                                      0, 2)) >
                                                              12))) {
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
                                      flex: 0,
                                      child: SizedBox(
                                        width: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(
                                              height: 24,
                                              child: Text('CVV  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color:
                                                          Color(0xFF008080))),
                                            ),
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
                                                if (text!.length < 3) {
                                                  return '';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ],
                                        ),
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
