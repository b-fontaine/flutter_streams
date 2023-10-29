# Flutter Streams - Plongée dans la programmation réactive - Partie 2

![https://cdn-images-1.medium.com/max/1600/0*TdZP31DjMws4B7Ho](https://cdn-images-1.medium.com/max/1600/0*TdZP31DjMws4B7Ho)

Photo by [Sarah Dorweiler](https://unsplash.com/@sarahdorweiler?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

Après avoir exploré en profondeur les méandres des streams Flutter dans notre [précédent article](https://blog.benoitfontaine.fr/flutter-streams-59153dddee14), il est temps de plonger encore plus profondément dans ce sujet fascinant. Les streams, bien que puissants, ne sont que la pointe de l’iceberg lorsqu’il s’agit de la programmation réactive. Dans cet article, nous allons élargir notre horizon et découvrir comment maximiser l’efficacité de nos applications Flutter en utilisant des streams combinés à d’autres outils et techniques. Préparez-vous à embarquer dans un voyage captivant à travers le monde de la programmation réactive !

### Clean Architecture dans Flutter

La Clean Architecture est une approche de conception logicielle qui vise à séparer les préoccupations de manière à rendre le code modulaire, évolutif et testable. Elle est basée sur l’idée de dépendre d’abstractions et non de détails concrets.

**Pourquoi utiliser la Clean Architecture ?**

1. **Séparation des préoccupations** : Chaque couche a une responsabilité claire, ce qui facilite la maintenance et la compréhension du codade.
2. **Indépendance du framework** : Le cœur de l’application (domaine) ne dépend pas des détails tels que les bases de données, les interfaces utilisateur ou les frameworks externes.
3. **Testabilité** : En séparant les préoccupations, il est plus facile de tester chaque couche individuellement.
4. **Évolutivité** : Ajouter de nouvelles fonctionnalités ou modifier des fonctionnalités existantes devient plus simple.

**Les ACL (Anti Corruption Layer)**

Les ACL sont des barrières qui protègent une couche d’une autre, garantissant que les détails d’une couche n’affectent pas une autre. Par exemple, le modèle de données utilisé dans une API ne devrait pas influencer le modèle de données du domaine.

**Modèles pour chaque couche**

- **Dto (Data Transfer Object)** : Utilisé pour transférer des données entre la couche API et la couche Repository. Il est souvent spécifique à la structure de l’API.
- **Entity** : Représente les objets du domaine. Il contient la logique métier.
- **ModelUI** : Modèle spécifique à l’interface utilisateur. Il est adapté pour être affiché directement dans les widgets.

---

Pour rappel, avec `injectable` , il ne faut pas oublier de lancer la commande

```
flutter pub run build_runner watch
```

![https://cdn-images-1.medium.com/max/1600/1*0308cEryKjE_JX7dj-2pfw.png](https://cdn-images-1.medium.com/max/1600/1*0308cEryKjE_JX7dj-2pfw.png)

Résultat de la commande, montrant le watch

Tant que ce script tourne, chaque ajout avec `injectable` génèrera du code.

---

**Implémentation dans notre application météo**

![https://cdn-images-1.medium.com/max/1600/1*_iKBlI46WgTNlp1qufbWIw.png](https://cdn-images-1.medium.com/max/1600/1*_iKBlI46WgTNlp1qufbWIw.png)

Organisation des fichiers

**Repository** :

```
@named
@injectable
class WeatherRepository {

  @factoryMethod
  Future<WeatherDto> fetchWeather(String city) async {
    await Future.delayed(const Duration(seconds: 1));
    // Logique pour récupérer les données météo
    return WeatherDto(temperatureInCelsius: Random().nextInt(60), city: city);
  }
}
```

**Protocol (ACL entre Repository et Domain)** :

```
  factory WeatherData.fromDto(WeatherDto dto) => WeatherData(
        city: dto.city,
        temperatureInCelsius: dto.temperatureInCelsius,
      );
```

**Domain (Entités et logique métier)** :

```
@named
@singleton
class WeatherStreamUseCase {
  final WeatherRepository weatherRepository;

  WeatherStreamUseCase(@Named.from(WeatherRepository) this.weatherRepository);

  Stream<List<WeatherData>> get stream =>
      Rx.combineLatest2(
        getWeatherUpdates('Paris'),
        getWeatherUpdates('New York'),
            (weatherParis, weatherNewYork) =>
        [
          weatherParis,
          weatherNewYork,
        ],
      );

  Stream<WeatherData> getWeatherUpdates(String city) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 15));
      final data = await weatherRepository.fetchWeather(city);
      yield WeatherData.fromDto(data);
    }
  }
}
```

**Interactor** :

```
@singleton
class WeatherCleanInteractor {
  final WeatherStreamUseCase weatherStreamUseCase;
  late final Stream<List<String>> _stream;

  WeatherCleanInteractor(
    @Named.from(WeatherStreamUseCase) this.weatherStreamUseCase,
  ) {
    _stream = weatherStreamUseCase.stream.map((event) =>
        event.map((e) => "${e.city} : ${e.temperatureInCelsius} °C").toList());
  }

  Stream<List<String>> get stream => _stream;
}
```

**UI (Présentation et affichage)** :

```
class WeatherClean extends StatefulWidget {
  const WeatherClean({super.key});

  @override
  State<WeatherClean> createState() => _WeatherCleanState();
}

class _WeatherCleanState extends State<WeatherClean> {
  final WeatherCleanInteractor _weatherCleanInteractor =
      getIt<WeatherCleanInteractor>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _weatherCleanInteractor.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: (snapshot.data ?? [])
              .map((e) => Text(e))
              .toList(),
        );
      },
    );
  }
}
```

La Clean Architecture, bien que nécessitant plus de code initial, offre une structure solide pour les applications, garantissant que les modifications dans une couche n’affectent pas les autres. Elle favorise la testabilité, la réutilisabilité et la séparation des préoccupations, rendant le code plus propre et maintenable.

### Le pattern BLoC et `flutter_bloc`

Le pattern BLoC (Business Logic Component) est une architecture de conception spécifique à Flutter pour séparer la logique métier de l’interface utilisateur. Il s’appuie fortement sur les streams pour gérer l’état et les événements de l’application.

**Qu’est-ce que le pattern BLoC ?**

Le BLoC est une méthode pour séparer la logique métier de l’interface utilisateur. Il utilise les streams pour gérer l’entrée (les événements) et la sortie (les états) :

- **Input (Events)** : Les événements qui sont envoyés au BLoC.
- **Output (States)** : Les états qui sont émis par le BLoC.

Le pattern BLoC emprunte des concepts clés à la fois du MVVM (Modèle-Vue-VueModèle, pattern qui sépare la logique métier -Modèle-, l’interface utilisateur -Vue- et la logique de présentation -VueModèle- pour faciliter une meilleure séparation des préoccupations et une meilleure testabilité) et du MVI (Modèle-Vue-Intention, pattern basé sur un flux unidirectionnel où l’Intention représente les actions de l’utilisateur, le Modèle traite ces actions pour renvoyer un nouvel état, et la Vue affiche cet état à l’utilisateur). De MVVM, il adopte l’idée d’une séparation claire entre la logique métier et l’interface utilisateur, avec un composant intermédiaire (BLoC/ViewModel) gérant la logique de présentation. De MVI, il adopte le flux de données unidirectionnel et l’idée que l’interface utilisateur génère des événements ou des intentions qui sont traités pour produire de nouveaux états.

En combinant les meilleures parties de ces patterns, BLoC offre une architecture robuste et prévisible pour les applications Flutter, tout en s’appuyant fortement sur les streams pour gérer l’état et les événements de manière réactive.

**Introduction à `flutter_bloc`**

`flutter_bloc` est un package qui facilite l'implémentation du pattern BLoC dans Flutter. Il fournit des widgets et des classes pour gérer facilement les événements et les états.

**Comment utiliser `flutter_bloc` ?**

Définir les événements :

```
abstract class WeatherEvent {}

class WeatherStarted extends WeatherEvent {}

class ErrorWeather extends WeatherEvent {
  final String errorMessage;

  ErrorWeather(this.errorMessage);
}

class FetchedWeather extends WeatherEvent {
  final List<String> weathers;
  FetchedWeather(this.weathers);
}
```

Définir les états :

```
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final List<String> weathers;
  WeatherLoaded(this.weathers);
}

class WeatherError extends WeatherState {
  final String errorMessage;

  WeatherError(this.errorMessage);
}
```

Créer le BLoC :

```
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  late final WeatherInteractor _interactor;
  StreamSubscription<List<String>>? _subscription;

  WeatherBloc() : super(WeatherInitial()) {
    _interactor = getIt<WeatherInteractor>();
    on<WeatherStarted>(_weatherStarted);
    on<FetchedWeather>(_fetchedWeather);
    on<ErrorWeather>(_errorWeather);
  }

  FutureOr<void> _weatherStarted(
      WeatherStarted event, Emitter<WeatherState> emit) {
    _interactor.getWeathers().then((value) => add(FetchedWeather(value)));
    _subscription = _interactor.stream.listen(
      (event) {
        add(FetchedWeather(event));
      },
        onError: (error, _) {
          add(ErrorWeather("Une erreur est survenue"));
        }
    );
  }

  FutureOr<void> _fetchedWeather(
      FetchedWeather event, Emitter<WeatherState> emit) {
    emit(WeatherLoaded(event.weathers));
  }

  FutureOr<void> _errorWeather(ErrorWeather event, Emitter<WeatherState> emit) {
    emit(WeatherError(event.errorMessage));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

Utiliser le BLoC dans l’UI :

```
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state is WeatherInitial) {
        context.read<WeatherBloc>().add(WeatherStarted());
        return const CircularProgressIndicator();
      }
      if (state is WeatherLoaded) {
        return WeatherTemperatures(temperatures: state.weathers);
      }
      if (state is WeatherError) {
        return WeatherOnError(errorMessage: state.errorMessage);
      }
      return const WeatherOnError(errorMessage: "Une erreur est survenue");
    });
  }
}
```

Ce qui nous donne, pour la partie BLoC :

![https://cdn-images-1.medium.com/max/1600/1*FsB3oTnh8OKC4nhkccC-Vw.png](https://cdn-images-1.medium.com/max/1600/1*FsB3oTnh8OKC4nhkccC-Vw.png)

Organisation du code en BLoC

En suivant les étapes ci-dessus, nous avons intégré le pattern BLoC à notre application météo. A l’affichage du BLoC, on lance un premier appel pour recevoir les températures au plus vite puis nous souscrivons au stream pour avoir des mises à jours à intervales  réguliers.

Le pattern BLoC, avec l’aide de `flutter_bloc`, offre une manière structurée de gérer la logique métier et l'état de l'application dans Flutter. Il favorise la séparation des préoccupations, la testabilité et la réactivité, rendant le code plus propre et réactif.

En combinant les streams, RxDart, l’injection de dépendance, la clean architecture et le pattern BLoC, nous obtenons une structure d’application où chaque composant a une responsabilité claire et est déconnecté des autres. Cela nous permet de tester chaque partie individuellement, de réutiliser le code et d’ajouter ou de supprimer des fonctionnalités avec un minimum de friction.

Notre application météo, par exemple, utilise un stream pour obtenir des mises à jour régulières de la météo. RxDart nous permet de manipuler ces streams de manière plus expressive. L’injection de dépendance, via `getIT` et `injectable`, nous permet d'injecter des dépendances comme notre service météo ou notre BLoC dans nos widgets. La clean architecture garantit que notre logique métier est séparée de notre logique d'interface utilisateur, et le pattern BLoC gère l'état de notre application de manière prévisible.

### Récapitulons

- **Streams** : Ils nous permettent de traiter des séquences d’événements asynchrones.
- **RxDart** : Une extension de Dart pour les streams, offrant des opérateurs supplémentaires pour manipuler les streams.
- **Injection de dépendance** : Une technique pour fournir des dépendances à d’autres objets, facilitant la testabilité et la réutilisabilité.
- **Clean Architecture** : Une architecture qui sépare clairement la logique métier de l’interface utilisateur et des sources de données.
- **Pattern BLoC** : Un pattern spécifique à Flutter pour séparer la logique métier de l’interface utilisateur en utilisant des streams.

### Au-delà de l’architecture

Il est essentiel de se rappeler que, bien que l’architecture soit cruciale, elle n’est qu’un élément parmi d’autres dans le développement de logiciels de qualité. D’autres pratiques, telles que le clean code, l’intégration continue et le déploiement continu (CI/CD), le développement piloté par les tests (TDD), le développement piloté par le comportement (BDD) et bien d’autres, jouent également un rôle essentiel pour garantir que votre application est non seulement bien architecturée, mais aussi robuste, testable et facile à maintenir.

### Quelques références

Pour finir, j’ai repris les références de la partie précédente en y ajoutant de nouvelles.

Documentation officielle :

- [Documentation officielle sur les Stream](https://dart.dev/tutorials/language/streams) / [API Dart Stream](https://api.dart.dev/stable/3.1.3/dart-async/Stream-class.html)
- [Site officiel Rx](https://reactivex.io/) / [Documentation RxDart](https://pub.dev/packages/rxdart)
- [Documentation Officielle BLoC](https://bloclibrary.dev/#/)

Articles :

- [Streams in Dart](https://dev.to/lionnelt/streams-in-dart-21le) par Lionnel Tsuro
- [Reactive Programming Using RxDart For Flutter Applications](https://medium.com/mindful-engineering/reactive-programming-using-rxdart-for-flutter-applications-part-1-a0b70e99a6e2) par Mohit Chauhan
- [Quick Guide to BLoC as State Manager For Your Next Flutter Project](https://dev.to/yatendra2001/quick-guide-to-bloc-as-state-manager-for-your-next-flutter-project-14h8) par yatendra2001
- [Flutter bloc for beginners](https://medium.com/flutter-community/flutter-bloc-for-beginners-839e22adb9f5) par Ana Polo

Livres :

- [Livre Clean Architecture de Robert C. Martin](https://amzn.eu/d/igaxWRQ): Ce livre a eu impact profond sur l’industrie du logiciel, en établissant des normes pour la conception architecturale et en encourageant une réflexion plus profonde sur la manière dont nous construisons des logiciels.
- [Clean Code: A Handbook of Agile Software Craftsmanship par Robert C. Martin](https://amzn.eu/d/eW3myyf): Un classique sur les meilleures pratiques de codage et l’importance d’écrire un code propre.
- [Design Patterns: Elements of Reusable Object-Oriented Software](https://a.co/d/cPDPnOH) par Erich Gamma, Richard Helm, Ralph Johnson, et John Vlissides — Un livre essentiel sur les modèles de conception en programmation orientée objet.

Enfin, vous pouvez aussi voir et tester le code source sur [https://github.com/b-fontaine/flutter_streams](https://github.com/b-fontaine/flutter_streams)