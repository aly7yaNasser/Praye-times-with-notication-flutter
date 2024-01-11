import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? _subscription;
  InternetBloc() : super(InternetInitial()) {
    on<InternetEvent>((event, emit) {


      if (event is ConnectedEvent) {
        emit(ConnectedState(message: "Connected"));
      } else if (event is NotConnectedEvent) {
        emit(NotConnectedState(message: "Not Connected"));
      }else{
        // log('Event: InternetEvent');

        var result = Connectivity().checkConnectivity().then((ConnectivityResult result) async {
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            // try {
            //   final result = await InternetAddress.lookup('example.com');
            //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            add(ConnectedEvent());
            // }
            // } on SocketException catch (_) {
            // }

          } else {
            add(NotConnectedEvent());
          }
        });
      }
    });

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        // try {
        //   final result = await InternetAddress.lookup('example.com');
        //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            add(ConnectedEvent());
      // }
        // } on SocketException catch (_) {
        // }

      } else {
        add(NotConnectedEvent());

      }
    });
  }
  @override
  Future<void> close() {
    _subscription!.cancel();
    return super.close();
  }
}