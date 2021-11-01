part of 'delegate_access_bloc.dart';

abstract class DelegateAccessEvent extends Equatable {
  const DelegateAccessEvent();

  @override
  List<Object> get props => [];
}

class GetDelegateAccess extends DelegateAccessEvent {
  final String accessType;
  final BuildContext context;

  GetDelegateAccess(this.accessType, this.context);

  @override
  List<Object> get props => [accessType];
}

class ResetDelegateAccess extends DelegateAccessEvent {
  ResetDelegateAccess();

  @override
  List<Object> get props => [];
}
