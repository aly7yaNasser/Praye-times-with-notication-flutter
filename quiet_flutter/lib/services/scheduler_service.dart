
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:workmanager/workmanager.dart';

import 'notification_service.dart';

class  SchedulerService {
  static const myTask = "syncWithTheBackEnd";

  static void callbackDispatcher() {
// this method will be called every hour
    Workmanager().executeTask((task, inputdata) async {
      log('task');

      // NotificationService().showNotification(title: 'Prayer Time', body: 'Allah akbar');
      // switch (task) {
      //   case myTask:
      //     print("this method was called from native!");
      //
      //     Fluttertoast.showToast(msg: "this method was called from native!");
      //     break;
      //
      //   case Workmanager.iOSBackgroundTask:
      //     print("iOS background fetch delegate ran");
      //     break;
      // }

      //Return true when the task executed successfully or not
      return Future.value(true);
    });
  }
}