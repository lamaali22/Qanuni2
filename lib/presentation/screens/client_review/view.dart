import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/widgets/custom_text_form_field.dart';
import 'package:qanuni/providers/client_review/cubit/client_review_cubit.dart';
import 'package:qanuni/utils/colors.dart';

class ClientReviewScreen extends StatefulWidget {
  const ClientReviewScreen({Key? key}) : super(key: key);

  @override
  State<ClientReviewScreen> createState() => _ClientReviewScreenState();
}

class _ClientReviewScreenState extends State<ClientReviewScreen> {
  String formatNumber(int number) {
    return NumberFormat.decimalPattern('ar_EG').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.arrow_forward, color: Colors.teal),
            onPressed: () {
              ClientReviewCubit.get(context).reset();
              Navigator.pop(context); // Navigate back to the previous page
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment(20, 0),
              colors: [Color(0x21008080), Colors.white.withOpacity(0)],
            ),
          ),
        ),
      ),

      //navigation bar

      body: BlocConsumer<ClientReviewCubit, ClientReviewState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is Error) {
            showToast(state.error,
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: TextStyle(color: Colors.white));
          }
          if (state is ReviewSubmitted) {
            showToast('تم ارسال تقييمك بنجاح', position: ToastPosition.bottom);
            ClientReviewCubit.get(context).reset();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LogoutPage()),
                (Route<dynamic> route) => false);
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, -1),
                end: Alignment(0, 0),
                colors: [Color(0x21008080), Colors.white.withOpacity(0)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                            child: Image.network(
                          ClientReviewCubit.get(context).lawyerImg,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/default_photo.jpg',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            );
                          },
                        )),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ClientReviewCubit.get(context).lawyerName,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Cairo',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 5.0,
                    )

                    //rating box
                    ,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: ShapeDecoration(
                            color: Color(0x26FFC126),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Row(children: [
                            Icon(
                              Icons.star,
                              size: 17.0,
                              color: Colors.amber[400],
                            ),
                            Text(
                              ClientReviewCubit.get(context).lawyerRating,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.02,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 15.0,
                    )

                    //specality box
                    ,
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: ClientReviewCubit.get(context)
                              .specialities
                              .map((specialty) {
                            return Container(
                              constraints: BoxConstraints(minWidth: 50),
                              height: 24,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Color(0x7F008080),
                                borderRadius: BorderRadius.circular(11.74),
                              ),
                              child: Text(
                                specialty,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    //end specality box

                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      width: double
                          .infinity, // Set the desired width of the container
                      padding: EdgeInsets.all(
                          20), // Set the padding around the container content
                      height: 0.7.sh,
                      decoration: ShapeDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 40,
                            offset: Offset(0, -5),
                            spreadRadius: 0,
                          )
                        ],
                      ),

                      //inside box

                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Limit the vertical size of the column to its content

                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          Text(
                            'اترك تقييمك',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          //Bio
                          Center(
                            child: RatingBar.builder(
                              initialRating:
                                  ClientReviewCubit.get(context).clientRate,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              unratedColor: Colors.amber.withOpacity(0.3),
                              onRatingUpdate: (rating) {
                                ClientReviewCubit.get(context)
                                    .changeRate(rating);
                              },
                            ),
                          ),
                          40.verticalSpace,
                          CustomTextFormField(
                            hinttext: 'اترك تعليق',
                            showCounter: true,
                            fontSize: 16,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s\s'))
                            ],
                            icon: null,
                            filledColor: ColorConstants.greyColor,
                            mycontroller: ClientReviewCubit.get(context)
                                .clientReviewController,
                            numberOfLines: 5,
                            maxLength: 300,
                            onChanged: () {
                              setState(() {});
                            },
                            currentLength: ClientReviewCubit.get(context)
                                .clientReviewController
                                .text
                                .length,
                            valid: (text) {
                              return null;
                            },
                          ),
                          40.verticalSpace,

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (ClientReviewCubit.get(context)
                                            .clientReviewController
                                            .text
                                            .isEmpty &&
                                        ClientReviewCubit.get(context)
                                                .clientRate ==
                                            0.0) {
                                      showToast('برجاء ترك التقييم قبل الارسال',
                                          position: ToastPosition.bottom,
                                          backgroundColor: Colors.red,
                                          textStyle:
                                              TextStyle(color: Colors.white));
                                    } else {
                                      ClientReviewCubit.get(context).submit();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(
                                        0xFF008080), // Set the background color of the button
                                    padding: EdgeInsets.all(12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: state is SubmittingReview
                                      ? Center(
                                          child: Container(
                                          height: 30,
                                          width: 30,
                                          child: Center(
                                            child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                )),
                                          ),
                                        ))
                                      : Text(
                                          'ارسال',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
