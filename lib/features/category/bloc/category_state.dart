import 'package:faceapp/features/search/data/model/user.dart';

enum CategoryStatus {
  initial,
  loading,
  submitting,
  submitted,
  success,
  error,
}

enum CategorySaveStatus {
  initial,
  submitting,
  success,
  error,
}

enum CategoryUpdateStatus {
  initial,
  submitting,
  success,
  error,
}

enum CategoryDeleteStatus {
  initial,
  submitting,
  success,
  error,
}

class CategoryState {
  final List<Collection> categoryList;
  final Collection currentCategory;
  final CategoryStatus status;
  final String errorMessage;
  final bool isFaceLibrary;
  final List<Collection> selectedCollections;
  final CategorySaveStatus saveStatus;
  final CategoryUpdateStatus updateStatus;
  final CategoryDeleteStatus deleteStatus;
  final String filterText;
  final bool isAPITokenError;
  final bool isDropdownOpen;
  final bool isColUpdated;
  final List<Collection> selectCollections;

  const CategoryState({
    required this.categoryList,
    required this.currentCategory,
    required this.status,
    required this.errorMessage,
    required this.isFaceLibrary,
    required this.selectedCollections,
    required this.saveStatus,
    required this.updateStatus,
    required this.deleteStatus,
    required this.filterText,
    required this.isAPITokenError,
    required this.isDropdownOpen,
    required this.isColUpdated,
    required this.selectCollections,
  });

  static CategoryState initial() => CategoryState(
        categoryList: [],
        currentCategory: Collection(
          id: '',
          name: '',
          description: '',
          createDate: DateTime.now(),
          modifiedDate: DateTime.now(),
        ),
        status: CategoryStatus.initial,
        errorMessage: '',
        isFaceLibrary: false,
        selectedCollections: [],
        saveStatus: CategorySaveStatus.initial,
        updateStatus: CategoryUpdateStatus.initial,
        deleteStatus: CategoryDeleteStatus.initial,
        filterText: '',
        isAPITokenError: false,
        isDropdownOpen: true,
        isColUpdated: false,
        selectCollections: [],
      );

  CategoryState clone({
    List<Collection>? categoryList,
    Collection? currentCategory,
    CategoryStatus? status,
    String? errorMessage,
    bool? isFaceLibrary,
    List<Collection>? selectedCollections,
    CategorySaveStatus? saveStatus,
    CategoryUpdateStatus? updateStatus,
    CategoryDeleteStatus? deleteStatus,
    String? filterText,
    bool? isAPITokenError,
    bool? isDropdownOpen,
    bool? isColUpdated,
    List<Collection>? selectCollections,
  }) {
    return CategoryState(
      categoryList: categoryList ?? this.categoryList,
      currentCategory: currentCategory ?? this.currentCategory,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isFaceLibrary: isFaceLibrary ?? this.isFaceLibrary,
      selectedCollections: selectedCollections ?? this.selectedCollections,
      saveStatus: saveStatus ?? this.saveStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      filterText: filterText ?? this.filterText,
      isAPITokenError: isAPITokenError ?? this.isAPITokenError,
      isDropdownOpen: isDropdownOpen ?? this.isDropdownOpen,
      isColUpdated: isColUpdated ?? this.isColUpdated,
      selectCollections: selectCollections ?? this.selectCollections,
    );
  }
}
