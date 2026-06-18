import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:efg_converter/core/network/dio_client.dart';
import 'package:efg_converter/core/network/network_info.dart';
import 'package:efg_converter/core/storage/hive_storage.dart';
import 'package:efg_converter/core/utils/constants.dart';
import 'package:efg_converter/features/converter/data/datasource/converter_local_datasource.dart';
import 'package:efg_converter/features/converter/data/datasource/converter_remote_datasource.dart';
import 'package:efg_converter/features/converter/data/repositories/converter_repository_impl.dart';
import 'package:efg_converter/features/converter/domain/repositories/converter_repository.dart';
import 'package:efg_converter/features/converter/domain/usecases/get_currencies_usecase.dart';
import 'package:efg_converter/features/converter/domain/usecases/get_exchange_rates_usecase.dart';
import 'package:efg_converter/features/converter/presentation/cubit/converter_cubit.dart';
import 'package:efg_converter/features/history/data/datasource/history_local_datasource.dart';
import 'package:efg_converter/features/history/data/repositories/history_repository_impl.dart';
import 'package:efg_converter/features/history/domain/repositories/history_repository.dart';
import 'package:efg_converter/features/history/domain/usecases/clear_history_uscase.dart';
import 'package:efg_converter/features/history/domain/usecases/delete_conversion_usecase.dart';
import 'package:efg_converter/features/history/domain/usecases/get_history_usecase.dart';
import 'package:efg_converter/features/history/domain/usecases/save_conversion_usecase.dart';
import 'package:efg_converter/features/history/presentation/cubit/history_cubit.dart';
import 'package:efg_converter/shared/language/lang_cubit.dart';
import 'package:efg_converter/shared/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {

  // Storage
  final hiveStorage = HiveStorage();
  await hiveStorage.init();
  sl.registerSingleton<HiveStorage>(hiveStorage);



  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<NetworkInfo>(
          () => NetworkInfoImpl(sl<Connectivity>()));

  sl.registerLazySingleton<DioClient>(
          () => DioClient(
        networkInfo: sl<NetworkInfo>(),
        baseUrl: ApiConstants.baseUrl,
      ));

  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl<HiveStorage>()));
  sl.registerLazySingleton<LangCubit>(() => LangCubit(sl<HiveStorage>()));



  // DataSources
  sl.registerLazySingleton<ConverterRemoteDataSource>(
        () => ConverterRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<ConverterLocalDataSource>(
        () => ConverterLocalDataSourceImpl(sl<HiveStorage>()),
  );
  sl.registerLazySingleton<HistoryLocalDataSource>(
        () => HistoryLocalDataSourceImpl(sl<HiveStorage>()),
  );

  // Repositories
  sl.registerLazySingleton<ConverterRepository>(
        () => ConverterRepositoryImpl(
      remoteDataSource: sl<ConverterRemoteDataSource>(),
      localDataSource: sl<ConverterLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<HistoryRepository>(
        () => HistoryRepositoryImpl(sl<HistoryLocalDataSource>()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetExchangeRatesUseCase(sl<ConverterRepository>()));
  sl.registerLazySingleton(() => GetCurrenciesUseCase(sl<ConverterRepository>()));
  sl.registerLazySingleton(() => GetHistoryUseCase(sl<HistoryRepository>()));
  sl.registerLazySingleton(() => SaveConversionUseCase(sl<HistoryRepository>()));
  sl.registerLazySingleton(() => DeleteConversionUseCase(sl<HistoryRepository>()));
  sl.registerLazySingleton(() => ClearHistoryUseCase(sl<HistoryRepository>()));


  // Cubits
  sl.registerFactory(
        () => ConverterCubit(
      getExchangeRates: sl<GetExchangeRatesUseCase>(),
      getCurrencies: sl<GetCurrenciesUseCase>(),
      saveConversion: sl<SaveConversionUseCase>(),
      networkInfo: sl<NetworkInfo>(),
          historyCubit: sl<HistoryCubit>(),
    ),
  );


  sl.registerLazySingleton(
        () => HistoryCubit(
      getHistory: sl<GetHistoryUseCase>(),
      deleteConversion: sl<DeleteConversionUseCase>(),
      clearHistory: sl<ClearHistoryUseCase>(),
    ),
  );



}