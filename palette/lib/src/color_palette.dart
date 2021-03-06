import 'dart:math';
import 'package:color_models/color_models.dart';
import 'package:num_utilities/num_utilities.dart';
import 'package:unique_list/unique_list.dart';

/// The base class for [ColorPalette]s.
abstract class ColorPaletteBase<I, O extends ColorModel> implements List<I> {
  const ColorPaletteBase(this.colors);

  /// The colors contained in the palette.
  final List<O> colors;

  /// Returns the color with the highest perceived brightness value.
  O get brightest => colors.reduce((color1, color2) {
        return color1.toHspColor().perceivedBrightness <
                color2.toHspColor().perceivedBrightness
            ? color2
            : color1;
      });

  /// Returns the color with the lowest perceived brightness value.
  O get dimmest => colors.reduce((color1, color2) {
        return color1.toHspColor().perceivedBrightness <
                color2.toHspColor().perceivedBrightness
            ? color1
            : color2;
      });

  /// Returns the color with the highest lightness value.
  O get lightest => colors.reduce((color1, color2) {
        return color1.toHslColor().lightness < color2.toHslColor().lightness
            ? color2
            : color1;
      });

  /// Returns the color with the lowest lightness value.
  O get darkest => colors.reduce((color1, color2) {
        return color1.toHslColor().lightness < color2.toHslColor().lightness
            ? color1
            : color2;
      });

  /// Returns the color with the highest intensity value.
  O get mostIntense => colors.reduce((color1, color2) {
        return color1.toHsiColor().intensity < color2.toHsiColor().intensity
            ? color2
            : color1;
      });

  /// Returns the color with the lowest intensity value.
  O get leastIntense => colors.reduce((color1, color2) {
        return color1.toHsiColor().intensity < color2.toHsiColor().intensity
            ? color1
            : color2;
      });

  /// Returns the color with the highest saturation value.
  O get deepest => colors.reduce((color1, color2) =>
      color1.saturation < color2.saturation ? color2 : color1);

  /// Returns the color with the lowest saturation value.
  O get dullest => colors.reduce((color1, color2) =>
      color1.saturation < color2.saturation ? color1 : color2);

  /// Returns the color with the highest combined saturation
  /// and brightness values.
  O get richest => colors.reduce((color1, color2) {
        final hsb1 = color1.toHsbColor();
        final hsb2 = color2.toHsbColor();

        final value1 = hsb1.saturation + hsb1.brightness;
        final value2 = hsb2.saturation + hsb2.brightness;

        return value1 < value2 ? color2 : color1;
      });

  /// Returns the color with the lowest combined saturation
  /// and brightness values.
  O get muted => colors.reduce((color1, color2) {
        final hsb1 = color1.toHsbColor();
        final hsb2 = color2.toHsbColor();

        final value1 = hsb1.saturation + hsb1.brightness;
        final value2 = hsb2.saturation + hsb2.brightness;

        return value1 < value2 ? color1 : color2;
      });

  /// Returns the color with the reddest hue. (0°)
  O get red =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 0));

  /// Returns the color with the most red-orange hue. (30°)
  O get redOrange =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 30));

  /// Returns the color with the orangest hue. (60°)
  O get orange =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 60));

  /// Returns the color with the most yellow-orange hue. (90°)
  O get yellowOrange =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 90));

  /// Returns the color with the yellowest hue. (120°)
  O get yellow =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 120));

  /// Returns the color with the most yellow-green hue. (150°)
  O get yellowGreen =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 150));

  /// Returns the color with the greenest hue. (180°)
  O get green =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 180));

  /// Returns the color with the most cyan hue. (210°)
  O get cyan =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 210));

  /// Returns the color with the most bluest hue. (240°)
  O get blue =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 240));

  /// Returns the color with the most blue-violet hue. (270°)
  O get blueViolet =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 270));

  /// Returns the color with the most violet hue. (300°)
  O get violet =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 300));

  /// Returns the color with the most magenta hue. (330°)
  O get magenta =>
      colors.reduce((color1, color2) => _compareDistance(color1, color2, 330));

  /// Returns the color with the values closest to [color].
  ///
  /// The difference in values is determined by calculating the difference
  /// between each colors' respective hue, saturation, and perceived brightness
  /// values, giving the difference in hue twice the weight of the difference
  /// in the saturation and perceived brightness values.
  I closest(I color) => colors.closest(color as O) as I;

  /// Returns the color with the values furthest from [color].
  ///
  /// The difference in values is determined by calculating the difference
  /// between each colors' respective hue, saturation, and perceived brightness
  /// values, giving the difference in hue twice the weight of the difference
  /// in the saturation and perceived brightness values.
  I furthest(I color) => colors.furthest(color as O) as I;

  /// Inverts the values of every color in the palette in their respective
  /// color spaces.
  void invert() {
    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].inverted as O;
    }
  }

  /// Rotates the hue of every color in the palette by `180` degrees.
  ///
  /// __Note:__ Use the [ColorPalette.opposites] constructor to generate
  /// a new palette that includes the colors in this palette and their
  /// respective opposites.
  void opposite() {
    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].opposite as O;
    }
  }

  /// Rotates the hue of every color in the palette by [amount].
  void rotateHue(num amount) {
    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].rotateHue(amount) as O;
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
    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].warmer(amount, relative: relative) as O;
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
    for (var i = 0; i < length; i++) {
      colors[i] = colors[i].cooler(amount, relative: relative) as O;
    }
  }

  @override
  Iterator<I> get iterator => colors.iterator as Iterator<I>;

  @override
  List<R> cast<R>() => colors.cast<R>();

  @override
  Iterable<T> map<T>(T Function(I) f) => colors.map<T>(f as T Function(O));

  @override
  Iterable<I> where(bool Function(I) test) =>
      colors.where(test as bool Function(O)) as Iterable<I>;

  @override
  Iterable<T> whereType<T>() => colors.whereType<T>();

  @override
  Iterable<T> expand<T>(Iterable<T> Function(I) f) =>
      colors.expand<T>(f as Iterable<T> Function(O));

  @override
  void forEach(void Function(I) f) => colors.forEach(f as void Function(O));

  @override
  I reduce(I Function(I, I) combine) =>
      colors.reduce(combine as O Function(O, O)) as I;

  @override
  T fold<T>(T initialValue, T Function(T, I) combine) =>
      colors.fold(initialValue, combine as T Function(T, O));

  @override
  bool every(bool Function(I) test) => colors.every(test as bool Function(O));

  @override
  String join([String separator = '']) => colors.join(separator);

  @override
  bool any(bool Function(I) test) => colors.any(test as bool Function(O));

  @override
  List<I> toList({bool growable = true}) =>
      colors.toList(growable: growable) as List<I>;

  @override
  Set<I> toSet() => colors.toSet() as Set<I>;

  @override
  I operator [](int index) {
    assert(index >= 0 && index < length);
    return colors[index] as I;
  }

  /// The number of [colors] in the palette.
  @override
  int get length => colors.length;

  @override
  set length(int newLength) {
    colors.length = newLength;
  }

  @override
  bool get isEmpty => colors.isEmpty;

  @override
  bool get isNotEmpty => colors.isNotEmpty;

  @override
  Iterable<I> take(int count) {
    assert(count >= 0);
    return colors.take(count) as Iterable<I>;
  }

  @override
  Iterable<I> takeWhile(bool Function(I) test) =>
      colors.takeWhile(test as bool Function(O)) as Iterable<I>;

  @override
  Iterable<I> skip(int count) {
    assert(count >= 0);
    return colors.skip(count) as Iterable<I>;
  }

  @override
  Iterable<I> skipWhile(bool Function(I) test) =>
      colors.skipWhile(test as bool Function(O)) as Iterable<I>;

  @override
  I get first => colors.first as I;

  @override
  I get last => colors.last as I;

  @override
  I get single => colors.single as I;

  @override
  I firstWhere(bool Function(I) test, {I Function()? orElse}) {
    late I value;
    try {
      value = colors.firstWhere(test as bool Function(O)) as I;
    } on StateError {
      if (orElse != null) {
        value = orElse();
      } else {
        rethrow;
      }
    }
    return value;
  }

  @override
  I lastWhere(bool Function(I) test, {I Function()? orElse}) {
    late I value;
    try {
      value = colors.lastWhere(test as bool Function(O)) as I;
    } on StateError {
      if (orElse != null) {
        value = orElse();
      } else {
        rethrow;
      }
    }
    return value;
  }

  @override
  I singleWhere(bool Function(I) test, {I Function()? orElse}) {
    late I value;
    try {
      value = colors.singleWhere(test as bool Function(O)) as I;
    } on StateError {
      if (orElse != null) {
        value = orElse();
      } else {
        rethrow;
      }
    }
    return value;
  }

  @override
  I elementAt(int index) {
    assert(index >= 0 && index < length);
    return colors.elementAt(index) as I;
  }

  @override
  Iterable<I> get reversed => colors.reversed as Iterable<I>;

  @override
  void sort([int Function(I, I)? compare]) => (colors as List<I>).sort(compare);

  @override
  void shuffle([Random? random]) => colors.shuffle(random);

  @override
  int indexWhere(bool Function(I) test, [int start = 0]) {
    assert(start >= 0 && start < length);
    return colors.indexWhere(test as bool Function(O), start);
  }

  @override
  int lastIndexWhere(bool Function(I) test, [int? start]) {
    assert(start == null || (start >= 0 && start < length));
    return colors.lastIndexWhere(test as bool Function(O), start);
  }

  @override
  int lastIndexOf(I color, [int? start]) {
    assert(start == null || (start >= 0 && start < length));
    return colors.lastIndexOf(color as O, start);
  }

  @override
  void clear() => colors.clear();

  @override
  bool remove(Object? color) => colors.remove(color);

  @override
  I removeAt(int index) {
    assert(index >= 0 && index < length);
    return colors.removeAt(index) as I;
  }

  @override
  I removeLast() => colors.removeLast() as I;

  @override
  void removeWhere(bool Function(I) test) =>
      colors.removeWhere(test as bool Function(O));

  @override
  void retainWhere(bool Function(I) test) =>
      colors.retainWhere(test as bool Function(O));

  @override
  List<I> sublist(int start, [int? end]) {
    assert(start >= 0 && start < (end ?? length));
    assert(end == null || (end >= start && end <= length));
    return colors.sublist(start, end) as List<I>;
  }

  @override
  Iterable<I> getRange(int start, int end) {
    assert(start >= 0 && start <= end);
    assert(end >= start && end <= length);
    return colors.getRange(start, end) as Iterable<I>;
  }

  @override
  void removeRange(int start, int end) {
    assert(start >= 0 && start <= end);
    assert(end >= start && end <= length);
    return colors.removeRange(start, end);
  }

  /// Reverses the order of the colors in the palette.
  void reverse() => colors.replaceRange(0, length, colors.reversed);

  /// Sorts the palette by [property].
  ///
  /// [property] must not be `null`.
  void sortBy(ColorSortingProperty property) {
    if (colors.length <= 1) return;

    if (property == ColorSortingProperty.similarity ||
        property == ColorSortingProperty.difference) {
      _sortByDifference(property);
      return;
    }

    colors.sort((a, b) {
      late num value1;
      late num value2;
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
          value1 = a.hue.calculateDistance(0);
          value2 = b.hue.calculateDistance(0);
          break;
        case ColorSortingProperty.redOrange:
          value1 = a.hue.calculateDistance(30);
          value2 = b.hue.calculateDistance(30);
          break;
        case ColorSortingProperty.orange:
          value1 = a.hue.calculateDistance(60);
          value2 = b.hue.calculateDistance(60);
          break;
        case ColorSortingProperty.yellowOrange:
          value1 = a.hue.calculateDistance(90);
          value2 = b.hue.calculateDistance(90);
          break;
        case ColorSortingProperty.yellow:
          value1 = a.hue.calculateDistance(120);
          value2 = b.hue.calculateDistance(120);
          break;
        case ColorSortingProperty.yellowGreen:
          value1 = a.hue.calculateDistance(150);
          value2 = b.hue.calculateDistance(150);
          break;
        case ColorSortingProperty.green:
          value1 = a.hue.calculateDistance(180);
          value2 = b.hue.calculateDistance(180);
          break;
        case ColorSortingProperty.cyan:
          value1 = a.hue.calculateDistance(210);
          value2 = b.hue.calculateDistance(210);
          break;
        case ColorSortingProperty.blue:
          value1 = a.hue.calculateDistance(240);
          value2 = b.hue.calculateDistance(240);
          break;
        case ColorSortingProperty.blueViolet:
          value1 = a.hue.calculateDistance(270);
          value2 = b.hue.calculateDistance(270);
          break;
        case ColorSortingProperty.violet:
          value1 = a.hue.calculateDistance(300);
          value2 = b.hue.calculateDistance(300);
          break;
        case ColorSortingProperty.magenta:
          value1 = a.hue.calculateDistance(330);
          value2 = b.hue.calculateDistance(330);
          break;
        default:
          break;
      }

      return inverse ? value2.compareTo(value1) : value1.compareTo(value2);
    });
  }

  /// Compares the distance between [hue] and [color1]/[color2].
  /// The color closest to [hue] will be returned.
  static O _compareDistance<O extends ColorModel>(
    O color1,
    O color2,
    num hue,
  ) {
    assert(hue >= 0 && hue <= 360);
    final distance1 = color1.hue.calculateDistance(hue);
    final distance2 = color2.hue.calculateDistance(hue);
    return distance1 <= distance2 ? color1 : color2;
  }

  /// Converts all [colors] into the [ColorModel] represented by [colorSpace].
  void toColorSpace(ColorSpace colorSpace) {
    for (var i = 0; i < colors.length; i++) {
      switch (colorSpace) {
        case ColorSpace.cmyk:
          colors[i] = colors[i].toCmykColor() as O;
          break;
        case ColorSpace.hsi:
          colors[i] = colors[i].toHsiColor() as O;
          break;
        case ColorSpace.hsl:
          colors[i] = colors[i].toHslColor() as O;
          break;
        case ColorSpace.hsp:
          colors[i] = colors[i].toHspColor() as O;
          break;
        case ColorSpace.hsb:
          colors[i] = colors[i].toHsbColor() as O;
          break;
        case ColorSpace.lab:
          colors[i] = colors[i].toLabColor() as O;
          break;
        case ColorSpace.oklab:
          colors[i] = colors[i].toOklabColor() as O;
          break;
        case ColorSpace.rgb:
          colors[i] = colors[i].toRgbColor() as O;
          break;
        case ColorSpace.xyz:
          colors[i] = colors[i].toXyzColor() as O;
          break;
      }
    }
  }

  /// Sorts the colors in the palette by their similarity to one another.
  void _sortByDifference(ColorSortingProperty order) {
    assert(order == ColorSortingProperty.similarity ||
        order == ColorSortingProperty.difference);

    // Compare every color to every other color and calculate the difference
    // between them.
    final differences = <int, List<double?>>{};

    for (var i = 0; i < length; i++) {
      differences.addAll({
        i: List<double?>.generate(
          length,
          (index) =>
              i == index ? null : colors[i].calculateDifference(colors[index]),
        ),
      });
    }

    // Determine the starting color by finding the color that's both the
    // most and least different to the other colors in the palette.
    var startingColor = 0;
    var lowestDifference = differences[0]!.lowest;
    var highestDifference = differences[0]!.highest;

    for (var i = 1; i < length; i++) {
      final leastDifferent = differences[i]!.lowest;
      final mostDifferent = differences[i]!.highest;

      if ((order == ColorSortingProperty.similarity &&
              (leastDifferent! < lowestDifference! ||
                  (leastDifferent == lowestDifference &&
                      mostDifferent! > highestDifference!))) ||
          (order == ColorSortingProperty.difference &&
              (mostDifferent! > highestDifference! ||
                  (mostDifferent == highestDifference &&
                      leastDifferent! < lowestDifference!)))) {
        startingColor = i;
        lowestDifference = leastDifferent;
        highestDifference = mostDifferent;
      }
    }

    // Sort the colors in the order of their similiarity
    final newPalette = <O>[colors[startingColor]];
    final oldPalette = List<O>.from(colors)..removeAt(startingColor);

    while (oldPalette.isNotEmpty) {
      final color = order == ColorSortingProperty.similarity
          ? oldPalette.closest(newPalette.last) as O
          : oldPalette.furthest(newPalette.last) as O;

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
    assert(startingFrom >= 0 && startingFrom <= 360);

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

  @override
  Map<int, I> asMap() => colors.asMap() as Map<int, I>;

  @override
  String toString() => colors.toString();
}

/// {@template palette.ColorPalette}
///
/// Wraps a list of [ColorModel]s with additional getters and methods;
/// with constructors for generating new color palettes, as well as methods
/// and operators for modifying and extracting colors from the palette.
///
/// {@endtemplate}
class ColorPalette extends ColorPaletteBase<ColorModel, ColorModel> {
  /// {@macro palette.ColorPalette}
  const ColorPalette(List<ColorModel> colors) : super(colors);

  /// Returns a [ColorPalette] with an empty list of [colors].
  factory ColorPalette.empty({bool unique = false}) {
    return ColorPalette(unique ? UniqueList<ColorModel>() : <ColorModel>[]);
  }

  /// Generates a [ColorPalette] by selecting colors with hues
  /// to both sides of [seed]'s hue value.
  ///
  /// If [numberOfColors] is odd, [seed] will be included in the palette.
  /// If even, [seed] will be excluded from the palette. [numberOfColors]
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
  ///
  /// If [growable] is `false`, the palette will be constructed with a
  /// fixed-length list, [numberOfColors] in length. If `true`, a growable
  /// palette will be constructed instead.
  ///
  /// If [unique] is `false`, the palette will be constructed with a [List].
  /// If `true`, a [uniqueList] will be used instead, requiring all colors
  /// in the palette be unique.
  factory ColorPalette.adjacent(
    ColorModel seed, {
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

    final palette = <ColorModel>[];

    var colorsRemaining = numberOfColors;
    if (numberOfColors.isOdd) {
      palette.add(seed);
      colorsRemaining -= 1;
    }

    for (var i = 1; i <= colorsRemaining; i++) {
      final color = _generateColor(
        seed,
        (i % 2 == 0 ? distance * -1 : distance) * ((i / 2).ceil()),
        hueVariability,
        saturationVariability,
        brightnessVariability,
        perceivedBrightness,
      );

      palette.add(color);
    }

    return ColorPalette(unique
        ? UniqueList<ColorModel>.from(palette, growable: growable)
        : List<ColorModel>.from(palette, growable: growable));
  }

  /// Generates a [ColorPalette] by selecting colors with hues
  /// evenly spaced around the color wheel from [seed].
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
  ///
  /// If [growable] is `false`, a fixed-length the palette will be constructed
  /// with a fixed-length list. If `true`, a growable list will be used instead.
  ///
  /// If [unique] is `false`, the palette will be constructed with a [List].
  /// If `true`, a [uniqueList] will be used instead.
  factory ColorPalette.polyad(
    ColorModel seed, {
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

    final palette = <ColorModel>[seed];

    var distance = 360 / numberOfColors;
    if (!clockwise) distance *= -1;

    for (var i = 1; i < numberOfColors; i++) {
      final color = _generateColor(
        seed,
        distance * i,
        hueVariability,
        saturationVariability,
        brightnessVariability,
        perceivedBrightness,
      );

      palette.add(color);
    }

    return ColorPalette(unique
        ? UniqueList<ColorModel>.from(palette, growable: growable)
        : List<ColorModel>.from(palette, growable: growable));
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
  ///
  /// If [growable] is `false`, a fixed-length the palette will be constructed
  /// with a fixed-length list. If `true`, a growable list will be used instead.
  ///
  /// If [unique] is `false`, the palette will be constructed with a [List].
  /// If `true`, a [uniqueList] will be used instead.
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
          case ColorSpace.oklab:
            color = OklabColor.random();
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

      return ColorPalette(unique
          ? UniqueList<ColorModel>.generate(numberOfColors, generator,
              growable: growable, strict: true)
          : List<ColorModel>.generate(numberOfColors, generator,
              growable: growable));
    }

    var distance = (minHue - maxHue) / numberOfColors;
    if (!clockwise) distance *= -1;

    distributionVariability ??= distance.abs() / 4;
    final variabilityRadius = distributionVariability / 2;

    final seed = _generateRandomColor(
      colorSpace,
      minHue,
      maxHue,
      minSaturation,
      maxSaturation,
      minBrightness,
      maxBrightness,
      perceivedBrightness,
    );

    final palette = <ColorModel>[seed];

    var hue = palette.first.hue;

    for (var i = 1; i < numberOfColors; i++) {
      hue += distance;
      minHue = (hue - variabilityRadius) % 360;
      maxHue = (hue + variabilityRadius) % 360;

      final color = _generateRandomColor(
        colorSpace,
        minHue,
        maxHue,
        minSaturation,
        maxSaturation,
        minBrightness,
        maxBrightness,
        perceivedBrightness,
      );

      palette.add(color);
    }

    return ColorPalette(unique
        ? UniqueList<ColorModel>.from(palette, growable: growable)
        : List<ColorModel>.from(palette, growable: growable));
  }

  /// Generates a [ColorPalette] by selecting colors to both sides
  /// of the color with the opposite [hue] of [seed].
  ///
  /// If [numberOfColors] is even, the coolor opposite of [seed] will
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
  ///
  /// If [growable] is `false`, a fixed-length the palette will be constructed
  /// with a fixed-length list. If `true`, a growable list will be used instead.
  ///
  /// If [unique] is `false`, the palette will be constructed with a [List].
  /// If `true`, a [uniqueList] will be used instead.
  factory ColorPalette.splitComplimentary(
    ColorModel seed, {
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

    final palette = <ColorModel>[seed];

    final oppositeColor = seed.opposite;
    var colorsRemaining = numberOfColors;

    if (numberOfColors.isEven) {
      palette.add(oppositeColor);
      colorsRemaining -= 1;
    }

    for (var i = 1; i < colorsRemaining; i++) {
      final color = _generateColor(
        oppositeColor,
        (i % 2 == 0 ? distance * -1 : distance) * ((i / 2).ceil()),
        hueVariability,
        saturationVariability,
        brightnessVariability,
        perceivedBrightness,
      );

      palette.add(color);
    }

    return ColorPalette(unique
        ? UniqueList<ColorModel>.from(palette, growable: growable)
        : List<ColorModel>.from(palette, growable: growable));
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
  ///
  /// If [growable] is `false`, a fixed-length the palette will be constructed
  /// with a fixed-length list. If `true`, a growable list will be used instead.
  ///
  /// If [unique] is `false`, the palette will be constructed with a [List].
  /// If `true`, a [uniqueList] will be used instead.
  factory ColorPalette.opposites(
    ColorPaletteBase colorPalette, {
    bool insertOpposites = true,
    bool growable = true,
    bool unique = false,
  }) {
    final palette = <ColorModel>[];
    if (!insertOpposites) palette.addAll(colorPalette.colors);

    for (var i = 0; i < colorPalette.length; i++) {
      final color = colorPalette[i];
      if (insertOpposites) palette.add(color);
      palette.add(color.opposite);
    }

    return ColorPalette(unique
        ? UniqueList<ColorModel>.from(palette, growable: growable)
        : List<ColorModel>.from(palette, growable: growable));
  }

  /// Generates a new color in the color space defined by [colorModel].
  static ColorModel _generateColor(
    ColorModel seed,
    num distance,
    num hueVariability,
    num saturationVariability,
    num brightnessVariability,
    bool perceivedBrightness,
  ) {
    assert(hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability >= 0 && saturationVariability <= 100);
    assert(brightnessVariability >= 0 && brightnessVariability <= 100);

    final colorValues = perceivedBrightness
        ? seed.toHspColor().toListWithAlpha()
        : seed.toHsbColor().toListWithAlpha();

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

    return (perceivedBrightness
            ? HspColor.fromList(colorValues)
            : HsbColor.fromList(colorValues))
        .castTo(seed);
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
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minBrightness >= 0 && minBrightness <= maxBrightness);
    assert(maxBrightness >= minBrightness && maxBrightness <= 100);

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

    return colorSpace.from(randomColor);
  }

  /// Calculates a range from `0` with a radius of `value / 2`.
  static double _calculateVariability(num value) {
    assert(value > 0);
    return (Random().nextDouble() * value) - (value / 2);
  }

  @override
  bool contains(Object? color) => colors.contains(color);

  @override
  Iterable<ColorModel> followedBy(Iterable<ColorModel> other) =>
      colors.followedBy(other);

  @override
  int indexOf(ColorModel color, [int start = 0]) {
    assert(start >= 0 && start < length);
    return colors.indexOf(color, start);
  }

  @override
  void operator []=(int index, ColorModel color) {
    colors[index] = color;
  }

  @override
  set first(ColorModel color) {
    colors.first = color;
  }

  @override
  set last(ColorModel color) {
    colors.last = color;
  }

  @override
  void add(ColorModel color) {
    colors.add(color);
  }

  @override
  void addAll(Iterable<ColorModel> colors) {
    this.colors.addAll(colors);
  }

  @override
  void insert(int index, ColorModel color) {
    assert(index >= 0 && index < length);
    colors.insert(index, color);
  }

  @override
  void insertAll(int index, Iterable<ColorModel> colors) {
    assert(index >= 0 && index < length);
    this.colors.setAll(index, colors);
  }

  @override
  void setAll(int index, Iterable<ColorModel> colors) {
    assert(index >= 0 && index < length);
    this.colors.setAll(index, colors);
  }

  @override
  void setRange(int start, int end, Iterable<ColorModel> colors,
      [int skipCount = 0]) {
    assert(start >= 0 && start <= end);
    assert(end >= start && end < length);
    assert(skipCount >= 0);
    assert(end - start + skipCount <= length);
    this.colors.setRange(start, end, colors, skipCount);
  }

  @override
  void fillRange(int start, int end, [ColorModel? fillColor]) {
    assert(start >= 0 && start <= end);
    assert(end >= start && end < length);
    colors.fillRange(start, end, fillColor);
  }

  @override
  void replaceRange(int start, int end, Iterable<ColorModel> replacement) {
    assert(start >= 0 && start <= end);
    assert(end >= start && end < length);
    colors.replaceRange(start, end, replacement);
  }

  @override
  ColorPalette operator +(Iterable<ColorModel> other) =>
      ColorPalette(colors + other.toList());

  @override
  String toString() => colors.toString();
}

extension _CalculateDifference on ColorModel {
  /// Calculates the difference between [color1] and [color2] by calculating
  /// the difference between each colors' respective hue, saturation, and
  /// perceived brightness values, giving the difference in hue twice the
  /// weight of the difference in saturation and perceived brightness values.
  double calculateDifference(ColorModel other) {
    final color1 = toHspColor();
    final color2 = other.toHspColor();

    final hue = color1.hue.calculateDistance(color2.hue);
    final saturation = (color1.saturation - color2.saturation).abs();
    final brightness =
        (color1.perceivedBrightness - color2.perceivedBrightness).abs();

    return hue + ((saturation + brightness) / 2);
  }
}

extension _ClosestFurthestColor on List<ColorModel> {
  /// Returns the color in the list closest to [color].
  ColorModel closest(ColorModel color) {
    late ColorModel closestColor;
    double? lowestDifference;

    for (var paletteColor in this) {
      final difference = color.calculateDifference(paletteColor);

      if (lowestDifference == null || lowestDifference < difference) {
        lowestDifference = difference;
        closestColor = paletteColor;
      }
    }

    return closestColor;
  }

  /// Returns the color in the lsit furthest from [color].
  ColorModel furthest(ColorModel color) {
    late ColorModel furthestColor;
    num? highestDifference;

    for (var paletteColor in this) {
      final difference = color.calculateDifference(paletteColor);

      if (highestDifference == null || highestDifference > difference) {
        highestDifference = difference;
        furthestColor = paletteColor;
      }
    }

    return furthestColor;
  }
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

extension _CalculateDistance on num {
  /// Calculates the distance between [hue1] and [hue2].
  num calculateDistance(num other) {
    assert(this >= 0 && this <= 360);
    assert(other >= 0 && other <= 360);
    final distance1 = this > other ? this - other : other - this;
    final distance2 =
        this > other ? (other + 360) - this : (this + 360) - other;
    return distance1 < distance2 ? distance1 : distance2;
  }
}
