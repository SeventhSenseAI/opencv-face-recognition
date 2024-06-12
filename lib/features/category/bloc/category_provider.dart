import 'package:faceapp/features/category/bloc/category_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryProvider extends BlocProvider<CategoryBloc> {
  CategoryProvider({
    super.key,
  }) : super(
          create: (context) => CategoryBloc(),
        );
}
