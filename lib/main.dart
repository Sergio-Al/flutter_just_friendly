import 'dart:ui';

import 'package:family_chat/screens/Introduction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 84, 0, 158),
  background: Color.fromARGB(255, 87, 87, 87),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.montserratAlternatesTextTheme().copyWith(
    titleSmall: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
    ),
  ),
);

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      useCountryCode: false,
      fallbackFile: 'en',
      basePath: 'assets/flutter_i18n',
      forcedLocale: Locale('es'),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(MyApp(
    showHome: showHome,
    flutterI18nDelegate: flutterI18nDelegate,
  ));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  final FlutterI18nDelegate flutterI18nDelegate;

  const MyApp(
      {super.key, required this.showHome, required this.flutterI18nDelegate});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print(FlutterI18n.translate(context, 'title'));
    return MaterialApp(
        localizationsDelegates: [
          flutterI18nDelegate,
        ],
        builder: FlutterI18n.rootAppBuilder(),
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: showHome
            ? MyHomePage(
                // title: FlutterI18n.translate(context, "title"),
                title: "name",
              )
            : IntroScreen());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(FlutterI18n.translate(context, "title"))),
      body: Builder(
        builder: (BuildContext context) => StreamBuilder<bool>(
          initialData: true,
          stream: FlutterI18n.retrieveLoadedStream(context),
          builder: (BuildContext context, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                I18nText("label.main",
                    translationParams: {"user": "User!!!"}),
                I18nPlural("clicked.times", _counter),
                TextButton(
                  key: Key('incrementCounter'),
                  onPressed: () async {
                    _incrementCounter();
                  },
                  child: Text(
                    FlutterI18n.translate(context, "button.label.clickMea",
                        fallbackKey: "button.label.clickMe"),
                  ),
                ),
                TextButton(
                  key: Key('changeLanguage'),
                  onPressed: () async {
                    final Locale? currentLang =
                        FlutterI18n.currentLocale(context);
                    await FlutterI18n.refresh(
                        context,
                        currentLang!.languageCode == 'en'
                            ? Locale('es')
                            : Locale('en'));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          FlutterI18n.translate(context, "button.toastMessage"),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    FlutterI18n.translate(context, "button.label.language"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
