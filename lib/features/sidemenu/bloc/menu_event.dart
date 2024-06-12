part of 'menu_bloc.dart';

sealed class MenuEvent {}

class InitializeEvent extends MenuEvent {}

class ForceLogOutMenuEvent extends MenuEvent {
  ForceLogOutMenuEvent();
}