import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staffapp/features/authentication/bloc/authentication_bloc.dart';
import 'package:staffapp/features/authentication/data/authentication_data_source.dart';
import 'package:staffapp/features/authentication/data/authentication_repository.dart';
import 'package:staffapp/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:staffapp/features/dashboard/data/dashboard_data_source.dart';
import 'package:staffapp/features/dashboard/data/dashboard_repository.dart';
import 'package:staffapp/features/delegate_access/bloc/delegate_access_bloc.dart';
import 'package:staffapp/features/delegate_access/data/delegate_access_data_source.dart';
import 'package:staffapp/features/delegate_access/data/delegate_access_repository.dart';
import 'package:staffapp/features/qr_code/bloc/qr_code_bloc.dart';
import 'package:staffapp/features/qr_code/data/qr_code_datasource.dart';
import 'package:staffapp/features/qr_code/data/qr_code_repository.dart';
import 'package:staffapp/features/task/bloc/task_bloc.dart';
import 'package:staffapp/features/task/data/task_repository.dart';

import 'features/task/data/task_data_source.dart';

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
          repository: QRCodeRepository(
            dataSource: QRCodeRemoteDataSource(),
          ),
        ),
      ),
      BlocProvider<DelegateAccessBloc>(
        create: (context) => DelegateAccessBloc(
          repository: DelegateAccessRepository(
            dataSource: DelegateAccessRemoteDataSource(),
          ),
        ),
      ),
      BlocProvider<TaskBloc>(
        create: (context) => TaskBloc(
          repository: TaskRepository(
            dataSource: TaskemoteDataSource(),
          ),
        ),
      ),
      BlocProvider<DashboardBloc>(
        create: (context) => DashboardBloc(
          repository: DashboardRepository(
            dataSource: DashboardRemoteDataSource(),
          ),
        ),
      ),
    ];
  }
}

//TODO set testing blocs here if needed
