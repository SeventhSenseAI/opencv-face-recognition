import 'package:flutter_bloc/flutter_bloc.dart';

import 'person_bloc.dart';

class PersonProvider extends BlocProvider<PersonBloc> {
  PersonProvider({
    super.key,
  }) : super(
          create: (context) => PersonBloc(),
        );
}
