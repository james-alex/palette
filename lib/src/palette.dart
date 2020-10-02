import 'dart:math';
import 'package:color_models/color_models.dart';
import 'package:highest_lowest/highest_lowest.dart';
import 'package:unique_list/unique_list.dart';

/// The color spaces by type: CMYK, HSI, HSL, HSP, HSB, LAB, RGB, and XYZ.
enum ColorSpace {
  /// Cyan, Magenta, Yellow, Black
  cmyk,

  /// Hue, Saturation, Intensity
  hsi,

  /// Hue, Saturation, Lightness
  hsl,

  /// Hue, Saturation, Perceived Brightness
  hsp,

  /// Hue, Saturation, Brightness
  hsb,

  /// Lightness, A (green to red), B (blue to yellow)
  lab,

  /// Red, Green, Blue
  rgb,

  /// __See:__ https://en.wikipedia.org/wiki/CIE_1931_color_space
  xyz,
}

/// The properties of a color that can be used for sorting.
///
/// Used by [ColorPalette]'s [sortBy] method.
enum ColorSortingProperty {
  /// Sorts the colors in the palette from the highest
  /// perceived brightness value to the lowest.
  brightest,

  /// Sorts the colors in the palette from the lowest
  /// perceived brightness value to the highest.
  dimmest,

  /// Sorts the colors in the palette from the highest
  /// lightness value to the lowest.
  lightest,

  /// Sorts the colors in the palette from the lowest
  /// lightness value to the highest.
  darkest,

  /// Sorts the colors in the palette from the highest
  /// intensity value to the lowest.
  mostIntense,

  /// Sorts the colors in the palette from the lowest
  /// intensity value to the highest.
  leastIntense,

  /// Sorts the colors in the palette from the highest
  /// saturation value to the lowest.
  deepest,

  /// Sorts the colors in the palette from the lowest
  /// saturation value to the highest.
  dullest,

  /// Sorts the colors in the palette from the highest combined
  /// saturation and brightness values to the lowest.
  richest,

  /// Sorts the colors in the palette from the lowest combined
  /// saturation and brightness values to the highest.
  muted,

  /// Sorts the colors by their distance to a red hue. (0°)
  ///
  /// __Note:__ To sort colors by their hue from red going in a single
  /// direction around the color wheel, use `sortByHue(0)`.
  red,

  /// Sorts the colors by their distance to a red-orange hue. (30°)
  ///
  /// __Note:__ To sort colors by their hue from red-orange going in a single
  /// direction around the color wheel, use `sortByHue(30)`.
  redOrange,

  /// Sorts the colors by their distance to a orange hue. (60°)
  ///
  /// __Note:__ To sort colors by their hue from orange going in a single
  /// direction around the color wheel, use `sortByHue(60)`.
  orange,

  /// Sorts the colors by their distance to a yellow-orange hue. (90°)
  ///
  /// __Note:__ To sort colors by their hue from yellow-orange going in a single
  /// direction around the color wheel, use `sortByHue(90)`.
  yellowOrange,

  /// Sorts the colors by their distance to a yellow hue. (120°)
  ///
  /// __Note:__ To sort colors by their hue from yellow going in a single
  /// direction around the color wheel, use `sortByHue(120)`.
  yellow,

  /// Sorts the colors by their distance to a yellow-green hue. (150°)
  ///
  /// __Note:__ To sort colors by their hue from yellow-green going in a single
  /// direction around the color wheel, use `sortByHue(150)`.
  yellowGreen,

  /// Sorts the colors by their distance to a green hue. (180°)
  ///
  /// __Note:__ To sort colors by their hue from green going in a single
  /// direction around the color wheel, use `sortByHue(180)`.
  green,

  /// Sorts the colors by their distance to a cyan hue. (210°)
  ///
  /// __Note:__ To sort colors by their hue from cyan going in a single
  /// direction around the color wheel, use `sortByHue(210)`.
  cyan,

  /// Sorts the colors by their distance to a blue hue. (240°)
  ///
  /// __Note:__ To sort colors by their hue from blue going in a single
  /// direction around the color wheel, use `sortByHue(240)`.
  blue,

  /// Sorts the colors by their distance to a blue-violet hue. (270°)
  ///
  /// __Note:__ To sort colors by their hue from blue-violet going in a single
  /// direction around the color wheel, use `sortByHue(270)`.
  blueViolet,

  /// Sorts the colors by their distance to a violet hue. (300°)
  ///
  /// __Note:__ To sort colors by their hue from violet going in a single
  /// direction around the color wheel, use `sortByHue(300)`.
  violet,

  /// Sorts the colors by their distance to a magenta hue. (330°)
  ///
  /// __Note:__ To sort colors by their hue from magenta going in a single
  /// direction around the color wheel, use `sortByHue(330)`.
  magenta,

  /// Sorts the colors from the first color in the palette in the order
  /// of the values closest to the previous colors' values.
  similarity,

  /// Sorts the colors from the first color in the palette in the order
  /// of the values furthest to the previous colors' values.
  difference,
}

/// Directions around a color wheel from a starting point.
///
/// Used by [ColorPalette]'s [sortByHue] method.
enum ColorSortingDirection {
  /// Sort hues clockwise from the starting point.
  clockwise,

  /// Sort hues counter-clockwise from the starting point.
  counterClockwise,
}

/// A color palette made of a [List] of [ColorModel]s.
///
/// Has constructors for generating new color palettes, as well as methods
/// and operators for modifying and extracting colors from the palette.
class ColorPalette {
  /// A color palette made of a [List] of [ColorModel]s.
  ///
  /// Has constructors for generating new color palettes, as well as methods
  /// and operators for modifying and extracting colors from the palette.
  ///
  /// [colors] contains all of the colors in the palette, it must not be `null`,
  /// but it may be empty.
  const ColorPalette(this.colors) : assert(colors != null);

  /// The colors contained in the palette.
  final List<ColorModel> colors;

  /// Returns the color with the highest perceived brightness value.
  ColorModel get brightest => colors.reduce((color1, color2) {
        return color1.toHspColor().perceivedBrightness <
                color2.toHspColor().perceivedBrightness
            ? color2
            : color1;
      });

  /// Returns the color with the lowest perceived brightness value.
  ColorModel get dimmest => colors.reduce((color1, color2) {
        return color1.toHspColor().perceivedBrightness <
                color2.toHspColor().perceivedBrightness
            ? color1
            : color2;
      });

  /// Returns the color with the highest lightness value.
  ColorModel get lightest => colors.reduce((color1, color2) {
        return color1.toHslColor().lightness < color2.toHslColor().lightness
            ? color2
            : color1;
      });

  /// Returns the color with the lowest lightness value.
  ColorModel get darkest => colors.reduce((color1, color2) {
        return color1.toHslColor().lightness < color2.toHslColor().lightness
            ? color1
            : color2;
      });

  /// Returns the color with the highest intensity value.
  ColorModel get mostIntense => colors.reduce((color1, color2) {
        return color1.toHsiColor().intensity < color2.toHsiColor().intensity
            ? color2
            : color1;
      });

  /// Returns the color with the lowest intensity value.
  ColorModel get leastIntense => colors.reduce((color1, color2) {
        return color1.toHsiColor().intensity < color2.toHsiColor().intensity
            ? color1
            : color2;
      });

  /// Returns the color with the highest saturation value.
  ColorModel get deepest => colors.reduce((color1, color2) =>
      color1.saturation < color2.saturation ? color2 : color1);

  /// Returns the color with the lowest saturation value.
  ColorModel get dullest => colors.reduce((color1, color2) =>
      color1.saturation < color2.saturation ? color1 : color2);

  /// Returns the color with the highest combined saturation
  /// and brightness values.
  ColorModel get richest => colors.reduce((color1, color2) {
        final hsb1 = color1.toHsbColor();
        final hsb2 = color2.toHsbColor();

        final value1 = hsb1.saturation + hsb1.brightness;
        final value2 = hsb2.saturation + hsb2.brightness;

        return value1 < value2 ? color2 : color1;
      });

  /// Returns the color with the lowest combined saturation
  /// and brightness values.
  ColorModel get muted => colors.reduce((color1, color2) {
        final hsb1 = color1.toHsbColor();
        final hsb2 = color2.toHsbColor();

        final value1 = hsb1.saturation + hsb1.brightness;
        final value2 = hsb2.saturation + hsb2.brightness;

        return value1 < value2 ? color1 : color2;
      });

  /// Returns the color with the reddest hue. (0°)
  ColorModel get red =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 0));

  /// Returns the color with the most red-orange hue. (30°)
  ColorModel get redOrange =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 30));

  /// Returns the color with the orangest hue. (60°)
  ColorModel get orange =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 60));

  /// Returns the color with the most yellow-orange hue. (90°)
  ColorModel get yellowOrange =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 90));

  /// Returns the color with the yellowest hue. (120°)
  ColorModel get yellow =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 120));

  /// Returns the color with the most yellow-green hue. (150°)
  ColorModel get yellowGreen =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 150));

  /// Returns the color with the greenest hue. (180°)
  ColorModel get green =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 180));

  /// Returns the color with the most cyan hue. (210°)
  ColorModel get cyan =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 210));

  /// Returns the color with the most bluest hue. (240°)
  ColorModel get blue =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 240));

  /// Returns the color with the most blue-violet hue. (270°)
  ColorModel get blueViolet =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 270));

  /// Returns the color with the most violet hue. (300°)
  ColorModel get violet =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 300));

  /// Returns the color with the most magenta hue. (330°)
  ColorModel get magenta =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 330));

  /// Returns the color with the values closest to [color].
  ///
  /// The difference in values is determined by calculating the difference
  /// between each colors' respective hue, saturation, and perceived brightness
  /// values, giving the difference in hue twice the weight of the difference
  /// in the saturation and perceived brightness values.
  ColorModel closest(ColorModel color) {
    assert(color != null);

    return _closest(color, colors);
  }

  /// Returns the color in [palette] with the values closest to [color].
  ColorModel _closest(ColorModel color, List<ColorModel> palette) {
    assert(color != null);
    assert(palette != null);

    ColorModel closestColor;
    double lowestDifference;

    for (var paletteColor in palette) {
      final difference = _calculateDifference(color, paletteColor);

      if (lowestDifference == null || lowestDifference < difference) {
        lowestDifference = difference;
        closestColor = paletteColor;
      }
    }

    return closestColor;
  }

  /// Returns the color with the values furthest from [color].
  ///
  /// The difference in values is determined by calculating the difference
  /// between each colors' respective hue, saturation, and perceived brightness
  /// values, giving the difference in hue twice the weight of the difference
  /// in the saturation and perceived brightness values.
  ColorModel furthest(ColorModel color) {
    assert(color != null);

    return _furthest(color, colors);
  }

  /// Returns the color with the values furthest from [color].
  ColorModel _furthest(ColorModel color, List<ColorModel> palette) {
    assert(color != null);
    assert(palette != null);

    ColorModel furthestColor;
    num highestDifference;

    for (var paletteColor in palette) {
      final difference = _calculateDifference(color, paletteColor);

      if (highestDifference == null || highestDifference > difference) {
        highestDifference = difference;
        furthestColor = paletteColor;
      }
    }

    return furthestColor;
  }

  /// Compares the distance between [hue] and [color1]/[color2].
  /// The color closest to [hue] will be returned.
  static ColorModel _compareDistance(
    ColorModel color1,
    ColorModel color2,
    num hue,
  ) {
    assert(color1 != null);
    assert(color2 != null);
    assert(hue != null && hue >= 0 && hue <= 360);

    final distance1 = _calculateDistance(color1.hue, hue);
    final distance2 = _calculateDistance(color2.hue, hue);

    return distance1 <= distance2 ? color1 : color2;
  }

  /// Calculates the distance between [hue1] and [hue2].
  static num _calculateDistance(num hue1, num hue2) {
    assert(hue1 != null && hue1 >= 0 && hue1 <= 360);
    assert(hue2 != null && hue2 >= 0 && hue2 <= 360);

    final distance1 = hue1 > hue2 ? hue1 - hue2 : hue2 - hue1;
    final distance2 = hue1 > hue2 ? (hue2 + 360) - hue1 : (hue1 + 360) - hue2;

    return distance1 < distance2 ? distance1 : distance2;
  }

  /// Calculates the difference between [color1] and [color2] by calculating
  /// the difference between each colors' respective hue, saturation, and
  /// perceived brightness values, giving the difference in hue twice the
  /// weight of the difference in saturation and perceived brightness values.
  static double _calculateDifference(ColorModel color1, ColorModel color2) {
    assert(color1 != null);
    assert(color2 != null);

    color1 = color1.toHspColor();
    color2 = color2.toHspColor();

    final hue = _calculateDistance(color1.hue, color2.hue);
    final saturation = (color1.saturation - color2.saturation).abs();
    final brightness = ((color1 as HspColor).perceivedBrightness -
            (color2 as HspColor).perceivedBrightness)
        .abs();

    return hue + ((saturation + brightness) / 2);
  }

  /// Converts all [colors] into the [ColorModel] representing [colorSpace].
  void toColorSpace(ColorSpace colorSpace) {
    assert(colorSpace != null);

    for (var i = 0; i < colors.length; i++) {
      switch (colorSpace) {
        case ColorSpace.cmyk:
          colors[i] = colors[i].toCmykColor();
          break;
        case ColorSpace.hsi:
          colors[i] = colors[i].toHsiColor();
          break;
        case ColorSpace.hsl:
          colors[i] = colors[i].toHslColor();
          break;
        case ColorSpace.hsp:
          colors[i] = colors[i].toHspColor();
          break;
        case ColorSpace.hsb:
          colors[i] = colors[i].toHsbColor();
          break;
        case ColorSpace.lab:
          colors[i] = colors[i].toLabColor();
          break;
        case ColorSpace.rgb:
          colors[i] = colors[i].toRgbColor();
          break;
        case ColorSpace.xyz:
          colors[i] = colors[i].toXyzColor();
          break;
      }
    }
  }

  /// Inverts the values of every color in the palette in their respective
  /// color spaces.
  void invert() {
    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].inverted;
    }
  }

  /// Rotates the hue of every color in the palette by `180` degrees.
  ///
  /// __Note:__ Use the [ColorPalette.opposites] constructor to generate
  /// a new palette that includes the colors in this palette and their
  /// respective opposites.
  void opposite() {
    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].opposite;
    }
  }

  /// Rotates the hue of every color in the palette by [amount].
  void rotateHue(num amount) {
    assert(amount != null);

    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].rotateHue(amount);
    }
  }

  /// Adjusts the hue of every color in the palette to be warmer by [amount],
  /// capping the value at `90` degrees.
  ///
  /// If [relative] is true, [amount] will be treated as a percentage and the
  /// hue will be adjusted by the percent of the distance from the current hue
  /// to `90` that [amount] represents. If false, [amount] will be treated as
  /// the number of degrees to adjust the hue by.
  void warmer(
    num amount, {
    bool relative = true,
  }) {
    assert(amount != null);
    assert(relative != null);

    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].warmer(amount, relative: relative);
    }
  }

  /// Adjusts the hue of every color in the palette to be cooler by [amount],
  /// capping the value at `270` degrees.
  ///
  /// If [relative] is true, [amount] will be treated as a percentage and the
  /// hue will be adjusted by the percent of the distance from the current hue
  /// to `270` that [amount] represents. If false, [amount] will be treated as
  /// the number of degrees to adjust the hue by.
  void cooler(
    num amount, {
    bool relative = true,
  }) {
    assert(amount != null);
    assert(relative != null);

    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].cooler(amount, relative: relative);
    }
  }

  /// Adds [color] to the end of the palette, extending the length by 1.
  void add(ColorModel color) {
    assert(color != null);
    colors.add(color);
  }

  /// Adds every [ColorModel] contained in [colors] to the end of the palette.
  void addAll(List<ColorModel> colors) {
    assert(colors != null);
    this.colors.addAll(colors);
  }

  /// Inserts the [color] into the palette at the position of [index].
  ///
  /// [index] must be `>= 0 && <= length` and must not be `null`.
  void insert(int index, ColorModel color) {
    assert(index != null && index >= 0 && index <= length);
    assert(color != null);
    colors.insert(index, color);
  }

  /// Inserts all [colors] into the palette at the position of [index].
  ///
  /// [index] must be `>= 0 && <= length` and must not be `null`.
  void insertAll(int index, List<ColorModel> colors) {
    assert(index != null && index >= 0 && index <= length);
    assert(colors != null);
    colors.insertAll(index, colors);
  }

  /// Removes the first occurence of [color] from the palette.
  bool remove(ColorModel color) => colors.remove(color);

  /// Returns a [ColorPalette] of the colors ranging in this
  /// palette from [start] inclusive to [end] exclusive.
  ColorPalette getRange(int start, int end) =>
      ColorPalette(colors.getRange(start, end).toList());

  /// Copies the objects of [colorPalette], skipping [skipCount] objects first,
  /// into the range [start], inclusive, to [end], exclusive, of the palette.
  void setRange(int start, int end, ColorPalette colorPalette,
          [int skipCount = 0]) =>
      colors.setRange(start, end, colorPalette.colors);

  /// Removes the colors from the palette in the range
  /// [start] inclusive to [end] exclusive.
  void removeRange(int start, int end) => colors.removeRange(start, end);

  /// Removes the colors in the range [start] inclusive to [end] exclusive
  /// and inserts the colors in [replacement] in its place.
  void replaceRange(int start, int end, ColorPalette replacement) =>
      colors.replaceRange(start, end, replacement.colors);

  /// Adds all of the colors contained in [colorPalette] to the
  /// end of this palette's [colors] list.
  ///
  /// If [insertAt] is provided, the colors from [colorPalette] will be
  /// inserted into this palette at the position of [insertAt].
  ///
  /// [insertAt], if not `null`, must be `>= 0 && <= length`.
  void combine(ColorPalette colorPalette, [int insertAt]) {
    assert(colorPalette != null);
    assert(insertAt == null || (insertAt >= 0 && insertAt <= length));

    if (insertAt == null) {
      colors.addAll(colorPalette.colors);
    } else {
      colors.insertAll(insertAt, colorPalette.colors);
    }
  }

  /// Reverses the order of the colors in the palette.
  void reverse() => colors.replaceRange(0, length, colors.reversed);

  /// Sorts the palette by [property].
  ///
  /// [property] must not be `null`.
  void sortBy(ColorSortingProperty property) {
    assert(property != null);

    if (property == ColorSortingProperty.similarity ||
        property == ColorSortingProperty.difference) {
      _sortByDifference(property);
      return;
    }

    colors.sort((a, b) {
      num value1;
      num value2;
      var inverse = false;

      switch (property) {
        case ColorSortingProperty.brightest:
          value1 = a.toHspColor().perceivedBrightness;
          value2 = b.toHspColor().perceivedBrightness;
          inverse = true;
          break;
        case ColorSortingProperty.dimmest:
          value1 = a.toHspColor().perceivedBrightness;
          value2 = b.toHspColor().perceivedBrightness;
          break;
        case ColorSortingProperty.lightest:
          value1 = a.toHslColor().lightness;
          value2 = b.toHslColor().lightness;
          inverse = true;
          break;
        case ColorSortingProperty.darkest:
          value1 = a.toHslColor().lightness;
          value2 = b.toHslColor().lightness;
          break;
        case ColorSortingProperty.mostIntense:
          value1 = a.toHsiColor().intensity;
          value2 = b.toHsiColor().intensity;
          inverse = true;
          break;
        case ColorSortingProperty.leastIntense:
          value1 = a.toHsiColor().intensity;
          value2 = b.toHsiColor().intensity;
          break;
        case ColorSortingProperty.deepest:
          value1 = a.saturation;
          value2 = b.saturation;
          inverse = true;
          break;
        case ColorSortingProperty.dullest:
          value1 = a.saturation;
          value2 = b.saturation;
          break;
        case ColorSortingProperty.richest:
          var color1 = a.toHsbColor();
          var color2 = b.toHsbColor();
          value1 = color1.saturation + color1.brightness;
          value2 = color2.saturation + color2.brightness;
          inverse = true;
          break;
        case ColorSortingProperty.muted:
          var color1 = a.toHsbColor();
          var color2 = b.toHsbColor();
          value1 = color1.saturation + color1.brightness;
          value2 = color2.saturation + color2.brightness;
          break;
        case ColorSortingProperty.red:
          value1 = _calculateDistance(0, a.hue);
          value2 = _calculateDistance(0, b.hue);
          break;
        case ColorSortingProperty.redOrange:
          value1 = _calculateDistance(30, a.hue);
          value2 = _calculateDistance(30, b.hue);
          break;
        case ColorSortingProperty.orange:
          value1 = _calculateDistance(60, a.hue);
          value2 = _calculateDistance(60, b.hue);
          break;
        case ColorSortingProperty.yellowOrange:
          value1 = _calculateDistance(90, a.hue);
          value2 = _calculateDistance(90, b.hue);
          break;
        case ColorSortingProperty.yellow:
          value1 = _calculateDistance(120, a.hue);
          value2 = _calculateDistance(120, b.hue);
          break;
        case ColorSortingProperty.yellowGreen:
          value1 = _calculateDistance(150, a.hue);
          value2 = _calculateDistance(150, b.hue);
          break;
        case ColorSortingProperty.green:
          value1 = _calculateDistance(180, a.hue);
          value2 = _calculateDistance(180, b.hue);
          break;
        case ColorSortingProperty.cyan:
          value1 = _calculateDistance(210, a.hue);
          value2 = _calculateDistance(210, b.hue);
          break;
        case ColorSortingProperty.blue:
          value1 = _calculateDistance(240, a.hue);
          value2 = _calculateDistance(240, b.hue);
          break;
        case ColorSortingProperty.blueViolet:
          value1 = _calculateDistance(270, a.hue);
          value2 = _calculateDistance(270, b.hue);
          break;
        case ColorSortingProperty.violet:
          value1 = _calculateDistance(300, a.hue);
          value2 = _calculateDistance(300, b.hue);
          break;
        case ColorSortingProperty.magenta:
          value1 = _calculateDistance(330, a.hue);
          value2 = _calculateDistance(330, b.hue);
          break;
        default:
          break;
      }

      return inverse ? value2.compareTo(value1) : value1.compareTo(value2);
    });
  }

  /// Sorts the colors in the palette by their similarity to one another.
  void _sortByDifference(ColorSortingProperty order) {
    assert(order == ColorSortingProperty.similarity ||
        order == ColorSortingProperty.difference);

    // Compare every color to every other color and calculate the difference
    // between them.
    //
    // Note: Colors are mapped by their indexes rather than by each color, as
    // the keys would not be unique if the palette contained multiple instances
    // of the same color.
    final differences = <int, List<double>>{};

    for (var i = 0; i < length; i++) {
      final comparisons = List<double>(length);

      for (var j = 0; j < length; j++) {
        comparisons[j] =
            i == j ? null : _calculateDifference(colors[i], colors[j]);
      }

      differences.addAll({i: comparisons});
    }

    // Determine the starting color by finding the color that's both the
    // most and least different to the other colors in the palette.
    var startingColor = 0;
    var lowestDifference = differences[0].lowest;
    var highestDifference = differences[0].highest;

    for (var i = 1; i < length; i++) {
      final leastDifferent = differences[i].lowest;
      final mostDifferent = differences[i].highest;

      if ((order == ColorSortingProperty.similarity &&
              (leastDifferent < lowestDifference ||
                  (leastDifferent == lowestDifference &&
                      mostDifferent > highestDifference))) ||
          (order == ColorSortingProperty.difference &&
              (mostDifferent > highestDifference ||
                  (mostDifferent == highestDifference &&
                      leastDifferent < lowestDifference)))) {
        startingColor = i;
        lowestDifference = leastDifferent;
        highestDifference = mostDifferent;
      }
    }

    // Sort the colors in the order of their similiarity
    final newPalette = <ColorModel>[colors[startingColor]];
    final oldPalette = List<ColorModel>.from(colors)..removeAt(startingColor);

    while (oldPalette.isNotEmpty) {
      final color = order == ColorSortingProperty.similarity
          ? _closest(newPalette.last, oldPalette)
          : _furthest(newPalette.last, oldPalette);

      newPalette.add(color);
      oldPalette.remove(color);
    }

    colors.setAll(0, newPalette);
  }

  /// Sorts the palette by each colors hue.
  ///
  /// [startingFrom] sets where on the color wheel the colors will start
  /// sorting from. [startingFrom] must be `>= 0 && <= 360` and must not
  /// be `null`.
  ///
  /// If [clockwise] is `true`, the colors will be sorted in ascending order
  /// around the color wheel. If `false`, they will be sorted in descending
  /// order. [clockwise] must not be `null`.
  void sortByHue({
    num startingFrom = 0,
    bool clockwise = true,
  }) {
    assert(startingFrom != null && startingFrom >= 0 && startingFrom <= 360);
    assert(clockwise != null);

    colors.sort((a, b) {
      var hue1 = a.hue;
      var hue2 = b.hue;

      if (clockwise) {
        if (hue1 < startingFrom) hue1 += 360;
        if (hue2 < startingFrom) hue2 += 360;

        return hue2.compareTo(hue1);
      }

      if (hue1 < startingFrom) hue1 -= 360;
      if (hue2 < startingFrom) hue2 -= 360;

      return hue1.compareTo(hue2);
    });
  }

  /// Returns a [ColorPalette] with an empty list of [colors].
  factory ColorPalette.empty({bool unique = false}) {
    assert(unique != null);

    return ColorPalette(
        unique ? UniqueList<ColorModel>.strict() : <ColorModel>[]);
  }

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
  /// saturation, and brightness values, respectively.
  ///
  /// [hueVariability] defaults to `0`, must be `>= 0 && <= 360`,
  /// and must not be `null`.
  ///
  /// [saturationVariability] and [brightnessVariability] both default to `0`,
  /// must be `>= 0 && <= 100`, and must not be `null`.
  ///
  /// If [perceivedBrightness] is `true`, colors will be generated in the
  /// HSP color space. If `false`, colors will be generated in the HSB
  /// color space.
  factory ColorPalette.adjacent(
    ColorModel color, {
    int numberOfColors = 5,
    num distance = 30,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
    bool perceivedBrightness = true,
    bool unique = false,
  }) {
    assert(color != null);
    assert(distance != null);
    assert(numberOfColors != null && numberOfColors > 0);
    assert(
        hueVariability != null && hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability != null &&
        saturationVariability >= 0 &&
        saturationVariability <= 100);
    assert(brightnessVariability != null &&
        brightnessVariability >= 0 &&
        brightnessVariability <= 100);
    assert(perceivedBrightness != null);
    assert(unique != null);

    final colors = unique ? UniqueList<ColorModel>.strict() : <ColorModel>[];

    if (numberOfColors.isOdd) {
      colors.add(color);
      numberOfColors -= 1;
    }

    for (var i = 1; i <= numberOfColors; i++) {
      colors.add(_generateColor(
        color,
        (i % 2 == 0 ? distance * -1 : distance) * ((i / 2).ceil()),
        hueVariability,
        saturationVariability,
        brightnessVariability,
        perceivedBrightness,
      ));
    }

    return ColorPalette(colors);
  }

  /// Generates a [ColorPalette] by selecting colors with hues
  /// evenly spaced around the color wheel from [color].
  ///
  /// [numberOfColors] defaults to `5`, must be `> 0` and must
  /// not be `null`.
  ///
  /// [hueVariability], [saturationVariability], and [brightnessVariability],
  /// if `> 0`, add a degree of randomness to the selected color's hue,
  /// saturation, and brightness values, respectively.
  ///
  /// [hueVariability] defaults to `0`, must be `>= 0 && <= 360`,
  /// and must not be `null`.
  ///
  /// [saturationVariability] and [brightnessVariability] both default to `0`,
  /// must be `>= 0 && <= 100`, and must not be `null`.
  ///
  /// If [perceivedBrightness] is `true`, colors will be generated in the
  /// HSP color space. If `false`, colors will be generated in the HSB
  /// color space.
  ///
  /// If [clockwise] is `false`, colors will be generated in a clockwise
  /// order around the color wheel. If `true`, colors will be generated in a
  /// counter-clockwise order. [clockwise] must not be `null`.
  factory ColorPalette.polyad(
    ColorModel color, {
    int numberOfColors = 5,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
    bool perceivedBrightness = true,
    bool clockwise = true,
    bool unique = false,
  }) {
    assert(color != null);
    assert(numberOfColors != null && numberOfColors > 0);
    assert(
        hueVariability != null && hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability != null &&
        saturationVariability >= 0 &&
        saturationVariability <= 100);
    assert(brightnessVariability != null &&
        brightnessVariability >= 0 &&
        brightnessVariability <= 100);
    assert(perceivedBrightness != null);
    assert(clockwise != null);

    final colors =
        unique ? UniqueList<ColorModel>.strict() : <ColorModel>[color];

    var distance = 360 / numberOfColors;
    if (!clockwise) distance *= -1;

    for (var i = 1; i < numberOfColors; i++) {
      colors.add(_generateColor(
        color,
        distance * i,
        hueVariability,
        saturationVariability,
        brightnessVariability,
        perceivedBrightness,
      ));
    }

    return ColorPalette(colors);
  }

  /// Generates a [ColorPalette] with [numberOfColors] at random, constrained
  /// within the specified hue, saturation, and brightness ranges.
  ///
  /// [colorSpace] defines the color space colors will be generated and
  /// returned in. [colorSpace] defaults to [ColorSpace.rgb] and must not
  /// be `null`.
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
  /// generated colors' brightness values. [minBrightness] must be
  /// `<= maxBrightness` and [maxBrightness] must be `>= minBrightness`.
  /// Both [minBrightness] and [maxBrightness] must be `>= 0 && <= 100`.
  ///
  /// If [perceivedBrightness] is `true`, colors will be generated in the
  /// HSP color space. If `false`, colors will be generated in the HSB
  /// color space.
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
  /// If [clockwise] is `false`, colors will be generated in a clockwise
  /// order around the color wheel. If `true`, colors will be generated in a
  /// counter-clockwise order. [clockwise] will have no effect if
  /// [distributeHues] is `false`. [clockwise] must not be `null`.
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
    num distributionVariability,
    bool clockwise = true,
    bool unique = false,
  }) {
    assert(numberOfColors != null && numberOfColors > 0);
    assert(colorSpace != null);
    assert(minHue != null && minHue >= 0 && minHue <= 360);
    assert(maxHue != null && maxHue >= 0 && maxHue <= 360);
    assert(minSaturation != null &&
        minSaturation >= 0 &&
        minSaturation <= maxSaturation);
    assert(maxSaturation != null &&
        maxSaturation >= minSaturation &&
        maxSaturation <= 100);
    assert(minBrightness != null &&
        minBrightness >= 0 &&
        minBrightness <= maxBrightness);
    assert(maxBrightness != null &&
        maxBrightness >= minBrightness &&
        maxBrightness <= 100);
    assert(perceivedBrightness != null);
    assert(distributeHues != null);
    assert(clockwise != null);
    assert(unique != null);

    if (!distributeHues &&
        (minHue == 0 && maxHue == 360) &&
        (minSaturation == 0 && maxSaturation == 100) &&
        (minBrightness == 0 && maxBrightness == 100)) {
      final generator = (_) {
        ColorModel color;

        switch (colorSpace) {
          case ColorSpace.cmyk:
            color = CmykColor.random();
            break;
          case ColorSpace.hsi:
            color = HsiColor.random();
            break;
          case ColorSpace.hsl:
            color = HslColor.random();
            break;
          case ColorSpace.hsp:
            color = HspColor.random();
            break;
          case ColorSpace.hsb:
            color = HsbColor.random();
            break;
          case ColorSpace.lab:
            color = LabColor.random();
            break;
          case ColorSpace.rgb:
            color = RgbColor.random();
            break;
          case ColorSpace.xyz:
            color = XyzColor.random();
            break;
        }

        return color;
      };

      final colors = unique
          ? UniqueList<ColorModel>.generate(numberOfColors, generator,
              strict: true)
          : List<ColorModel>.generate(numberOfColors, generator);

      return ColorPalette(colors);
    }

    var distance = (minHue - maxHue) / numberOfColors;
    if (!clockwise) distance *= -1;

    distributionVariability ??= distance.abs() / 4;
    final variabilityRadius = distributionVariability / 2;

    final firstColor = _generateRandomColor(
      colorSpace,
      minHue,
      maxHue,
      minSaturation,
      maxSaturation,
      minBrightness,
      maxBrightness,
      perceivedBrightness,
    );

    final colors = unique
        ? UniqueList<ColorModel>.of([firstColor], strict: true)
        : <ColorModel>[firstColor];

    var hue = colors.first.hue;

    for (var i = 1; i < numberOfColors; i++) {
      hue += distance;
      minHue = (hue - variabilityRadius) % 360;
      maxHue = (hue + variabilityRadius) % 360;

      colors.add(_generateRandomColor(
        colorSpace,
        minHue,
        maxHue,
        minSaturation,
        maxSaturation,
        minBrightness,
        maxBrightness,
        perceivedBrightness,
      ));
    }

    return ColorPalette(colors);
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
  ///
  /// If [perceivedBrightness] is `true`, colors will be generated in the
  /// HSP color space. If `false`, colors will be generated in the HSB
  /// color space.
  factory ColorPalette.splitComplimentary(
    ColorModel color, {
    int numberOfColors = 3,
    num distance = 30,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
    bool perceivedBrightness = true,
    bool unique = false,
  }) {
    assert(color != null);
    assert(numberOfColors != null && numberOfColors > 0);
    assert(
        hueVariability != null && hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability != null &&
        saturationVariability >= 0 &&
        saturationVariability <= 100);
    assert(brightnessVariability != null &&
        brightnessVariability >= 0 &&
        brightnessVariability <= 100);
    assert(perceivedBrightness != null);
    assert(unique != null);

    final colors = unique
        ? UniqueList<ColorModel>.of([color], strict: true)
        : <ColorModel>[color];

    final oppositeColor = color.opposite;

    if (numberOfColors.isEven) {
      colors.add(oppositeColor);
      numberOfColors -= 1;
    }

    for (var i = 1; i < numberOfColors; i++) {
      colors.add(_generateColor(
        oppositeColor,
        (i % 2 == 0 ? distance * -1 : distance) * ((i / 2).ceil()),
        hueVariability,
        saturationVariability,
        brightnessVariability,
        perceivedBrightness,
      ));
    }

    return ColorPalette(colors);
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
    bool unique = false,
  }) {
    assert(colorPalette != null);
    assert(insertOpposites != null);
    assert(unique != null);

    final colors = unique ? UniqueList<ColorModel>.strict() : <ColorModel>[];

    if (!insertOpposites) colors.addAll(colorPalette.colors);

    for (var color in colorPalette.colors) {
      if (insertOpposites) colors.add(color);
      colors.add(color.opposite);
    }

    return ColorPalette(colors);
  }

  /// Generates a new color in the color space defined by [colorModel].
  static ColorModel _generateColor(
    ColorModel color,
    num distance,
    num hueVariability,
    num saturationVariability,
    num brightnessVariability,
    bool perceivedBrightness,
  ) {
    assert(distance != null);
    assert(
        hueVariability != null && hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability != null &&
        saturationVariability >= 0 &&
        saturationVariability <= 100);
    assert(brightnessVariability != null &&
        brightnessVariability >= 0 &&
        brightnessVariability <= 100);
    assert(perceivedBrightness != null);

    final colorValues = perceivedBrightness
        ? color.toHspColor().toListWithAlpha()
        : color.toHsbColor().toListWithAlpha();

    colorValues[0] += distance;

    if (hueVariability > 0) {
      colorValues[0] += _calculateVariability(hueVariability);
    }

    colorValues[0] %= 360;

    if (saturationVariability > 0) {
      colorValues[1] =
          (colorValues[1] + _calculateVariability(saturationVariability))
              .clamp(0, 100);
    }

    if (brightnessVariability > 0) {
      colorValues[2] =
          (colorValues[2] + _calculateVariability(brightnessVariability))
              .clamp(0, 100);
    }

    return _castToType(
        color,
        perceivedBrightness
            ? HspColor.fromList(colorValues)
            : HsbColor.fromList(colorValues));
  }

  /// Generates a random color in the color space defined by [colorSpace].
  static ColorModel _generateRandomColor(
    ColorSpace colorSpace,
    num minHue,
    num maxHue,
    num minSaturation,
    num maxSaturation,
    num minBrightness,
    num maxBrightness,
    bool perceivedBrightness,
  ) {
    assert(colorSpace != null);
    assert(minHue != null && minHue >= 0 && minHue <= 360);
    assert(maxHue != null && maxHue >= 0 && maxHue <= 360);
    assert(minSaturation != null &&
        minSaturation >= 0 &&
        minSaturation <= maxSaturation);
    assert(maxSaturation != null &&
        maxSaturation >= minSaturation &&
        maxSaturation <= 100);
    assert(minBrightness != null &&
        minBrightness >= 0 &&
        minBrightness <= maxBrightness);
    assert(maxBrightness != null &&
        maxBrightness >= minBrightness &&
        maxBrightness <= 100);
    assert(perceivedBrightness != null);

    final randomColor = perceivedBrightness
        ? HspColor.random(
            minHue: minHue,
            maxHue: maxHue,
            minSaturation: minSaturation,
            maxSaturation: maxSaturation,
            minPerceivedBrightness: minBrightness,
            maxPerceivedBrightness: maxBrightness,
          )
        : HsbColor.random(
            minHue: minHue,
            maxHue: maxHue,
            minSaturation: minSaturation,
            maxSaturation: maxSaturation,
            minBrightness: minBrightness,
            maxBrightness: maxBrightness,
          );

    ColorModel color;

    switch (colorSpace) {
      case ColorSpace.cmyk:
        color = randomColor.toCmykColor();
        break;
      case ColorSpace.hsi:
        color = randomColor.toHsiColor();
        break;
      case ColorSpace.hsl:
        color = randomColor.toHslColor();
        break;
      case ColorSpace.hsp:
        color = randomColor.toHspColor();
        break;
      case ColorSpace.hsb:
        color = randomColor.toHsbColor();
        break;
      case ColorSpace.lab:
        color = randomColor.toLabColor();
        break;
      case ColorSpace.rgb:
        color = randomColor.toRgbColor();
        break;
      case ColorSpace.xyz:
        color = randomColor.toXyzColor();
        break;
    }

    return color;
  }

  /// Calculates a range from `0` with a radius of `value / 2`.
  static double _calculateVariability(num value) {
    assert(value != null && value > 0);

    return (Random().nextDouble() * value) - (value / 2);
  }

  /// Casts [color] to the color space defined by [colorModel].
  static ColorModel _castToType(ColorModel type, ColorModel color) {
    assert(type != null);
    assert(color != null);

    if (type is CmykColor) {
      color = color.toCmykColor();
    } else if (type is HsiColor) {
      color = color.toHsiColor();
    } else if (type is HslColor) {
      color = color.toHslColor();
    } else if (type is HspColor) {
      color = color.toHspColor();
    } else if (type is HsbColor) {
      color = color.toHsbColor();
    } else if (type is LabColor) {
      color = color.toLabColor();
    } else if (type is RgbColor) {
      color = color.toRgbColor();
    } else if (type is XyzColor) {
      color = color.toXyzColor();
    }

    return color;
  }

  /// The number of [colors] in the palette.
  int get length => colors.length;

  /// Returns the color at the position of [index].
  ColorModel operator [](int index) => colors[index];

  /// Sets the color at the position of [index] to [value].
  void operator []=(int index, ColorModel value) => colors[index] = value;

  /// Returns the concatenation of this palette's colors and [other]s'.
  ///
  /// [other] may be a [ColorPalette] or a [List<ColorModel>].
  ColorPalette operator +(dynamic other) {
    assert(other is ColorPalette || other is List<ColorModel>);

    List<ColorModel> colors;

    if (other is ColorPalette) {
      colors = other.colors;
    } else if (other is List<ColorModel>) {
      colors = other;
    }

    return ColorPalette(this.colors + colors);
  }

  @override
  String toString() => colors.toString();
}
