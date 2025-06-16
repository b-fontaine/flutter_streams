// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i409;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'data/data_module.dart' as _i947;
import 'data/repositories/weather_repository.dart' as _i749;
import 'domain/domain_module.dart' as _i230;
import 'domain/usecases/weather_stream_usecase.dart' as _i713;
import 'main.dart' as _i67;
import 'ui/router.dart' as _i766;
import 'ui/weather_clean/weather_interactor.dart' as _i1044;
import 'ui/weather_full/weather_interactor.dart' as _i758;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i766.AppRouter>(() => _i766.AppRouter());
    gh.factory<_i749.WeatherRepository>(
      () => _i749.WeatherRepository(),
      instanceName: 'WeatherRepository',
    );
    gh.factory<_i67.MyApp>(() => _i67.MyApp(key: gh<_i409.Key>()));
    gh.singleton<_i713.WeatherStreamUseCase>(
      () => _i713.WeatherStreamUseCase(
        gh<_i947.WeatherRepository>(instanceName: 'WeatherRepository'),
      ),
      instanceName: 'WeatherStreamUseCase',
    );
    gh.singleton<_i1044.WeatherCleanInteractor>(
      () => _i1044.WeatherCleanInteractor(
        gh<_i230.WeatherStreamUseCase>(instanceName: 'WeatherStreamUseCase'),
      ),
    );
    gh.singleton<_i758.WeatherInteractor>(
      () => _i758.WeatherInteractor(
        gh<_i230.WeatherStreamUseCase>(instanceName: 'WeatherStreamUseCase'),
      ),
    );
    return this;
  }
}
