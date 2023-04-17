import 'package:flutter/widgets.dart';

abstract class NavigationState {}

class InitNavigationState extends NavigationState {}

class InitNavtigationErrorState extends NavigationState {}

class ScreenNavigationState extends NavigationState {
  Widget screen;
  ScreenNavigationState(this.screen);
}
