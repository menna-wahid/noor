

import 'package:flutter/widgets.dart';

abstract class TrustedPeopleState {}

class TrustedPeopleInitState extends TrustedPeopleState {}

class TrustedPeopleLoadingState extends TrustedPeopleState {}

// class AddTrustedPeopleNavigationState extends TrustedPeopleState {}

class BackPeopleInitState extends TrustedPeopleState {}

class AddPeopleState extends TrustedPeopleState {
  List<Widget> columnWidgets;
  AddPeopleState({required this.columnWidgets});
}

// class AddPeopleShowNameState extends TrustedPeopleState {}

// class AddPeopleNameDoneState extends TrustedPeopleState {}