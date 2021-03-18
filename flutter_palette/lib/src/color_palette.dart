import 'package:flutter/painting.dart' show Color;
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:palette/palette.dart' as cp;
import 'package:palette/palette.dart' show ColorSpace;
import 'package:unique_list/unique_list.dart';

/// Contains a [List] of [ColorModel]s.
///
/// Has constructors for generating new color palettes, as well as methods
/// and operators for modifying and extracting colors from the palette.
class ColorPalette extends cp.ColorPalette {
  /// Contains a [List] of [ColorModel]s.
  ///
  /// Has constructors for generating new color palettes, as well as methods
  /// and operators for modifying and extracting colors from the palette.
  ///
  /// [colors] must not be `null`.
  const ColorPalette(this.colors) : super(colors);

  @override
  final List<ColorModel> colors;

  /// Returns the color palette as a list of [Color]s.
  List<Color> toColors({bool growable = true}) =>
      colors.map<Color>((color) => color.toColor()).toList(growable: growable);

  @override
  ColorPalette getRange(int start, int end) =>
      ColorPalette(colors.getRange(start, end).toList());

  /// Constructs a [ColorPalette] from [colors].
  factory ColorPalette.from(List<Color> colors) {
    return ColorPalette(List<ColorModel>.from(
        colors.map((color) => RgbColor.fromColor(color))));
  }

  /// Returns a [ColorPalette] with an empty list of [colors].
  factory ColorPalette.empty() => ColorPalette(<ColorModel>[]);

  /// Generates a [ColorPalette] by selecting colors with hues
  /// to both sides of [color]'s hue value.
  ///
  /// If [numberOfColors] is odd, [color] will be included in the palette.
  /// If even, [color] will be excluded from the palette. [numberOfColors]
  /// defaults to `5`, must be `> 0`, and must not be `null`.
  ///
  /// [distance] is the base spacing between the selected colors' hue values.
  /// [distance] defaults to `30` degrees and must not be `null`.
  ///
  /// [hueVariability], [saturationVariability], and [brightnessVariability],
  /// if `> 0`, add a degree of randomness to the selected color's hue,
  /// saturation, and brightness (HSB's value) values, respectively.
  ///
  /// [hueVariability] defaults to `0`, must be `>= 0 && <= 360`,
  /// and must not be `null`.
  ///
  /// [saturationVariability] and [brightnessVariability] both default to `0`,
  /// must be `>= 0 && <= 100`, and must not be `null`.
  factory ColorPalette.adjacent(
    Color seed, {
    int numberOfColors = 5,
    num distance = 30,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
    bool perceivedBrightness = true,
    bool growable = true,
    bool unique = false,
  }) {
    assert(numberOfColors > 0);
    assert(hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability >= 0 && saturationVariability <= 100);
    assert(brightnessVariability >= 0 && brightnessVariability <= 100);
    return ColorPalette(_cast(
      cp.ColorPalette.adjacent(
        RgbColor.fromColor(seed),
        numberOfColors: numberOfColors,
        distance: distance,
        hueVariability: hueVariability,
        saturationVariability: saturationVariability,
        brightnessVariability: brightnessVariability,
        perceivedBrightness: perceivedBrightness,
      ),
      growable: growable,
      unique: unique,
    ));
  }

  /// Generates a [ColorPalette] by selecting colors with hues
  /// evenly spaced around the color wheel from [color].
  ///
  /// [numberOfColors] defaults to `5`, must be `> 0` and must
  /// not be `null`.
  ///
  /// [hueVariability], [saturationVariability], and [brightnessVariability],
  /// if `> 0`, add a degree of randomness to the selected color's hue,
  /// saturation, and brightness (HSB's value) values, respectively.
  ///
  /// [hueVariability] defaults to `0`, must be `>= 0 && <= 360`,
  /// and must not be `null`.
  ///
  /// [saturationVariability] and [brightnessVariability] both default to `0`,
  /// must be `>= 0 && <= 100`, and must not be `null`.
  factory ColorPalette.polyad(
    Color seed, {
    int numberOfColors = 5,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
    bool perceivedBrightness = true,
    bool clockwise = true,
    bool growable = true,
    bool unique = false,
  }) {
    assert(numberOfColors > 0);
    assert(hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability >= 0 && saturationVariability <= 100);
    assert(brightnessVariability >= 0 && brightnessVariability <= 100);
    return ColorPalette(_cast(
      cp.ColorPalette.polyad(
        RgbColor.fromColor(seed),
        numberOfColors: numberOfColors,
        hueVariability: hueVariability,
        saturationVariability: saturationVariability,
        brightnessVariability: brightnessVariability,
        perceivedBrightness: perceivedBrightness,
        clockwise: clockwise,
      ),
      growable: growable,
      unique: unique,
    ));
  }

  /// Generates a [ColorPalette] with [numberOfColors] at random, constrained
  /// within the specified hue, saturation, and brightness ranges.
  ///
  /// [minHue] and [maxHue] are used to set the range of hues that will be
  /// selected from. If `minHue < maxHue`, the range will run in a clockwise
  /// direction between the two, however if `minHue > maxHue`, the range will
  /// run in a counter-clockwise direction. Both [minHue] and [maxHue] must
  /// be `>= 0 && <= 360` and must not be `null`.
  ///
  /// [minSaturation] and [maxSaturation] are used to set the range of the
  /// generated colors' saturation values. [minSaturation] must be
  /// `<= maxSaturation` and [maxSaturation] must be `>= minSaturation`.
  /// Both [minSaturation] and [maxSaturation] must be `>= 0 && <= 100`.
  ///
  /// [minBrightness] and [maxBrightness] are used to set the range of the
  /// generated colors' percieved brightness values. [minBrightness] must be
  /// `<= maxBrightness` and [maxBrightness] must be `>= minBrightness`.
  /// Both [minBrightness] and [maxBrightness] must be `>= 0 && <= 100`.
  ///
  /// If [distributeHues] is `true`, the generated colors will be spread
  /// evenly across the range of hues allowed for. [distributeHues] must
  /// not be `null`.
  ///
  /// [distributionVariability] will add a degree of randomness to the selected
  /// hues, if [distributeHues] is `true`. If `null`, [distributionVariability]
  /// defaults to `(minHue - maxHue).abs() / numberOfColors / 4`. To allow for
  /// no variability at all, [distributionVariability] must be set to `0`.
  ///
  /// [colorSpace] defines the color space colors will be generated and
  /// returned in. [colorSpace] defaults to [ColorSpace.rgb] and must not
  /// be `null`.
  factory ColorPalette.random(
    int numberOfColors, {
    ColorSpace colorSpace = ColorSpace.rgb,
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minBrightness = 0,
    num maxBrightness = 100,
    bool perceivedBrightness = true,
    bool distributeHues = true,
    num? distributionVariability,
    bool clockwise = true,
    bool growable = true,
    bool unique = false,
  }) {
    assert(numberOfColors > 0);
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minBrightness >= 0 && minBrightness <= maxBrightness);
    assert(maxBrightness >= minBrightness && maxBrightness <= 100);
    return ColorPalette(_cast(
      cp.ColorPalette.random(
        numberOfColors,
        colorSpace: colorSpace,
        minHue: minHue,
        maxHue: maxHue,
        minSaturation: minSaturation,
        maxSaturation: maxSaturation,
        minBrightness: minBrightness,
        maxBrightness: maxBrightness,
        perceivedBrightness: perceivedBrightness,
        distributeHues: distributeHues,
        distributionVariability: distributionVariability,
        clockwise: clockwise,
      ),
      growable: growable,
      unique: unique,
    ));
  }

  /// Generates a [ColorPalette] by selecting colors to both sides
  /// of the color with the opposite [hue] of [color].
  ///
  /// If [numberOfColors] is even, the coolor opposite of [color] will
  /// be included in the palette. If odd, the opposite color will be
  /// excluded from the palette. [numberOfColors] defaults to `3`, must
  /// be `> 0`, and must not be `null`.
  ///
  /// [distance] is the base spacing between the selected colors' hue values.
  /// [distance] defaults to `30` degrees and must not be `null`.
  ///
  /// [hueVariability], [saturationVariability], and [brightnessVariability],
  /// if `> 0`, add a degree of randomness to the selected color's hue,
  /// saturation, and brightness (HSB's value) values, respectively.
  ///
  /// [hueVariability] defaults to `0`, must be `>= 0 && <= 360`,
  /// and must not be `null`.
  ///
  /// [saturationVariability] and [brightnessVariability] both default to `0`,
  /// must be `>= 0 && <= 100`, and must not be `null`.
  factory ColorPalette.splitComplimentary(
    Color seed, {
    int numberOfColors = 3,
    num distance = 30,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
    bool perceivedBrightness = true,
    bool growable = true,
    bool unique = false,
  }) {
    assert(numberOfColors > 0);
    assert(hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability >= 0 && saturationVariability <= 100);
    assert(brightnessVariability >= 0 && brightnessVariability <= 100);
    return ColorPalette(_cast(
      cp.ColorPalette.splitComplimentary(
        RgbColor.fromColor(seed),
        numberOfColors: numberOfColors,
        distance: distance,
        hueVariability: hueVariability,
        saturationVariability: saturationVariability,
        brightnessVariability: brightnessVariability,
        perceivedBrightness: perceivedBrightness,
      ),
      growable: growable,
      unique: unique,
    ));
  }

  /// Generates a [ColorPalette] from [colorPalette] by appending or
  /// inserting the opposite colors of every color in [colorPalette].
  ///
  /// __Note:__ Use the [opposite] methods to flip every color in a
  /// palette to their respective opposites without preserving the
  /// original colors.
  ///
  /// [colorPalette] must not be `null`.
  ///
  /// If [insertOpposites] is `true`, the generated colors will be inserted
  /// into the list of colors after their respective base colors. If `false`,
  /// the generated colors will be appended to the end of the list.
  /// [insertOpposites] defaults to `true` and must not be `null`.
  factory ColorPalette.opposites(
    ColorPalette colorPalette, {
    bool insertOpposites = true,
    bool growable = true,
    bool unique = false,
  }) {
    return ColorPalette(_cast(
      cp.ColorPalette.opposites(
        colorPalette,
        insertOpposites: insertOpposites,
      ),
      growable: growable,
      unique: unique,
    ));
  }

  /// Returns the concatenation of this palette's colors and [other]s'.
  ///
  /// [other] may be a [ColorPalette], [List<Color>], or a [List<ColorModel>].
  @override
  ColorPalette operator +(dynamic other) {
    assert(other is ColorPalette ||
        other is List<ColorModel> ||
        other is List<Color>);

    late List<ColorModel> colors;

    if (other is ColorPalette) {
      colors = other.colors;
    } else if (other is List<ColorModel>) {
      colors = other;
    } else if (other is List<Color>) {
      colors = List<ColorModel>.from(
          other.map((color) => RgbColor.fromColor(color)));
    }

    return ColorPalette(this.colors + colors);
  }

  /// Casts the colors in [palette] from the [color_model] package's
  /// [ColorModel] class, to the [flutter_color_model] package's [ColorModel]
  /// class.
  static List<ColorModel> _cast(
    cp.ColorPalette palette, {
    required bool growable,
    required bool unique,
  }) {
    final colors = palette.colors.map<ColorModel>((color) {
      late ColorModel castColor;
      final colorValues = color.toListWithAlpha();

      if (color is cp.CmykColor) {
        castColor = CmykColor.fromList(colorValues);
      } else if (color is cp.HsbColor) {
        castColor = HsbColor.fromList(colorValues);
      } else if (color is cp.HsiColor) {
        castColor = HsiColor.fromList(colorValues);
      } else if (color is cp.HslColor) {
        castColor = HslColor.fromList(colorValues);
      } else if (color is cp.HspColor) {
        castColor = HspColor.fromList(colorValues);
      } else if (color is cp.LabColor) {
        castColor = LabColor.fromList(colorValues);
      } else if (color is cp.OklabColor) {
        castColor = OklabColor.fromList(colorValues.cast<double>());
      } else if (color is cp.RgbColor) {
        castColor = RgbColor.fromList(color.toPreciseListWithAlpha());
      } else if (color is cp.XyzColor) {
        castColor = XyzColor.fromList(colorValues);
      }

      return castColor;
    });

    return unique
        ? UniqueList<ColorModel>.of(colors, growable: growable)
        : List<ColorModel>.of(colors, growable: growable);
  }
}
