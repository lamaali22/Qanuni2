import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/consultationLawyer.dart';

class Notifications {
  static String serverKey =
      "AAAAA2pNjEI:APA91bFCqL8pm7_slVtI0E0aU2IxOeZchwXc-dLzOqQzXYNHt-5UW6nIqiMEa7iy8khgXJKY5FXk5dKgbVoiXOakDkbfhsgMNOizkKPL9oQUPKHOh6ATsvoVxZXMBVzldcLxsMJezOkX";

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true, announcement: false, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("granted permission!!");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("granted provisional!!");
    } else
      print("granted declined!!");
  }

//Notification#1
  void onDidReceiveNotificationResponse(
      BuildContext context, RemoteMessage message) {
    print("inside onDidReceiveNotificationResponse");
    print(message.notification!.title.toString());

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BookingListScreen()));
    print("navigation comlete");
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialeMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialeMessage != null) {
      onDidReceiveNotificationResponse(context, initialeMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      onDidReceiveNotificationResponse(context, event);
    });
  }

  void initalize(BuildContext context, RemoteMessage message) async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/launcher_icon"));

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        print("payload is : $payload");
        onDidReceiveNotificationResponse(context, message);
      },
    );
  }

  void onRecieveNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      initalize(context, message);
      display(message);
      print("after display is called ");
    });
  }

  Future<void> display(RemoteMessage message) async {
    print("inside display berfore try");

    try {
      print("inside display");
      Random random = new Random();
      int id = random.nextInt(1000);

      AndroidNotificationChannel channel =
          AndroidNotificationChannel(id.toString(), "mychanel");

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id.toLowerCase(), channel.name.toString(),
              importance: Importance.max,
              priority: Priority.high,
              ticker: "ticker"));

      Future.delayed(Duration.zero, () {
        _flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
        );
        print("displying ");
      });
    } catch (e) {
      print("something went wrong");
    }
  }

//Notification2
  final FlutterLocalNotificationsPlugin
      _flutterLocalReminderNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void onDidReceiveReminderNotificationResponse(
      BuildContext context, RemoteMessage message, String userType) {
    print(
        "inside onDidReceiveReminderNotificationResponse userTypeis : $userType");

    if (userType == "lawyer") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BookingListScreen()));
      print("navigation comlete");
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BookingClientScreen()));
      print("navigation comlete");
    }
  }

  void initalizeReminderNotification(
      BuildContext context, RemoteMessage message, String userType) async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/launcher_icon"));

    await _flutterLocalReminderNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        print("payload is : $payload");
        onDidReceiveReminderNotificationResponse(context, message, userType);
      },
    );
  }

  Future<void> setupInteractMessageReminder(
      BuildContext context, String userType) async {
    RemoteMessage? initialeMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialeMessage != null) {
      onDidReceiveReminderNotificationResponse(
          context, initialeMessage, userType);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      onDidReceiveReminderNotificationResponse(context, event, userType);
    });
  }

  void onRecieveReminderNotification(BuildContext context, String userType) {
    FirebaseMessaging.onMessage.listen((message) {
      initalizeReminderNotification(context, message, userType);
      print("initalizeReminderNotification");
      displayReminder(message);
      print("after display is called ");
    });
  }

  Future<void> displayReminder(RemoteMessage message) async {
    print("inside display remider");

    try {
      print("inside display reminder");
      Random random = new Random();
      int id = random.nextInt(1000);

      AndroidNotificationChannel channel =
          AndroidNotificationChannel(id.toString(), "mychanel");

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id.toLowerCase(), channel.name.toString(),
              importance: Importance.max,
              priority: Priority.high,
              ticker: "ticker"));

      Future.delayed(Duration.zero, () {
        _flutterLocalReminderNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
        );
        print("displying ");
      });
    } catch (e) {
      print("something went wrong");
    }
  }

  // called after booking is completed  ---> inside Payment page
  void sendPushMessage(String? token, String body, String title) async {
    try {
      print('inside TRY HHHmmHHHH');
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "done",
              "message": body,
              'title': title,
            },
            'to': '$token'
          }));

      print("inside send");
    } catch (e) {
      print('inside catch HHHHmmHHH');
    }
  }
}

class Token {
  Future<void> getLawyerTokenAndSend(String email) async {
    String token = '';
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('lawyers').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('email')) {
        final lawyerEmail = data['email'] as String;
        if (lawyerEmail == email) {
          token = data['token'] as String;

          print("Token prined  $token from dB");
        }
      }
    }
    print(" $token before sending");

    Notifications()
        .sendPushMessage(token, "قانوني", "لديك موعد جديد, اطلع عليه الآن");
  }

  Future<void> updateTokenInDB(
      String? email, bool loggingIn, String userType) async {
    try {
      String? newToken = await FirebaseMessaging.instance.getToken();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userType)
          .where('email', isEqualTo: email) // Specify the condition here
          .get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        String documentId = document.id; // Get the document ID
        print('Document ID: $documentId');

        if (loggingIn) {
          print("logging in");
          // Update the 'token' field with the new token value
          await FirebaseFirestore.instance
              .collection(userType)
              .doc(documentId)
              .update({
            'token': newToken,
          });
        } else {
          print("logging out");
          // Update the 'token' field with the new token value
          await FirebaseFirestore.instance
              .collection(userType)
              .doc(documentId)
              .update({
            'token': "",
          });
        }
      }
      print("User token : $newToken");
    } catch (e) {
      print('Error: $e');
    }
  }
}

class ReminderNotification {
  Future<void> sendReminder(String? email, String userType) async {
    String token = '';
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(userType).get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('email')) {
        final userEmail = data['email'] as String;
        if (userEmail == email) {
          token = data['token'] as String;

          print("Token prined  $token from dB");
        }
      }
    }
    print(" $token before sending");

    Notifications()
        .sendPushMessage(token, "قانوني", "تذكير: لديك موعد بعد ساعة من الآن ");
  }

  Future<void> checkStartTimes(String userType, String userTypeEmail) async {
    String? email = "";
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;
    }

    //get current time
    DateTime now = DateTime.now();
    print("time now is : $now");

    if (user != null && email != "") {
      //check from DB
      final _db = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot =
          await _db.collection('bookings').get();
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (QueryDocumentSnapshot doc in documents) {
        final data = doc.data() as Map<String, dynamic>; // Access data as a Map
        if (data.containsKey(userTypeEmail)) {
          final userEmail = data[userTypeEmail] as String;
          if (userEmail == email) {
            if (data.containsKey('startTime')) {
              final time = data['startTime'].toDate();
              Duration difference = time.difference(now);
              print("dif time: " + difference.inHours.toString());
              //if after 1 hour
              if (difference.inHours < -390) {
                sendReminder(email, userType);
                break;
              } //if diff
            }
          } //if userEmail...
        }
      } //end for loop
    }
  }
}
