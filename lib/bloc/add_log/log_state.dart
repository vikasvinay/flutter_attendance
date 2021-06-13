part of 'log_bloc.dart';

abstract class LogState {}

class LogEmptyState extends LogState{}

class LogIncrementState extends LogState{}

class GotLogs extends LogState{}

class Loginitial extends LogState{}