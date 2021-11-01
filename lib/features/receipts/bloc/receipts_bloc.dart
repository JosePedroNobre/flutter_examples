import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:customer/features/receipts/data/receipts_repository.dart';
import 'package:customer/network/model/responses/receipts_response.dart';
import 'package:customer/network/model/sensei_error.dart';
import 'package:equatable/equatable.dart';

part 'receipts_event.dart';
part 'receipts_state.dart';

class ReceiptsBloc extends Bloc<ReceiptsEvent, ReceiptsState> {
  ReceiptsBloc(this.repository) : super(ReceiptsLoading());

  final ReceiptsRepository repository;

  @override
  Stream<ReceiptsState> mapEventToState(
    ReceiptsEvent event,
  ) async* {
    if (event is GetReceipts) {
      yield ReceiptsLoading();
      try {
        var response = await repository.getReceipts();
        print(response);
        yield ReceiptsLoaded(response: response);
      } catch (e) {
        yield Error(senseiError: e is SenseiError ? e : null);
      }
    }
  }
}
