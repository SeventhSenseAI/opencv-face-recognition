// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menu_bloc.dart';

enum MenuStatus { initial, error, success }

enum DeleteAccountStatus { initial, processing, error, success }

class MenuState extends Equatable {
  final MenuStatus status;
  final String errorMessage;
  final DeleteAccountStatus deleteAccountStatus;
  final bool? isAPITokenError;

  const MenuState({
    required this.status,
    required this.errorMessage,
    required this.deleteAccountStatus,
    this.isAPITokenError,
  });

  static MenuState initialState() => const MenuState(
        errorMessage: '',
        status: MenuStatus.initial,
        deleteAccountStatus: DeleteAccountStatus.initial,
        isAPITokenError: false,
      );

  MenuState copyWith({
    MenuStatus? status,
    String? errorMessage,
    DeleteAccountStatus? deleteAccountStatus,
    bool? isAPITokenError,
  }) {
    return MenuState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
      isAPITokenError: isAPITokenError ?? this.isAPITokenError,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, deleteAccountStatus];
}
