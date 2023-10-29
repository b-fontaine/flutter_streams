
# Flutter Streams — Plongée dans la programmation réactive — Partie 1

![https://miro.medium.com/v2/resize:fit:1400/0*r928ZOGu8CBL9FTb](https://miro.medium.com/v2/resize:fit:1400/0*r928ZOGu8CBL9FTb)

Photo by [Tobias Carlsson](https://unsplash.com/@tobias_carl?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

Dans le monde du développement logiciel, la gestion des données en temps réel est souvent une source de complexité. Imaginons une application où les données peuvent être modifiées à tout moment, par différentes sources, et où ces modifications doivent être reflétées instantanément dans l’interface utilisateur. Comment gérer efficacement ces flux de données dynamiques ? C’est ici que les **Streams** entrent en jeu.

Un Stream est une séquence d’événements asynchrones. Il permet de “s’abonner” à des sources de données et de réagir à chaque nouvelle donnée produite. Au lieu de demander activement des données, avec un Stream, les données sont “poussées” vers le consommateur dès qu’elles sont disponibles. Cette approche résout le problème de la synchronisation des données en temps réel en offrant un moyen élégant de gérer les flot de données asynchrones.

Mais d’où vient cette idée de programmation basée sur les flux de données ? Remontons un peu dans le temps. La **programmation réactive** a été popularisée par Microsoft avec l’introduction de Reactive Extensions (Rx) en 2008. L’idée était de fournir aux développeurs un cadre pour gérer les événements asynchrones et les flux de données de manière déclarative. Au lieu de se perdre dans les méandres des callbacks et des gestionnaires d’événements, les développeurs pouvaient désormais traiter les flux de données comme des collections, en utilisant des opérateurs familiers tels que `map`, `filter` et `reduce`.

L’impact de la programmation réactive sur le développement logiciel a été profond. Elle a offert une nouvelle manière de penser et de structurer le code, rendant les applications plus lisibles, maintenables et robustes face aux complexités asynchrones. Et avec l’essor des applications web et mobiles en temps réel, la nécessité d’une telle approche n’a fait que croître.

Flutter, le framework UI de Google, n’est pas en reste. Conçu dès le départ avec la programmation réactive à l’esprit, Flutter intègre profondément le concept de Stream dans son architecture. Que ce soit pour gérer les entrées’C utilisateur, les animations ou les communications réseau, Flutter s’appuie sur les Streams pour offrir une expérience utilisateur fluide et réactive.

# **Streams**

Lorsque nous parlons de programmation asynchrone, nous pensons souvent aux `Futures` en Dart, qui représentent des valeurs potentielles, ou des erreurs, qui seront disponibles à un moment donné dans le futur. Cependant, Dart va au-delà des simples `Futures` avec un autre puissant concept : les **Streams**.

## **Qu’est-ce qu’un Stream ?**

Un Stream, dans le contexte de Dart, est une séquence d’événements asynchrones. Vous pouvez imaginer un Stream comme un tuyau par lequel des données (ou des erreurs) peuvent passer. Ces données peuvent être produites n’importe quand, ce qui rend les Streams particulièrement adaptés pour gérer des flux de données qui ne sont pas disponibles immédiatement, comme les entrées utilisateur, les fichiers lus depuis la mémoire ou les données reçues via le réseau.

## **Comment créer et écouter un Stream**

Créer un Stream en Dart est simple. Voici un exemple basique :

```
Stream<int> countStream(int maxCount) async* {
  for (int i = 1; i <= maxCount; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}
```

Dans cet exemple, `countStream` est un Stream qui émet des nombres de 1 à `maxCount` toutes les secondes. Le mot-clé `async*` indique que c'est une fonction génératrice asynchrone, et `yield` est utilisé pour émettre une valeur dans le Stream.

Pour écouter un Stream, vous utilisez la méthode `listen` :

```
final stream = countStream(5);
stream.listen((data) {
  print('Received: $data');
}, onError: (error) {
  print('Error: $error');
}, onDone: () {
  print('Stream completed');
});
```

## **Utilisation d’un Stream dans Flutter**

Flutter intègre naturellement les Streams grâce au widget `StreamBuilder`. Ce widget se reconstruit chaque fois qu'une nouvelle donnée est émise par le Stream, permettant une mise à jour dynamique de l'interface utilisateur.

```
StreamBuilder<int>(
  stream: countStream(5),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    return Text('Count: ${snapshot.data}');
  },
)
```

Avec `StreamBuilder`, vous n'avez pas besoin de gérer manuellement les états de chargement, d'erreur ou de données disponibles. Le widget s'en occupe pour vous, rendant votre code plus propre et plus lisible.

# **RxDart**

RxDart est une extension de la bibliothèque Dart `Stream` qui ajoute des fonctionnalités inspirées de la programmation réactive. Popularisée à l'origine par Microsoft, cette approche a été adaptée et intégrée dans de nombreux outils, dont Dart et Flutter.

## **Pourquoi RxDart ?**

Bien que Dart offre des fonctionnalités asynchrones puissantes avec ses `Futures` et `Streams`, RxDart vient compléter ces outils en introduisant une gamme d'opérateurs qui permettent de manipuler, combiner, transformer et réagir aux valeurs émises par les Streams de manière plus expressive.

## **Opérateurs RxDart**

Voici quelques-uns des opérateurs les plus couramment utilisés en RxDart, accompagnés de schémas pour illustrer leur fonctionnement :

1. **map** : Transforme les éléments émis par le Stream en fonction d’une fonction donnée.

!https://miro.medium.com/v2/resize:fit:1400/1*bR6KH1VTQs4yYEHB_xXk3g.png

**2. debounceTime** : Retarde les valeurs émises par le Stream d’une durée spécifiée.

!https://miro.medium.com/v2/resize:fit:1400/1*jUAmjIB2qZPzGb-UaLo3hQ.png

**3. merge** : Combine plusieurs Streams en un seul Stream.

!https://miro.medium.com/v2/resize:fit:1400/1*jB6M3RfZgfD_lnySIBS79Q.png

**4. combineLatest** : Prend les dernières valeurs de plusieurs Streams et les combine.

!https://miro.medium.com/v2/resize:fit:1400/1*6ctgMF_2pO1vET9KDkvxIA.png

# **Illustration**

Lorsque nous parlons d’une application météo, nous pensons souvent à des données qui sont mises à jour régulièrement, comme les prévisions météorologiques, la température actuelle, le taux d’humidité, etc. Ces données peuvent être idéalement représentées et gérées à l’aide de Streams et de RxDart.

Imaginons que nous ayons une API qui nous fournit les données météorologiques. Nous pouvons créer un Stream qui émet ces données à intervalles réguliers :

```
Stream<WeatherData> getWeatherUpdates() async* {
  while (true) {
    await Future.delayed(Duration(minutes: 1)); // Mettre à jour toutes les minutes
    final data = await fetchWeatherDataFromAPI();
    yield data;
  }
}
```

Ici, `WeatherData` est une classe qui contient toutes les informations météorologiques nécessaires.

## **Utilisation de RxDart pour manipuler les données**

Avec RxDart, nous pouvons facilement manipuler et transformer les données avant de les afficher à l’utilisateur. Par exemple, si nous voulons convertir la température de Celsius à Fahrenheit :

```
final temperatureStream = getWeatherUpdates().map(
  (data) => data.temperatureInCelsius * 9/5 + 32 // Conversion en Fahrenheit
);
```

Supposons maintenant que nous voulions combiner les données météorologiques de deux villes différentes. Avec l’opérateur `combineLatest2` de RxDart, c'est un jeu d'enfant :

```
final combinedWeatherStream = Rx.combineLatest2(
  getWeatherUpdates(city: 'Paris'),
  getWeatherUpdates(city: 'New York'),
  (weatherParis, weatherNewYork) => CombinedWeather(weatherParis, weatherNewYork)
);
```

## **Affichage des données dans Flutter**

Flutter rend l’écoute et l’affichage des données d’un Stream très simple grâce au widget `StreamBuilder` :

```
StreamBuilder<WeatherData>(
  stream: getWeatherUpdates(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Erreur : ${snapshot.error}');
    }
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    return Text('Température : ${snapshot.data.temperature}°C');
  },
)
```

Comme vous pouvez le voir, les Streams et RxDart offrent une manière puissante et flexible de gérer des données asynchrones en Dart et Flutter. Ils permettent de manipuler, transformer et combiner des données de manière déclarative, rendant le code plus propre et plus lisible.

# **Injection de dépendance avec `get_it` et `injectable`**

L’injection de dépendance est une technique de conception logicielle qui permet d’injecter des dépendances (services ou objets) dans une classe plutôt que de les créer à l’intérieur de cette classe. Elle favorise la séparation des préoccupations, la réutilisabilité du code et facilite les tests unitaires.

**Pourquoi utiliser l’injection de dépendance ?**

1. **Séparation des préoccupations** : Chaque composant ou service se concentre sur sa propre logique sans se soucier de la création ou de la gestion de ses dépendances.
2. **Testabilité** : Il est plus facile de remplacer des dépendances réelles par des mockups lors des tests.
3. **Réutilisabilité** : Les services peuvent être réutilisés dans différentes parties de l’application sans avoir à les recréer.

**Introduction à `get_it` et `injectable`**

- **get_it** : C’est un service locator pour Dart et Flutter, ce qui signifie qu’il fournit un accès global à vos instances. Il ne dépend pas du framework Flutter, vous pouvez donc l’utiliser dans n’importe quel projet Dart.
- **injectable** : C’est un générateur de code pour `get_it`. Il génère automatiquement le code d'enregistrement pour vos services, réduisant ainsi le boilerplate.

**Installation et configuration**

Ajoutez les dépendances à votre pubspec.yaml :

```
dependencies:
  get_it:
  injectable:

dev_dependencies:
  build_runner:
  injectable_generator:
```

Exécutez `pub get` pour installer les dépendances.

Créez votre fichier d’injection (ici, `injector.dart` ):

```
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injector.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();
```

Il faut ensuite utiliser cet `injector.dart` à l’initialisation de l’app :

```
void main() {
 configureDependencies();
 runApp(MyApp());
}
```

Créez vos services et utilisez les annotations fournies par `injectable` pour marquer vos classes. Par exemple, pour un service météo :

```
abstract class WeatherService {
  Future<WeatherData> fetchWeather(String city);
}

@Injectable(as: WeatherService)
class WeatherServiceImpl implements WeatherService {
  @override
  Future<WeatherData> fetchWeather(String city) {
    // Logique pour récupérer les données météo
  }
}
```

Vous pouvez utiliser `@Injectable` et `@factoryMethod` pour les factories et `@lazySingleton` pour les singletons.

Exécutez la commande suivante pour générer le code :

```
flutter pub run build_runner watch
```

Pour le reste, tout est généré automatiquement avec `injectable` et, tant que la commande sera lancée, chaque mise à jour du code sera prise en compte.

# **Intégration dans notre application météo**

Supposons que nous ayons un service `WeatherService` qui interagit avec une API pour obtenir les données météo. Avec l'injection de dépendance, nous pouvons facilement injecter ce service dans n'importe quel widget ou autre service.

Marquez le service avec l’annotation `@injectable` :

```
class WeatherData {
  final String city;
  final int temperatureInCelsius;

  WeatherData({required this.city, required this.temperatureInCelsius});
}

abstract class WeatherService {
  Future<WeatherData> fetchWeather(String city);
}

@named
@Injectable(as: WeatherService)
class WeatherServiceImpl implements WeatherService {
  @override
  Future<WeatherData> fetchWeather(String city) {
    // Logique pour récupérer les données météo
  }
}
```

Ensuite, créez le stream à partir du service:

```
abstract class WeatherStream {
  void cancel();

  Stream<List<WeatherData>> get stream;
}

@named
@LazySingleton(as: WeatherStream)
class WeatherStreamImpl
    implements WeatherStream {
  final WeatherService service;
  bool _cancellationToken = false;

  WeatherStreamImpl(@Named.from(WeatherService) this.service);

  @override
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
      await Future.delayed(const Duration(minutes: 1));
      final data = await service.fetchWeather(city);
      yield data;
    }
  }

  @override
  void cancel() {
    _cancellationToken = true;
  }
}
```

Dans votre widget, accédez au stream :

```
class WeatherExample extends StatefulWidget {

  const WeatherExample({
    super.key,
  });

  @override
  State<WeatherExample> createState() => _WeatherExampleState();
}

class _WeatherExampleState extends State<WeatherExample> {
  final WeatherStream weather = getIt<WeatherStream>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text("Votre Météo"),
      ),
      body: Center(
        child: StreamBuilder<List<WeatherData>>(
          stream: weather.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (snapshot.data ?? []).map((e) =>
                  Text("${e.city} : ${e.temperatureInCelsius} °C")).toList(),
            );
          },
        ),
      ),
    );
  }
}
```

L’injection de dépendance, avec l’aide de `get_it` et `injectable`, offre une manière structurée et efficace de gérer les dépendances dans une application Dart ou Flutter. Elle facilite la testabilité, la réutilisabilité et la séparation des préoccupations, rendant le code plus propre et maintenable.

# **Quelques références**

Dans cet article, nous avons exploré les fondements de la programmation réactive en utilisant les Streams et avons découvert comment les intégrer efficacement grâce à l’injection de dépendance. Bien que ces concepts soient essentiels, ils ne représentent qu’une partie de l’architecture globale d’une application Flutter. J’ai hâte de vous présenter comment ces éléments s’articulent au sein d’une architecture propre (clean architecture), un sujet si riche qu’il mérite son propre article, que je publierai prochainement.

Pendant ce temps, pour ceux d’entre vous désireux d’approfondir davantage, je vous recommande les références suivantes.

Documentation officielle :

- [Documentation officielle sur les Stream](https://dart.dev/tutorials/language/streams) / [API Dart Stream](https://api.dart.dev/stable/3.1.3/dart-async/Stream-class.html)
- [Site officiel Rx](https://reactivex.io/) / [Documentation RxDart](https://pub.dev/packages/rxdart)

Articles :

- [Streams in Dart](https://dev.to/lionnelt/streams-in-dart-21le) par Lionnel Tsuro
- [Reactive Programming Using RxDart For Flutter Applications](https://medium.com/mindful-engineering/reactive-programming-using-rxdart-for-flutter-applications-part-1-a0b70e99a6e2) par Mohit Chauhan