import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_feed_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const PlaceProofApp());
}

class PlaceProofApp extends StatelessWidget {
  const PlaceProofApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlaceProof',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryAccent,
          primary: AppColors.primaryAccent,
          surface: AppColors.background,
        ),
        fontFamily: GoogleFonts.manrope().fontFamily,
      ),
      builder: (context, child) {
        // Keeps a clean mobile aspect ratio container if viewed on desktop / wide web browsers
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return Container(
                color: const Color(0xFFEFE8E4),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 440),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              );
            }
            return child ?? const SizedBox.shrink();
          },
        );
      },
      home: const HomeFeedScreen(),
    );
  }
}
