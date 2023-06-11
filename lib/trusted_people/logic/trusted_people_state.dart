

import 'package:flutter/widgets.dart';

abstract class TrustedPeopleState {}

class TrustedPeopleInitState extends TrustedPeopleState {}

class TrustedPeopleLoadingState extends TrustedPeopleState {}

class BackPeopleInitState extends TrustedPeopleState {}

class AddPeopleState extends TrustedPeopleState {
  List<Widget> columnWidgets;
  AddPeopleState({required this.columnWidgets});
}

class VerifyPeopleState extends TrustedPeopleState {}

class VerifyPeopleLoadingState extends TrustedPeopleState {}

class VerifyPeopleInitState extends TrustedPeopleState {}

class VerifyPeopleSuccessState extends TrustedPeopleState {}