import 'package:customer/features/home/bloc/qr_code_bloc.dart';
import 'package:customer/features/home/data/qr_code_datasource.dart';
import 'package:customer/features/home/data/qr_code_repository.dart';
import 'package:customer/features/receipts/bloc/receipts_bloc.dart';
import 'package:customer/features/receipts/data/receipts_data_source.dart';
import 'package:customer/features/receipts/data/receipts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authentication/bloc/authentication_bloc.dart';
import 'features/authentication/data/authentication_data_source.dart';
import 'features/authentication/data/authentication_repository.dart';

class BlocDependency {
  static setRemoteBlocs() {
    return [
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
          AuthenticationRepository(
            authenticationDataSource: AuthenticationRemoteDataSource(),
          ),
        ),
      ),
      BlocProvider<QrCodeBloc>(
        create: (context) => QrCodeBloc(
          QRCodeRepository(
            dataSource: QRCodeRemoteDataSource(),
          ),
        ),
      ),
      BlocProvider<ReceiptsBloc>(
        create: (context) => ReceiptsBloc(
          ReceiptsRepository(
            dataSource: ReceiptsRemoteDataSource(),
          ),
        ),
      ),
    ];
  }
}

//TODO set testing blocs here if needed
