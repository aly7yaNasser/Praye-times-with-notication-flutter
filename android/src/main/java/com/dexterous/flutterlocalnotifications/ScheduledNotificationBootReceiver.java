package android.src.main.java.com.dexterous.flutterlocalnotifications;

import android.*;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.Keep;

@Keep
public class ScheduledNotificationBootReceiver extends BroadcastReceiver {
  @Override
  @SuppressWarnings("deprecation")
  public void onReceive(final Context context, Intent intent) {
    String action = intent.getAction();
    if (action != null) {
      if (action.equals(android.content.Intent.ACTION_BOOT_COMPLETED)
          || action.equals(Intent.ACTION_MY_PACKAGE_REPLACED)
          || action.equals("android.intent.action.QUICKBOOT_POWERON")
          || action.equals("com.htc.intent.action.QUICKBOOT_POWERON")) {
        FlutterLocalNotificationsPlugin.rescheduleNotifications(context);
      }
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            Log.v("DVIC?","not S5");


      notification = new NotificationChannel("3", string, NotificationManager.IMPORTANCE_HIGH);
//            audioManager.setRingerMode(AudioManager.RINGER_MODE_SILENT);

      notification.setDescription(string);
      notification.setLockscreenVisibility(3);
      notification.setName("R.string.app_name");
      notification.setSound(null,null);

      notification.setDescription("string");
      notification.enableVibration(false);
      manager.createNotificationChannel(notification);
      Intent cancelIntent = new Intent(context, CancelBrodcast.class);
      cancelIntent.setAction("Cancel");
      PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 4, cancelIntent, 0);
//        Notification.Action action = new Notification.Action(R.drawable.icons8mosque48,getString(R.string.cancel),pendingIntent);

      NotificationCompat.Builder notificationCompat = new NotificationCompat.Builder(context, "3");
      notificationCompat.setSmallIcon(R.drawable.icons8);
      notificationCompat.setContentTitle(context.getString(R.string.app_name));
      notificationCompat.addAction(0,"Cancel",cancelPT);


//        notificationCompat.addAction(new NotificationCompat.Action(R.drawable.ic_launcher_background,"can",pendingIntent));
      notificationCompat.setNotificationSilent();

      notificationCompat.setContentText(string);
      manager.createNotificationChannel(notification);
      if (id != 010) {
        manager.notify(id, notificationCompat.build());
      }            return notificationCompat.build();
//

    } else {
//            Log.v("DVIC?"," S5");

      Intent cancelIntent = new Intent(context, CancelBrodcast.class);
      cancelIntent.setAction("Cancel");
      PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 4, cancelIntent, 0);
//        Notification.Action action = new Notification.Action(R.drawable.icons8mosque48,getString(R.string.cancel),pendingIntent);

      NotificationCompat.Builder notificationCompat = new NotificationCompat.Builder(context, "3");
      notificationCompat.setSmallIcon(R.drawable.common_google_signin_btn_icon_dark);
      notificationCompat.setContentTitle(context.getString(R.string.app_name));
//            notificationCompat.setSound(null);
      notificationCompat.setNotificationSilent();

//        notificationCompat.addAction(new NotificationCompat.Action(R.drawable.ic_launcher_background,"can",pendingIntent));
      notificationCompat.setContentText(string);
      if (id != 010) {
        manager.notify(id, notificationCompat.build());
      }
      return notificationCompat.build();

    }
  }
}
