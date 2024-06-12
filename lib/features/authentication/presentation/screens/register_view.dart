import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:faceapp/core/constants/api_constants.dart';
import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/constants/email_validate.dart';
import 'package:faceapp/core/utils/assets.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/common_elevated_button.dart';
import 'package:faceapp/core/widgets/common_snack_bar.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:faceapp/features/authentication/bloc/register_bloc/register_bloc.dart';
import 'package:faceapp/features/authentication/presentation/screens/create_password_view.dart';
import 'package:faceapp/features/authentication/presentation/widgets/app_bar_back_button.dart';
import 'package:faceapp/features/authentication/presentation/widgets/custom_dropdown_field.dart';
import 'package:faceapp/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:faceapp/features/authentication/presentation/widgets/phone_number_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _phoneNumberCodeController =
      TextEditingController();
  final List<String> _dropdownItems = ['Singapore', 'Europe', 'United States'];
  String? _selectedItem;
  bool _isAcceptTerms = false;
  String _selectedCountry = "US";

  @override
  void initState() {
    super.initState();
    _phoneNumberCodeController.text = '+1';
  }

  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

    if (value!.isEmpty || !emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    if (EmailValidate.isFreeEmail(value)) {
      return 'Use organizational email to sign up';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final numberRegExp = RegExp(r'^[0-9]+$');
    if (value!.isEmpty || !numberRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    String phoneNumber =
        _phoneNumberCodeController.text + _phoneNumberController.text;
    final number = PhoneNumber.parse(
      phoneNumber,
      callerCountry: IsoCode.fromJson(_selectedCountry),
    );
    final valid = number.isValid();
    if (!valid) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  void handleCountryCodeChanged(CountryCode countryCode) {
    _selectedCountry = countryCode.code!;
  }

  String? _validateRegion(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please choose an option';
    }
    return null;
  }

  void _submitForm(RegisterBloc registerBloc) {
    if (_formKey.currentState!.validate()) {
      registerBloc.add(
        CreateRegisterInfoEvent(
          _firstNameController.text,
          _lastNameController.text,
          _companyNameController.text,
          _emailController.text,
          _phoneNumberCodeController.text + _phoneNumberController.text,
          _selectedItem!,
        ),
      );
      if (!_isAcceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar.showErrorSnackBar(context, 'Accept Terms of Service'),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: registerBloc,
              child: const CreatePasswordView(),
            ),
          ),
        );
      }
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
                        controller: _firstNameController,
                        maxLength: 50,
                        hintText: 'First Name',
                        isCapitalize: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppPaddings.p16,
                            right: AppPaddings.p12,
                          ),
                          child: SvgPicture.asset(
                            Assets.userIcon,
                          ),
                        ),
                        validator: _validateName,
                      ),
                      VerticalGapWidget(
                        AppPaddings.p16.h,
                      ),
                      CustomTextFormField(
                        controller: _lastNameController,
                        maxLength: 50,
                        hintText: 'Last Name',
                        isCapitalize: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppPaddings.p16,
                            right: AppPaddings.p12,
                          ),
                          child: SvgPicture.asset(
                            Assets.userIcon,
                          ),
                        ),
                        validator: _validateName,
                      ),
                      VerticalGapWidget(
                        AppPaddings.p16.h,
                      ),
                      CustomTextFormField(
                        controller: _companyNameController,
                        maxLength: 50,
                        hintText: 'Company Name (Optional)',
                        isCapitalize: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppPaddings.p16,
                            right: AppPaddings.p12,
                          ),
                          child: SvgPicture.asset(
                            Assets.organizationIcon,
                          ),
                        ),
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
                        validator: _validateRegion,
                      ),
                      VerticalGapWidget(
                        AppPaddings.p16.h,
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
                      CustomTextFormField(
                        controller: _phoneNumberController,
                        hintText: 'XX XXX XXXX',
                        isCapitalize: false,
                        prefixIcon: PhoneNumberCodePicker(
                          textEditingController: _phoneNumberCodeController,
                          initSelection: 'US',
                          onCountryCodeChanged: handleCountryCodeChanged,
                        ),
                        maxWidth: 185.w,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                      ),
                      Expanded(
                        child: VerticalGapWidget(
                          20.h,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isAcceptTerms = !_isAcceptTerms;
                                  });
                                },
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(
                                      color: ColorCodes.whiteColor, // Border color
                                      width: 2.5.sp,
                                    ),
                                    color: Colors.transparent, // Fill color
                                  ),
                                  child: _isAcceptTerms
                                      ? const Icon(
                                          Icons.check,
                                          size: 14.0,
                                          color: ColorCodes.whiteColor,
                                        )
                                      : Container(),
                                ),
                              ),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isAcceptTerms = !_isAcceptTerms;
                                  });
                                },
                                child: Text(
                                   textScaleFactor: 1.0,
                                  '  I agree to the ',
                                  style: context.theme.textTheme.labelSmall,
                                ),
                              ),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () =>
                                    _openLink(ApiConstants.termsAndConditions),
                                child: Text(
                                   textScaleFactor: 1.0,
                                  'Terms of Service',
                                  style: context.theme.textTheme.labelSmall!
                                      .copyWith(
                                    decoration: TextDecoration.underline,
                                    color: ColorCodes.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: context.theme.textTheme.labelSmall,
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () =>
                                    _openLink(ApiConstants.privacyPolicy),
                                child: Text(
                                   textScaleFactor: 1.0,
                                  'Privacy Policy',
                                  style: context.theme.textTheme.labelSmall!
                                      .copyWith(
                                    decoration: TextDecoration.underline,
                                    color: ColorCodes.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalGapWidget(
                        AppPaddings.p16.h,
                      ),
                      CustomElevatedButtonWidget(
                        buttonText: _isAcceptTerms
                            ? 'Sign Up'
                            : 'Agree with terms & conditions to sign up!',
                        onPressed: _isAcceptTerms
                            ? () => _submitForm(registerBloc)
                            : () => {},
                        isActive: false,
                        isSubmitting: !_isAcceptTerms,
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

    return CommonPageBoilerPlate(
      commonAppBar: CommonAppBar(
        titleWidget: Text(
           textScaleFactor: 1.0,
          'Sign Up',
          style: context.theme.textTheme.titleMedium!.copyWith(
            fontSize: 17.sp,
          ),
        ),
        isHomeRedirectEnable: false,
        leadingWidget: const AppBarBackButton(),
      ),
      pageBody: body,
    );
  }

  void _openLink(String url) async {
    if (Platform.isIOS) {
      if (await canLaunchUrlString(url)) {
        launchUrlString(url);
      }
    } else {
      await launchUrlString(url);
    }
  }
}
