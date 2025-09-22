import 'package:get_it/get_it.dart';
import 'package:todo_app/core/theme/light_theme.dart';

final sl = GetIt.instance;

void init() {
  /// bloc
  /// Repository
  /// Data source
  /// External
  sl.registerLazySingleton(() => LightTheme());
}
