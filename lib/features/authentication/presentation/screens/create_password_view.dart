import 'dart:developer';

import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/common_elevated_button.dart';
import 'package:faceapp/core/widgets/common_snack_bar.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:faceapp/features/authentication/bloc/register_bloc/register_bloc.dart';
import 'package:faceapp/features/authentication/presentation/screens/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../widgets/app_bar_back_button.dart';
import '../widgets/custom_text_form_field.dart';

class CreatePasswordView extends StatefulWidget {
  const CreatePasswordView({super.key});

  @override
  State<CreatePasswordView> createState() => _CreatePasswordViewState();
}

class _CreatePasswordViewState extends State<CreatePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscurePassword = !_isObscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isObscureConfirmPassword = !_isObscureConfirmPassword;
    });
  }

  String? _validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#$!%*?&_]).{8,}$');

    if (value!.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password should have at least 8 characters';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value!.isEmpty || value != _passwordController.text) {
      return 'Password is not match';
    }
    return null;
  }

  void _submitForm(RegisterBloc registerBloc) {
    if (_formKey.currentState!.validate()) {
      registerBloc.add(CreatePasswordEvent(_passwordController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerBloc = BlocProvider.of<RegisterBloc>(context);
    Widget body = GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalGapWidget(
                        AppPaddings.p24.h,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: 'Password',
                        isCapitalize: false,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppPaddings.p16,
                            right: AppPaddings.p12,
                          ),
                          child: SvgPicture.asset(
                            Assets.passwordIcon,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppPaddings.p16,
                            right: AppPaddings.p12,
                          ),
                          child: GestureDetector(
                            onTap: _togglePasswordVisibility,
                            child: SvgPicture.asset(
                              _isObscurePassword
                                  ? Assets.eyeOpen
                                  : Assets.eyeClosed,
                            ),
                          ),
                        ),
                        obscureText: _isObscurePassword,
                        validator: _validatePassword,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      VerticalGapWidget(
                        AppPaddings.p16.h,
                      ),
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        isCapitalize: false,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppPaddings.p16,
                            right: AppPaddings.p12,
                          ),
                          child: SvgPicture.asset(
                            Assets.passwordIcon,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppPaddings.p16,
                            right: AppPaddings.p12,
                          ),
                          child: GestureDetector(
                            onTap: _toggleConfirmPasswordVisibility,
                            child: SvgPicture.asset(
                              _isObscureConfirmPassword
                                  ? Assets.eyeOpen
                                  : Assets.eyeClosed,
                            ),
                          ),
                        ),
                        obscureText: _isObscureConfirmPassword,
                        validator: _validateConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      VerticalGapWidget(
                        AppPaddings.p24.h,
                      ),
                      Text(
                         textScaleFactor: 1.0,
                        '\u2022 Password should be minimum 8 characters',
                        style: context.theme.textTheme.labelSmall!,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                         textScaleFactor: 1.0,
                        '\u2022 At least one upper case & one lower case character',
                        style: context.theme.textTheme.labelSmall!,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                         textScaleFactor: 1.0,
                        '\u2022 At least one number & one special character (@,#,!,%,*,?,&,_,\$)',
                        style: context.theme.textTheme.labelSmall!,
                        textAlign: TextAlign.start,
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      BlocBuilder<RegisterBloc, RegisterState>(
                        buildWhen: (pre, current) =>
                            pre.submitting != current.submitting,
                        builder: (context, state) {
                          return CustomElevatedButtonWidget(
                            buttonText: 'Create Password',
                            onPressed: () => _submitForm(registerBloc),
                            isSubmitting: state.submitting,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Widget listeners = MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (pre, current) =>
              pre.registerStatus == RegisterStatus.initiated &&
              pre.registerStatus != current.registerStatus,
          listener: (context, state) {
            if (state.registerStatus == RegisterStatus.submitted) {
              log("CreatePasswordView -> BlocListener ${state.registerStatus}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: registerBloc,
                    child: const VerifyEmailView(),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error != "") {
              log(state.error);
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(context, state.error),
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
          'Create Password',
          style: context.theme.textTheme.titleMedium!.copyWith(
            fontSize: 17.sp,
          ),
        ),
        leadingWidget: const AppBarBackButton(),
        isHomeRedirectEnable: false,
      ),
      pageBody: listeners,
    );
  }
}
