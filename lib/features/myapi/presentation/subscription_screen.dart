import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_paddings.dart';
import '../../../core/constants/color_codes.dart';
import '../../../core/utils/assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../core/widgets/boiler_plate_widgets/common_back_button.dart';
import '../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../core/widgets/common_elevated_button.dart';
import '../../../core/widgets/common_snack_bar.dart';
import '../../../core/widgets/gap_widgets/horizontal_gap_consistent.dart';
import '../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import '../../../landing_page.dart';
import '../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../category/bloc/category_bloc.dart';
import '../../category/bloc/category_event.dart';
import '../../dashboard/widget/image_button.dart';
import '../../person/bloc/person_bloc.dart';
import '../../person/bloc/person_event.dart';
import '../../sidemenu/bloc/menu_bloc.dart';
import '../bloc/myapi_bloc.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late MyapiBloc myapiBloc;
  String product_id = '';
  int daysRemain = 0;
  void getSubscriptionDetails(BuildContext context) {
    myapiBloc = BlocProvider.of<MyapiBloc>(context);
    myapiBloc.add(InitializeSearch());
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}**********';
    }
  }

  String findExpireDate(DateTime dateTime) {
    String formattedDate =
        DateFormat('d MMM y ( UTC Z)').format(dateTime.toLocal());
    return (formattedDate);
  }

  String daysRemaining(DateTime dateTime) {
    DateTime currentDate = DateTime.now();
    Duration difference = dateTime.difference(currentDate);
    daysRemain = difference.inDays;
    return difference.inDays.abs().toString();
  }

  @override
  Widget build(BuildContext context) {
    getSubscriptionDetails(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.authStatus != current.authStatus,
          listener: (context, state) {
            if (state.authStatus == AuthStatus.unauthenticated) {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const LandingPage();
                  },
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
                (route) => false,
              );
            }
          },
        ),
        BlocListener<MyapiBloc, MyapiState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == MyapiStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(context, state.errorMessage),
              );
              Future.delayed(const Duration(milliseconds: 1500), () {
                if (state.isAPITokenError!) {
                  final authBloc = BlocProvider.of<AuthBloc>(context);
                  authBloc.add(LogoutUserEvent());
                  context
                      .read<CategoryBloc>()
                      .add(ForceLogOutCollectionEvent());
                  context.read<MenuBloc>().add(ForceLogOutMenuEvent());
                  context.read<PersonBloc>().add(ForceLogOutPersonEvent());
                }
              });
            }
          },
        ),
      ],
      child: CommonPageBoilerPlate(
        commonAppBar: CommonAppBar(
          leadingWidget: CommonBackButtonWidget(
            buttonText: AppLocalizations.of(context)!.back,
          ),
          titleWidget: Text(
            textScaleFactor: 1.0,
            AppLocalizations.of(context)!.my_api,
          ),
        ),
        pageBody: Center(
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalGapWidget(
                    AppPaddings.p16.h,
                  ),
                  Text(
                    textScaleFactor: 1.0,
                    'API Key',
                    style: context.theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  VerticalGapWidget(
                    AppPaddings.p4.h,
                  ),
                  Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorCodes.boderColor),
                      color: ColorCodes.backgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            textScaleFactor: 1.0,
                            truncateText(
                              context.read<AuthBloc>().state.apiKey,
                              20,
                            ),
                          ),
                          ImageButton(
                            imagePath: Assets.copyIcan,
                            onPressed: () {
                              final apiKey =
                                  context.read<AuthBloc>().state.apiKey;
                              _copyButtonAction(apiKey);
                            },
                            width: 20.w,
                            height: 20.w,
                            isEnabled: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalGapWidget(
                    AppPaddings.p32.h,
                  ),
                  BlocBuilder<MyapiBloc, MyapiState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      if (state.status == MyapiStatus.fetchSubscription) {
                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textScaleFactor: 1.0,
                                  daysRemaining(state.subscription!.expires),
                                  style: context.theme.textTheme.displayLarge!
                                      .copyWith(),
                                ),
                                const VerticalGapWidget(
                                  AppPaddings.p4,
                                ),
                                Text(
                                  textScaleFactor: 1.0,
                                  daysRemain > 0
                                      ? 'Days Remaining'
                                      : 'Expired days ago',
                                  style: context.theme.textTheme.titleSmall!
                                      .copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            HorizontalGapWidget(
                              AppPaddings.p20.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textScaleFactor: 1.0,
                                  AppLocalizations.of(context)!.current_plan,
                                  style: context.theme.textTheme.titleSmall!
                                      .copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                VerticalGapWidget(
                                  AppPaddings.p4.h,
                                ),
                                Text(
                                  textScaleFactor: 1.0,
                                  state.customerType!,
                                  style: context.theme.textTheme.titleMedium!
                                      .copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                VerticalGapWidget(
                                  AppPaddings.p20.h,
                                ),
                                Text(
                                  textScaleFactor: 1.0,
                                  AppLocalizations.of(context)!.license_expiry,
                                  style: context.theme.textTheme.titleSmall!
                                      .copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                VerticalGapWidget(
                                  AppPaddings.p4.h,
                                ),
                                Text(
                                  textScaleFactor: 1.0,
                                  findExpireDate(state.subscription!.expires),
                                  style: context.theme.textTheme.titleMedium!
                                      .copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (state.status == MyapiStatus.initial) {
                        return const CircularProgressIndicator();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  VerticalGapWidget(
                    AppPaddings.p32.h,
                  ),
                  buildCreateButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCreateButton(BuildContext context) {
    return CustomElevatedButtonWidget(
      buttonText: AppLocalizations.of(context)!.subscribe_now,
      onPressed: () {
        _subscriptionButtonAction();
      },
    );
  }

  void _copyButtonAction(String apiKey) {
    Clipboard.setData(ClipboardData(text: apiKey));
    _showToast("Copied to the clipboard");
  }

  void _subscriptionButtonAction() async {
    const url = ApiConstants.subscriptionURL;
    try {
      await launch(url);
    } catch (e) {}
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: ColorCodes.whiteColor,
    );
  }
}