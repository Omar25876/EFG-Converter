import 'package:flutter/material.dart';

// Primary Brand — Rose Magenta
const Color primary      = Color(0xFFE0245E); // Vivid rose
const Color primaryLight = Color(0xFFFF6B9D); // Soft pink
const Color primaryDark  = Color(0xFFA8174A); // Deep crimson

//  Accent — Amber Gold
const Color accent      = Color(0xFFF59E0B); // Amber gold
const Color accentLight = Color(0xFFFCD34D); // Pale gold

//  Dark Mode Backgrounds — Deep Midnight
const Color backgroundDark     = Color(0xFF0D0D14); // Near-black midnight
const Color surfaceDark        = Color(0xFF13121F); // Dark navy surface
const Color surfaceVariantDark = Color(0xFF1C1B2E); // Card bg
const Color inputDark          = Color(0xFF231F3A); // Input bg
const Color bgDark             = Color(0xFF0D0D14); // alias
const Color bgSurface          = Color(0xFF13121F); // alias
const Color bgCard             = Color(0xFF1C1B2E); // alias
const Color bgInput            = Color(0xFF231F3A); // alias

// Light Mode Backgrounds — Warm Cream
const Color background     = Color(0xFFFFF8F0); // Warm cream page
const Color surface        = Color(0xFFFFFFFF); // Pure white cards
const Color surfaceVariant = Color(0xFFFFF1E6); // Peach-tinted input bg

// Text — Dark Mode
const Color textOnDark = Color(0xFFF5EEF8); // Soft lavender white
const Color textMuted  = Color(0xFF7C7A94); // Muted purple-grey

// Text — Light Mode
const Color textDark      = Color(0xFF1A0A2E); // Deep purple-black
const Color textPrimary   = Color(0xFF1A0A2E); // alias
const Color textSecondary = Color(0xFF6D5D7B); // Muted mauve
const Color textHint      = Color(0xFFB0A0BF); // Light mauve hint

// Borders
const Color borderDark  = Color(0xFF2E2A45); // Dark purple border
const Color borderLight = Color(0xFFEFDFF5); // Soft lavender border
const Color border      = Color(0xFF2E2A45); // alias (dark default)
const Color borderFocus = Color(0xFFE0245E); // Rose focus ring

// Semantic
const Color success = Color(0xFF00C896); // Teal-mint
const Color error   = Color(0xFFFF3B5C); // Hot coral red
const Color warning = Color(0xFFF59E0B); // Amber

// Gradients

// Hero: Rose → Purple — used on buttons, swap, shimmer
const LinearGradient heroGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE0245E), Color(0xFF9B2EAE)],
);

// Accent: Gold → Amber — used on result card shader
const LinearGradient accentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFF59E0B), Color(0xFFE07B00)],
);

// Card: dark surface gradient
const LinearGradient cardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF1C1B2E), Color(0xFF13121F)],
);

// Aurora: teal → indigo — decorative glow orbs
const LinearGradient auroraGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF00C896), Color(0xFF6C3AED)],
);

// Sunrise: rose → gold — light mode hero card
const LinearGradient sunriseGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE0245E), Color(0xFFF59E0B)],
);