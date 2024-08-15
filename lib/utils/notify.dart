import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

class NotifyUtil {

static void notifyInfo(BuildContext context, String text) {
    var notification = ElegantNotification.info(
      description: Text(text),
      toastDuration: const Duration(milliseconds: 2000),
      animation: AnimationType.fromTop,
      dismissDirection: DismissDirection.up,
      position: Alignment.topCenter,
      notificationMargin: 50,
      height: 80,
    );
    if (context.mounted) {
      notification.show(context);
    }
  }

}
