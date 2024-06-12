import 'dart:developer';

import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/font_family.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/common_elevated_button.dart';
import 'package:faceapp/core/widgets/common_snack_bar.dart';
import 'package:faceapp/core/widgets/gap_widgets/horizontal_gap_consistent.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:faceapp/features/authentication/bloc/register_bloc/register_provider.dart';
import 'package:faceapp/features/authentication/presentation/screens/forgot_password_view.dart';
import 'package:faceapp/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../widgets/custom_dropdown_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  final List<String> _dropdownItems = ['Singapore', 'Europe', 'United States'];
  String _selectedItem = 'Singapore';

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  String? _validateEmail(String? value) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

    if (value!.isEmpty || !emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final RegExp regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$!%*?&_])[a-zA-Z\d@#$!%*?&_]{8,}$',
    );
    if (value!.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password should have at least 8 characters';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid password';
    }
    return null;
  }

  void _submitForm(AuthBloc authBloc) {
    if (_formKey.currentState!.validate()) {
      authBloc.add(
        LoginUserEvent(
          email: _emailController.text.toLowerCase(),
          password: _passwordController.text,
          region: _selectedItem,
        ),
      );
    }
  }

  void _subscriptionButtonAction() async {
    const url = ApiConstants.contactUs;
    try {
      await launch(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar.showErrorSnackBar(context, 'Error launching URL: $e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

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
                child: Column(
                  children: [
                    const VerticalGapWidget(AppPaddings.p16),
                    SizedBox(
                      height: 48.h,
                      width: 51.28.w,
                      child: SvgPicture.asset(
                        Assets.logo,
                      ),
                    ),
                    VerticalGapWidget(
                      151.5.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                             textScaleFactor: 1.0,
                            "Login",
                            style: context.theme.textTheme.titleLarge!.copyWith(
                              fontFamily: FontsFamily.satoshi,
                            ),
                          ),
                          VerticalGapWidget(
                            AppPaddings.p28.h,
                          ),
                          CustomTextFormField(
                            controller: _emailController,
                            hintText: 'Email Address',
                            isCapitalize: false,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: AppPaddings.p16,
                                right: AppPaddings.p12,
                              ),
                              child: SvgPicture.asset(
                                Assets.emailIcon,
                              ),
                            ),
                            validator: _validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          VerticalGapWidget(
                            AppPaddings.p16.h,
                          ),
                          CustomDropDownField(
                            dropdownItems: _dropdownItems,
                            selectedItem: _selectedItem,
                            onChanged: (_) {
                              setState(() {
                                _selectedItem = _!;
                              });
                            },
                          ),
                          VerticalGapWidget(
                            AppPaddings.p16.h,
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
                                  _isObscure
                                      ? Assets.eyeOpen
                                      : Assets.eyeClosed,
                                ),
                              ),
                            ),
                            obscureText: _isObscure,
                            validator: _validatePassword,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          VerticalGapWidget(
                            AppPaddings.p16.h,
                          ),
                          BlocBuilder<AuthBloc, AuthState>(
                            buildWhen: (pre, current) =>
                                pre.submitting != current.submitting,
                            builder: (context, state) {
                              return CustomElevatedButtonWidget(
                                buttonText: 'Login',
                                onPressed: () => _submitForm(authBloc),
                                isSubmitting: state.submitting,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    VerticalGapWidget(
                      AppPaddings.p24.h,
                    ),
                    InkWell(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordView(),
                          ),
                        ),
                      },
                      child: Text(
                         textScaleFactor: 1.0,
                        "Forgot Password",
                        style: context.theme.textTheme.titleSmall!.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                           textScaleFactor: 1.0,
                          'Don’t have an account?',
                          style: context.theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        HorizontalGapWidget(
                          AppPaddings.p16.w,
                        ),
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterProvider(),
                              ),
                            ),
                          },
                          child: Text(
                             textScaleFactor: 1.0,
                            "Sign Up Now!",
                            style: context.theme.textTheme.titleSmall!.copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    VerticalGapWidget(AppPaddings.p16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                           textScaleFactor: 1.0,
                          'Require further assistance?',
                          style: context.theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        HorizontalGapWidget(
                          AppPaddings.p16.w,
                        ),
                        InkWell(
                          onTap: () => {
                            _subscriptionButtonAction(),
                          },
                          child: Text(
                             textScaleFactor: 1.0,
                            "Contact Us",
                            style: context.theme.textTheme.titleSmall!.copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VerticalGapWidget(AppPaddings.p16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    Widget listeners = MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
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
      pageBody: listeners,
    );
  }
}
