import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stockkeeper/app/items/page.dart';
import 'package:stockkeeper/app/categories/page.dart';
import 'package:stockkeeper/app/categories/new/page.dart';
import 'package:stockkeeper/app/categories/edit/page.dart';
import 'package:stockkeeper/app/items/id/page.dart';
import 'package:stockkeeper/app/items/new/page.dart';
import 'package:stockkeeper/app/login/page.dart';
import 'package:stockkeeper/app/cart/page.dart';
import 'package:stockkeeper/utils/graphql.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initHiveForFlutter();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GraphQLClient> client =
        ValueNotifier<GraphQLClient>(graphqlClient());

    return GraphQLProvider(
        client: client,
        child: MaterialApp.router(
          routerDelegate: goRouter.routerDelegate,
          routeInformationParser: goRouter.routeInformationParser,
          routeInformationProvider: goRouter.routeInformationProvider,
          title: 'Stock Keeper',
          theme: ThemeData(
              fontFamily: 'NotoSansJP',
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.white)),
              scaffoldBackgroundColor: Colors.transparent,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
                bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
                bodySmall: TextStyle(color: Colors.white, fontSize: 14),
              )),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja'), // 日本語
          ],
        ));
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        print('authSnapshot: $authSnapshot');
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (authSnapshot.hasData) {
          return const MyHomePage();
        } else {
          return const Login();
        }
      },
    );
  }
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        name: "home",
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const AuthWrapper());
        }),
    GoRoute(
        path: '/categories/new',
        name: "category_new",
        pageBuilder: (context, state) {
          final args = state.extra as CategoryNew;
          return MaterialPage(
              key: state.pageKey,
              child: CategoryNew(
                onCallback: args.onCallback,
              ));
        }),
    GoRoute(
        path: '/categories/edit',
        name: "category_edit",
        pageBuilder: (context, state) {
          final args = state.extra as CategoryEdit;
          return MaterialPage(
              key: state.pageKey,
              child: CategoryEdit(
                  id: args.id, name: args.name, onCallback: args.onCallback));
        }),
    GoRoute(
        path: '/items/new',
        name: "item_new",
        pageBuilder: (context, state) {
          final args = state.extra as NewItem;
          return MaterialPage(
              key: state.pageKey,
              child: NewItem(
                  categoryId: args.categoryId, onCallback: args.onCallback));
        }),
    GoRoute(
        path: '/items/:id',
        name: "item_detail",
        pageBuilder: (context, state) {
          final args = state.extra as ItemDetail;
          final id = int.tryParse(state.pathParameters['id']!)!;
          return MaterialPage(
              key: state.pageKey,
              child: ItemDetail(id: id, onCallback: args.onCallback));
        }),
    GoRoute(
        path: '/login',
        name: "login",
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const Login());
        }),
    GoRoute(
        path: '/cart',
        name: "cart",
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const Cart());
        }),
    GoRoute(
        path: '/categories/:id',
        name: "category_id",
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id']!)!;
          return MaterialPage(key: state.pageKey, child: Items(id: id));
        }),
  ],
  // 遷移ページがないなどのエラーが発生した時に、このページに行く
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  ),
);
