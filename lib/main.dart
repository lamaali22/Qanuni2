import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/firebase_options.dart';
import 'package:qanuni/presentation/screens/boarding_screen/view.dart';
import 'package:qanuni/presentation/screens/landing_screen/view.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/providers/boarding/cubit/boarding_cubit.dart';
import 'package:qanuni/providers/client_review/cubit/client_review_cubit.dart';
import 'package:qanuni/providers/payment/cubit/payment_cubit.dart';
import 'package:qanuni/providers/auth/login/cubit/login_cubit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qanuni/utils/constants.dart';  // Import Riverpod

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);
  Stripe.publishableKey = AppConstants.stripKey;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return ProviderScope(  // Wrap the entire widget tree with ProviderScope
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BoardingCubit()),
                BlocProvider(create: (_) => LoginCubit()),
                BlocProvider(create: (_) => PaymentCubit()),
                BlocProvider(create: (_) => ClientReviewCubit()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Qanuni',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: Typography.englishLike2018.apply(
                    fontSizeFactor: 1.sp,
                  ),
                ),
                home: const LandingScreen(),
              ),
            ),
          );
        },
        child: const LandingScreen(),
      ),
    );
  }
}
