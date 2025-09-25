import 'dart:ui';

import 'color_utils.dart';

class LightTheme implements ColorPallete {
  @override
  Color get highPriority => Color(0xffE7526E);

  @override
  Color get lowPriority => Color(0xff17BD81);

  @override
  Color get mediumPriority => Color(0xffF7C732);

  @override
  Color get primaryColor => Color(0xffFFFFFF);

  @override
  Color get secondaryColor => Color(0xff1D1B4D);

  @override
  Color get quatenaryColor => Color(0xff5A6AFF);

  @override
  Color get teritaryColor => Color(0xff1B1F4C);

  @override
  Color get titleTextColor => Color(0xff727F8D);
}
