/// A library for creating, generating, and interfacing with color palettes.
/// With support for constructing colors in the CMYK, HSI, HSL, HSP, HSB, LAB,
/// Oklab, RGB, and XYZ color spaces.
library flutter_palette;

export 'package:flutter/painting.dart' show Color;
export 'package:flutter_color_models/flutter_color_models.dart';
export 'package:palette/palette.dart'
    show ColorSortingProperty, ColorSortingDirection;
export 'src/color_palette.dart';
