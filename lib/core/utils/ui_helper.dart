import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/injection_container.dart';

class UiHelper {
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 40.h,
          child: Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                size: 20,
                color: sl<LightTheme>().primaryColor,
              ),
              SizedBox(width: 12.w),
              Text(
                message,
                style: TextStyle(color: sl<LightTheme>().primaryColor),
              ),
            ],
          ),
        ),
        backgroundColor: sl<LightTheme>().highPriority,
        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showErrorFlashBar(
    BuildContext context,
    String message, [
    VoidCallback? onClose,
  ]) {
    context.showFlash<bool>(
      builder: (context, controller) => FlashBar(
        controller: controller,
        forwardAnimationCurve: Curves.easeIn,
        reverseAnimationCurve: Curves.linear,
        behavior: FlashBehavior.floating,
        position: FlashPosition.bottom,
        margin: EdgeInsets.all(12.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        indicatorColor: Colors.transparent,
        backgroundColor: sl<LightTheme>().highPriority,
        content: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: sl<LightTheme>().primaryColor,
            ),
            SizedBox(width: 24.w),
            Text(
              message,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: sl<LightTheme>().primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                controller.dismiss();
                onClose?.call();
              },
              child: Icon(
                Icons.clear,
                color: sl<LightTheme>().primaryColor,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
