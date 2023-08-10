import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furnai/amplifyconfiguration.dart';
import 'package:furnai/models/ModelProvider.dart';
import 'package:furnai/presentation/image_gallery.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([api, auth, storage]);
    await Amplify.configure(amplifyconfig);
    print('Successfully configured');
  } on Exception catch (e) {
    print('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ImageGallery(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Authenticator(
        child: MaterialApp.router(
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          builder: Authenticator.builder(),
          theme: FlexThemeData.light(
            scheme: FlexScheme.orangeM3,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 7,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.orangeM3,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 13,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 20,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
          ),
          themeMode: ThemeMode.system,
        ),
      ),
    );
  }
}
