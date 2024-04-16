import 'package:flutter/material.dart';
import 'package:notes/common/dimensions.dart';
import 'package:notes/common/widgets.dart';


class RetryFailedLoading extends StatelessWidget {
  final String? message;
  final String? retryButtonTitle;
  final VoidCallback onRetryPressed;
  final bool isRetryLoading;
  final bool isFailedWidget;
  final EdgeInsetsGeometry? padding;

  const RetryFailedLoading(
      {super.key,
      this.message,
      this.retryButtonTitle,
      required this.onRetryPressed,
      this.isRetryLoading = false,
      this.isFailedWidget = true,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/failure_illustration.png',
              width: Dimensions.setSize(200),
              height: Dimensions.setSize(200),
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: PaddingDimensions.large,
            ),
            Text(
              //todo:localization
              message ?? "You connection seems off..",
              style: TextStyle(
                fontSize: Dimensions.xxLarge,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: PaddingDimensions.normal,
            ),
            Text(
              //todo:localization
              "Check your WiFi or data connection",
              style: TextStyle(
                fontSize: Dimensions.xLarge,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: PaddingDimensions.large,
            ),
            if (isFailedWidget)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.pageMargins),
                child: defaultButton(
                  text: retryButtonTitle ?? "Reload page",
                  function: onRetryPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
