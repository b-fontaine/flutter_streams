// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'data/data_module.dart' as _i8;
import 'data/repositories/weather_repository.dart' as _i6;
import 'domain/domain_module.dart' as _i10;
import 'domain/usecases/weather_stream_usecase.dart' as _i7;
import 'main.dart' as _i4;
import 'ui/router.dart' as _i3;
import 'ui/weather_clean/weather_interactor.dart' as _i9;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.AppRouter>(_i3.AppRouter());
    gh.factory<_i4.MyApp>(() => _i4.MyApp(key: gh<_i5.Key>()));
    gh.factory<_i6.WeatherRepository>(
      () => _i6.WeatherRepository(),
      instanceName: 'WeatherRepository',
    );
    gh.singleton<_i7.WeatherStreamUseCase>(
      _i7.WeatherStreamUseCase(
          gh<_i8.WeatherRepository>(instanceName: 'WeatherRepository')),
      instanceName: 'WeatherStreamUseCase',
    );
    gh.singleton<_i9.WeatherCleanInteractor>(_i9.WeatherCleanInteractor(
        gh<_i10.WeatherStreamUseCase>(instanceName: 'WeatherStreamUseCase')));
    return this;
  }
}
