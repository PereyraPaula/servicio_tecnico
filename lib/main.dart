import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicio_tecnico/components/CustomAppBar.dart';
import 'package:servicio_tecnico/provider/DataProvider.dart';
import 'package:servicio_tecnico/provider/ThemeProvider.dart';
import 'package:servicio_tecnico/screens/HomeScreenMobile.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DataProvider(),
    child: const MyApp(),
  ));
}

const String titleApp = "Servicio Técnico";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(builder: (context) {
        final contextTheme = context.watch<ThemeProvider>();

        return MaterialApp(
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            debugShowCheckedModeBanner: false,
            title: titleApp,
            theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: contextTheme.colorSelected,
                scaffoldBackgroundColor: const Color(0xFFFFFFFF),
                brightness: Brightness.light),
            darkTheme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: contextTheme.colorSelected,
                scaffoldBackgroundColor: const Color(0xFF121212),
                brightness: Brightness.dark),
            themeMode:
                contextTheme.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: const MyHomePage(title: titleApp),
            supportedLocales: const [Locale('es')]);
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider ctxTheme = context.read<ThemeProvider>();

    return Scaffold(
        appBar: CustomAppBar(
          title: titleApp,
          styleTitle: const TextStyle(color: Colors.white),
          colorBackground: ctxTheme.colorSelected,
          showSwitch: true,
        ),
        body: Consumer<DataProvider>(builder: (context, dataProvider, child) {
          final data = dataProvider.data;
          String total = context.read<DataProvider>().total;
          int quantity = context.read<DataProvider>().quantity;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return HomeScreenMobile(
                        data: data,
                        total: total,
                        quantity: quantity,
                        addItem: (Map<String, dynamic> data) {
                          context.read<DataProvider>().addItem(data);
                        });
                    //
                  } else {
                    return const Text(
                        "Proximamente adaptado para más dispositivos");
                    // TODO: Agregar pantalla para dispositivos más grandes.
                  }
                },
              ),
            ),
          );
        }));
  }
}
