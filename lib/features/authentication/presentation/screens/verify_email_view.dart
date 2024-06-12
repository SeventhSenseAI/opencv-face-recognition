import 'dart:developer';

import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:faceapp/features/authentication/bloc/register_bloc/register_bloc.dart';
import 'package:faceapp/features/authentication/presentation/screens/verify_phone_number.dart';
import 'package:faceapp/features/authentication/presentation/widgets/otp_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../widgets/app_bar_back_button.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final registerBloc = BlocProvider.of<RegisterBloc>(context);

    Widget body = GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            VerticalGapWidget(
              AppPaddings.p24.h,
            ),
            Text(
               textScaleFactor: 1.0,
              'To complete the verification process, please enter the verification code received at',
              style: context.theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (pre, current) =>
                  pre.registerInfo.email != current.registerInfo.email ||
                  pre.registerInfo != current.registerInfo,
              builder: (context, state) {
                return Text(
                   textScaleFactor: 1.0,
                  state.registerInfo.email,
                  style: context.theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: ColorCodes.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            VerticalGapWidget(
              AppPaddings.p36.h,
            ),
            BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (pre, current) =>
                  pre.registerStatus != current.registerStatus,
              builder: (context, state) {
                log("VerifyEmailView -> OTPCodeWidget ${state.registerStatus}");
                return OTPCodeWidget(
                  onCompleted: (_) {
                    log("OTP $_");
                    registerBloc.add(VerifyOTPEvent('email', _));
                  },
                  onTap: () {
                    registerBloc.add(
                      ChangeRegisterStatusEvent(RegisterStatus.submitted),
                    );
                  },
                  isError: state.registerStatus == RegisterStatus.otpError,
                );
              },
            ),
            BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (pre, current) =>
                  pre.registerStatus != current.registerStatus,
              builder: (context, state) {
                return state.registerStatus == RegisterStatus.otpError
                    ? Text(
                       textScaleFactor: 1.0,
                        state.error,
                        style: context.theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w300,
                          color: ColorCodes.redColor,
                        ),
                      )
                    : const SizedBox();
              },
            ),
            const VerticalGapWidget(AppPaddings.p12),
            const Expanded(
              child: SizedBox.shrink(),
            ),
            BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (pre, current) =>
                  pre.remainingSecForResend != current.remainingSecForResend,
              builder: (context, state) {
                if (state.remainingSecForResend == 0) {
                  return GestureDetector(
                    onTap: () {},
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Didn’t receive the code? ',
                            style: context.theme.textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                registerBloc.add(SendOTPEvent('email'));
                              },
                              child: Text(
                                 textScaleFactor: 1.0,
                                'Resend',
                                style: context.theme.textTheme.titleSmall!
                                    .copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final mins = state.remainingSecForResend ~/ 60;
                final secs = state.remainingSecForResend % 60;
                return SizedBox(
                  child: Text(
                     textScaleFactor: 1.0,
                    'Time remaining $mins:$secs',
                    style: context.theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                );
              },
            ),
            const VerticalGapWidget(AppPaddings.p16),
          ],
        ),
      ),
    );

    Widget listeners = MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (pre, current) =>
              pre.registerStatus == RegisterStatus.submitted &&
              pre.registerStatus != current.registerStatus,
          listener: (context, state) {
            log("VerifyEmailView -> BlocListener${state.registerStatus}");
            if (state.registerStatus == RegisterStatus.emailVerified) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: registerBloc,
                    child: const VerifyPhoneNumberView(),
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: body,
    );

    return CommonPageBoilerPlate(
      commonAppBar: CommonAppBar(
        titleWidget: Text(
           textScaleFactor: 1.0,
          'Verify Email Address',
          style: context.theme.textTheme.titleMedium!.copyWith(
            fontSize: 17.sp,
          ),
        ),
        isHomeRedirectEnable: false,
        leadingWidget: AppBarBackButton(
          backButtonOnTap: () {
            registerBloc
                .add(ChangeRegisterStatusEvent(RegisterStatus.initiated));
            Navigator.pop(context);
          },
        ),
      ),
      pageBody: listeners,
    );
  }
}
