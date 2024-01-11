import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs_and_cubits/time_format/time_format_cubit.dart';
import '../themes_and_styles/styles_constants.dart';

class PrayerTimeWidget extends StatelessWidget{
  final name;
  String? time;
  // int timeFormat=12;
  final PrayerTimeTextStyle? style;

  String? timeResult;

   PrayerTimeWidget({required this.name, required this.time, this.style, String? timeResult});
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    PrayerTimeTextStyle? defaultStyle = Theme.of(context).extension<PrayerTimeTextStyle>()!;
    // double fontSize = style?.fontSize ?? defaultStyle?.fontSize;
    TextStyle textStyle = style?.textStyle ?? defaultStyle?.textStyle;

    // return FutureBuilder(
      // builder: (BuildContext ctx, AsyncSnapshot<int> snapshot) {

        return BlocBuilder<TimeFormatCubit, TimeFormatChangedState>(
            builder: (context, timeFormatState) {
        // log('futeare');
        // if(snapshot.data != null) {
          // log('timeFormat: ${snapshot.data}');
          // timeFormat = snapshot.data!;
          // log('time first: ${time.toString().substring(0,2)}h');
          // log('time second: ${(int.parse(time.toString().substring(0,2)) %12).toString()}  ${time!.substring(2)}' );
          //  timeFormat == timeFormatState.timeFormat ? time= '${(int.parse(time.toString().substring(0,2)) %12).toString()}${time!.substring(2)}' : time;
          // log('timeFormat: ${timeFormatState.timeFormat}');
              if ( time != null) {
                timeResult = time;
                if (timeFormatState.timeFormat == 12) {
                  String hoursStr = time.toString().substring(0, 2);
                  // log('hoursStr: ${hoursStr}');
                  int hours = int.parse(hoursStr) % 12;
                  String mins = time.toString().substring(2);

                  timeResult = hours.toString() + mins;
                }
                // log('time: ${name}');

                return
                  Container(

                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: isDark? Colors.black.withOpacity(0.5): Colors.grey.withOpacity(0.6),
                          spreadRadius: 0.5,
                          blurRadius: 7,
                          offset: const Offset(
                              1, 1), // changes position of shadow
                        ),
                      ],
                      color: isDark? Colors.grey.shade900 : Colors.white,
                    ),
                    child: Row(
                      children: [

                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child:
                            Text(name,
                                style: textStyle
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                              alignment: Alignment.center,
                              child:
                              Text(timeResult!,
                                  style: textStyle
                              )

                          ),
                        ),
                      ],
                    ),
                  );
                // );
              }else return SizedBox();
        }

        );
          // return SizedBox();
        }
      // },
      // future: TimeFormatHelper().getCachedTimeFormat(),
    // );


  // }

}

