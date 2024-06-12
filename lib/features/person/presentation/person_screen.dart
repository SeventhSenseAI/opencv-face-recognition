import 'package:faceapp/features/category/bloc/category_event.dart';
import 'package:faceapp/features/person/bloc/person_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_paddings.dart';
import '../../../core/constants/color_codes.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../core/widgets/boiler_plate_widgets/common_back_button.dart';
import '../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../category/bloc/category_bloc.dart';
import '../../search/data/model/user.dart';
import '../bloc/person_bloc.dart';
import '../bloc/person_state.dart';
import 'widget/person_card.dart';

class PersonScreen extends StatefulWidget {
  final Collection currentCategory;
  final bool isNeedsRedirectToMultipleFacesPage;

  const PersonScreen({
    super.key,
    required this.currentCategory,
    required this.isNeedsRedirectToMultipleFacesPage,
  });

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  TextEditingController personController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // context.read<PersonBloc>().add(
    //       fetchNextBatchOfPersons(collectionId: ''),
    //     );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<PersonBloc>().add(
            fetchNextBatchOfPersons(collectionId: widget.currentCategory.id == null ? '' : widget.currentCategory.id!,),
          );
    }
  }

  Widget buildCategoryList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<PersonBloc, PersonState>(
        buildWhen: (previous, current) =>
            previous.personList != current.personList ||
            previous.currentCategory != current.currentCategory ||
            previous.status != current.status ||
            previous.filterPersonText != current.filterPersonText,
        builder: (context, state) {
          if (state.status == PersonStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Stack(
              children: [
                if (state.personList.isNotEmpty)
                  Scrollbar(
                    radius: Radius.circular(5.r),
                    thickness: 3.spMax,
                    thumbVisibility: false,
                    trackVisibility: false,
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: state.personList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final personName = state.personList[index].name;
                        if (state.filterPersonText.isEmpty ||
                            personName!
                                .toLowerCase()
                                .startsWith(state.filterPersonText)) {
                          return PersonCard(
                            baseMultipleFacesImage: "",
                            person: state.personList[index],
                            isNeedsRedirectToMultipleFacesPage:
                                widget.isNeedsRedirectToMultipleFacesPage,
                            compressBase64Image: "",
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                if (state.personList.isEmpty)
                  Center(
                    child: Text(
                      "No one has been added in this collection",
                      style: context.theme.textTheme.bodyLarge,
                    ),
                  ),
                if (state.status == PersonStatus.next)
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<PersonBloc>().add(
          UpdateFilterPersonTextEvent(
            filterText: personController.text.toLowerCase(),
          ),
        );
    context.read<CategoryBloc>().add(GetAllCategoryEvent());

    return CommonPageBoilerPlate(
      commonAppBar: CommonAppBar(
        isCenterTitle: true,
        titleWidget: Text(
          textScaleFactor: 1.0,
          widget.currentCategory.name!,
          style: context.theme.textTheme.titleMedium!.copyWith(
            fontSize: 17.sp,
          ),
        ),
        leadingWidget: CommonBackButtonWidget(
          buttonText: AppLocalizations.of(context)!.back,
        ),
      ),
      pageBody: Stack(
        children: [
          Positioned(
            top: 10.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: TextField(
                controller: personController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: context.theme.textTheme.bodyMedium!,
                  suffixIcon: const Icon(
                    Icons.search,
                    color: ColorCodes.whiteColor,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppPaddings.p16.w,
                    vertical: AppPaddings.p8.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(
                      color: ColorCodes.greyColor,
                    ),
                  ),
                ),
                onChanged: (value) => {
                  context.read<PersonBloc>().add(
                        UpdateFilterPersonTextEvent(
                          filterText: value.toLowerCase(),
                        ),
                      ),
                },
              ),
            ),
          ),
          Positioned(
            top: AppPaddings.p64.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: buildCategoryList(context),
          ),
        ],
      ),
    );
  }
}