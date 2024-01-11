import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionService{
  Future requestPermission(Permission permission) async {
    var status = await permission.request();//.then((status) {
      log('per ${permission.toString()}: ${status.isGranted}');
      // if (status.isDenied) {
      //   final status = await permission.request();
      // }
    // }
    // );
  }



  Future<bool> hasPermission(Permission permission) async {
    var permissionStatus =
    await permission.isGranted;
    return permissionStatus == PermissionStatus.granted;
  }
}