import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(
      'State change detected',
      name: bloc.runtimeType.toString(),
      error: change,
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(
      'Transition detected',
      name: bloc.runtimeType.toString(),
      error: transition,
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('Error in ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
  }
}
