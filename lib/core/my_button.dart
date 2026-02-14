import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mspace/utils/color_constants.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final LinearGradient? gradient;
  final double height;
  final double width;
  final bool showGradient;
  final List<BoxShadow>? shadow;
  final bool isLoading;
  final TextStyle? style;
  final EdgeInsetsGeometry? margin;
  final Color loaderColor;
  final Widget? icon;
  final BoxBorder? border;
  final Color? textColor;
  final VoidCallback? testingPurpose;
  final BorderRadiusGeometry? borderRadius;
  final String? text;
  final VoidCallback? onTap;
  final double? fontSize;
  final double? radius;
  const CustomButton(
      {Key? key,
      this.color,
      this.gradient,
      this.testingPurpose,
      this.textColor,
      this.border,
      this.fontSize,
      this.icon,
      this.loaderColor = Colors.white,
      this.shadow,
      this.margin,
      this.showGradient = true,
      this.isLoading = false,
      this.radius,
      this.style,
      this.height = 60,
      this.width = 315,
      this.text,
      this.onTap,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: testingPurpose,
      onTap: isLoading ? () {} : onTap,
      child: Container(
        height: height,
        margin: margin,
        width: width,
        decoration: BoxDecoration(
          boxShadow: shadow ??
              [
                const BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 22,
                  // blurStyle: BlurStyle.,
                  color: Color(0x4c95ADFE),
                  spreadRadius: 0,
                )
              ],
          borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 10),
         // color: color ?? ColorConstants.tabColor,
          border: border,
        ),
        child:
        //  isLoading
        //     ? SpinKitCircle(
        //         color: loaderColor,
        //       )
        //     :
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox(),
                  text != null
                      ? Text(
                          text!,
                          style: style ??
                              TextStyle(
                                color: textColor ?? Colors.white,
                                fontSize: fontSize ?? 20,
                                fontWeight: FontWeight.w500,
                              ),
                        )
                      : const SizedBox()
                ],
              ),
      ),
    );
  }
}
