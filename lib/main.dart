import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/Notifications';
import 'package:qanuni/firebase_options.dart';
import 'package:qanuni/presentation/screens/boarding_screen/view.dart';
import 'package:qanuni/presentation/screens/landing_screen/view.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/providers/boarding/cubit/boarding_cubit.dart';
import 'package:qanuni/providers/payment/cubit/payment_cubit.dart';
import 'package:qanuni/utils/constants.dart';
import 'providers/auth/login/cubit/login_cubit.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  auth = FirebaseAuth.instanceFor(app: app);
  Stripe.publishableKey = AppConstants.stripKey;

  Notifications.initalize();
  Notifications.onRecieveNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BoardingCubit(),
        ),
        BlocProvider(
          create: (_) => LoginCubit(),
        ),
        BlocProvider(
          create: (_) => PaymentCubit(),
        ),
      ],
      child: OKToast(
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          // Use builder only if you need to use library outside ScreenUtilInit context
          builder: (_, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Qanuni',
              // You can use the library anywhere in the app even in theme
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: Typography.englishLike2018.apply(
                  fontSizeFactor: 1.sp,
                ),
              ),
              home: child,
            );
          },
          child: const LandingScreen(),
        ),
      ),
    );
  }
}
