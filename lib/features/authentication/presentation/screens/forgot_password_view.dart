import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/font_family.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/common_elevated_button.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:faceapp/features/authentication/presentation/screens/reset_link_sent_view.dart';
import 'package:faceapp/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../widgets/custom_dropdown_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final List<String> _dropdownItems = ['Singapore', 'Europe', 'United States'];
  String _selectedItem = 'Singapore';

  String? _validateEmail(String? value) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

    if (value!.isEmpty || !emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void _submitForm(AuthBloc authBloc) {
    if (_formKey.currentState!.validate()) {
      authBloc.add(ForgotPasswordEvent(_emailController.text, _selectedItem));
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
                    SizedBox(
                      height: 151.5.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                             textScaleFactor: 1.0,
                            "Forgot Password",
                            style: context.theme.textTheme.titleLarge!.copyWith(
                              fontFamily: FontsFamily.satoshi,
                            ),
                          ),
                          VerticalGapWidget(
                            AppPaddings.p28.h,
                          ),
                          CustomTextFormField(
                            controller: _emailController,
                            hintText: 'Organizational Email',
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
                          VerticalGapWidget(
                            AppPaddings.p16.h,
                          ),
                          BlocBuilder<AuthBloc, AuthState>(
                            buildWhen: (pre, current) =>
                                pre.submitting != current.submitting,
                            builder: (context, state) {
                              return CustomElevatedButtonWidget(
                                buttonText: 'Send Password Reset Link',
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
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                       textScaleFactor: 1.0,
                      'Remember your password?',
                      style: context.theme.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: AppPaddings.p16.h,
                    ),
                    InkWell(
                      onTap: () => {
                        Navigator.pop(context),
                      },
                      child: Text(
                         textScaleFactor: 1.0,
                        "Sign In Now!",
                        style: context.theme.textTheme.titleSmall!.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
          listenWhen: (pre, current) =>
              pre.sentResetLink != current.sentResetLink,
          listener: (context, state) {
            if (state.sentResetLink) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResetLinkSentView(),
                ),
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
