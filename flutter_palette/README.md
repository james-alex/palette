# flutter_palette

[![pub package](https://img.shields.io/pub/v/flutter_palette.svg)](https://pub.dartlang.org/packages/flutter_palette)

A package for creating, generating, and interfacing with color palettes.

`flutter_palette` wraps the [palette](https://pub.dev/packages/palette) package
and adds support for Flutter's [Color] object.

`flutter_palette` is built on top of the [flutter_color_models](https://pub.dartlang.org/packages/color_models)
package, which exposes models for the CMYK, HSI, HSL, HSP, HSB, Oklab, LAB, RGB,
and XYZ color spaces.

__For use without Flutter, see:__ https://pub.dev/packages/palette

# Usage

```dart
import 'package:flutter_palette/flutter_palette.dart`;
```

## Creating Palettes

A [ColorPalette] can be created directly by constructing it with a list of
[ColorModel]s, or can be generated with one of its factory constructors.

[ColorPalette] has 7 factory constructors: [from], [empty], [adjacent], [polyad],
[random], [splitComplimentary], and [opposites].

```dart
// Create a color palette with a set of pre-defined colors.
ColorPalette(<ColorModel>[
  RgbColor(0, 0, 0), // Black
  RgbColor(144, 144, 144), // Grey
  RgbColor(255, 255, 255), // White
  RgbColor(255, 0, 0), // Red
  RgbColor(0, 255, 0), // Green
  RgbColor(0, 0, 255), // Blue
  RgbColor(255, 255, 0), // Yellow
  RgbColor(0, 255, 255), // Cyan
  RgbColor(255, 0, 255), // Magenta
]);

/// Create a color palette from a list of [Color]s.
ColorPalette.from(<Color>[
  Color(0xFF000000), // Black
  Color(0xFF909090), // Grey
  Color(0xFFFFFFFF), // White
  Color(0xFFFF0000), // Red
  Color(0xFF00FF00), // Green
  Color(0xFF0000FF), // Blue
  Color(0xFFFFFF00), // Yellow
  Color(0xFF00FFFF), // Cyan
  Color(0xFFFF00FF), // Magenta
]);

/// Create an empty color palette.
ColorPalette.empty();

/// Generate a color palette with 3 colors by selecting
/// the colors 60° to either side of the base color.
ColorPalette.adjacent(
  Color(0xFFFF0000),
  numberOfColors: 3,
  distance: 60,
);

/// Generate a color palette with 5 colors by evenly spacing the colors around the
/// color wheel from the base color, with a variation of 15° in the generated hues,
/// and a variation of 10% in the generated saturation and brightness values from the
/// base color's values.
ColorPalette.polyad(
  Color(0xFF00FFFF),
  numberOfColors: 5,
  hueVariability: 15,
  saturationVariability: 10,
  brightnessVariability: 10,
);

/// Generate a color palette with 8 colors at random.
///
/// By default, [distributeHues] is set to `true`, which will distribute the
/// hues of the generated colors around the color wheel.
///
/// The [distributionVariability] parameter defaults to:
/// `(minHue - maxHue).abs() / numberOfColors / 4`, set it to `0` to space the
/// colors around the wheel completely evenly.
ColorPalette.random(8, distributionVariability: 0);

/// Generate a color palette with 8 colors with completely random values.
ColorePalette.random(8, distributeHues: false);

/// Generate a color palette with 5 colors by selecting colors distributed
/// to either side of the color opposite of the base color. The distance
/// between the selected colors' hues defaults to 30°. Variability to the
/// hue, saturation, and brightness values can also be added with their
/// respective parameters.
ColorPalette.splitComplimentary(
  Color(0xFF0000FF),
  numberOfColors: 5,
  hueVariability: 15,
  saturationVariability: 10,
  brightnessVariability: 10,
);

/// Generates a color palette containing all of the colors contained
/// in [colorPalette], as well as their opposite colors.
ColorPalette.opposites(colorPalette);
```

## Colors

The color palette can be viewed as a [List&lt;ColorModel&gt;] by referencing the
[colors] getter, or as a [List&lt;Color&gt;] with the [toColors] method.

```dart
/// Construct a [ColorPalette] from a list of [RgbColor]s.
final colorPalette = ColorPalette(<ColorModel>[
  RgbColor(0, 0, 0), // Black
  RgbColor(144, 144, 144), // Grey
  RgbColor(255, 255, 255), // White
  RgbColor(255, 0, 0), // Red
  RgbColor(0, 255, 0), // Green
  RgbColor(0, 0, 255), // Blue
  RgbColor(255, 255, 0), // Yellow
  RgbColor(0, 255, 255), // Cyan
  RgbColor(255, 0, 255), // Magenta
]);

/// References the list [colorPalette] was constructed with.
final colors = colorPalette.colors;

/// Creates a new [List<Color>] from [colorPalette.colors].
final materialColors = colorPalette.toColors();
```

## Modifying Palettes

For convenience, [ColorPalette] wraps some of [List]'s methods for interfacing
with its nested list of [colors]. You can [add], [addAll], and [remove] colors
from the list, as well as use the [insert], [insertAll], [getRange], [setRange],
[removeRange], and [replaceRange] methods. You can also get and set colors by
position with bracket operators. The [combine] method or the `+` operator can
also be used to combine palettes.

```dart
// Create an empty palette.
final colorPalette = ColorPalette.empty();

// Add a pure red RGB color to the palette.
colorPalette.add(RgbColor(255, 0, 0));

// Remove the pure red RGB color from the palette.
colorPalette.remove(RgbColor(255, 0, 0));

// Add every color in the provided list.
colorPalette.addAll(<ColorModel>[
  RgbColor(0, 0, 0), // Black
  RgbColor(144, 144, 144), // Grey
  RgbColor(255, 255, 255), // White
  RgbColor(255, 0, 0), // Red
  RgbColor(0, 255, 0), // Green
  RgbColor(0, 0, 255), // Blue
  RgbColor(255, 255, 0), // Yellow
  RgbColor(0, 255, 255), // Cyan
  RgbColor(255, 0, 255), // Magenta
]);

// [RgbColor(255, 255, 255), RgbColor(255, 0, 0)]
print(colorPalette.getRange(2, 4));
```

[ColorPalette] has two sorting methods, [sortBy] and [sortByHue], that
can be called to sort the color palette based on a variety of properties,
as well as [reverse] which reverses the order of the colors in the palette.

```dart
// Sorts the colors in the palette from the highest
// perceived brightness value to the lowest.
colorPalette.sortBy(ColorSortingProperty.brightest);


// Sorts the colors in the palette from the lowest
// perceived brightness value to the highest.
colorPalette.sortBy(ColorSortingProperty.dimmest);

// Sorts the colors in the palette from the highest
// lightness value to the lowest.
colorPalette.sortBy(ColorSortingProperty.lightest);

// Sorts the colors in the palette from the lowest
// lightness value to the highest.
colorPalette.sortBy(ColorSortingProperty.darkest);

// Sorts the colors in the palette from the highest
// intensity value to the lowest.
colorPalette.sortBy(ColorSortingProperty.mostIntense);

// Sorts the colors in the palette from the lowest
// intensity value to the highest.
colorPalette.sortBy(ColorSortingProperty.leastIntense);

// Sorts the colors in the palette from the highest
// saturation value to the lowest.
colorPalette.sortBy(ColorSortingProperty.deepest);

// Sorts the colors in the palette from the lowest
// saturation value to the highest.
colorPalette.sortBy(ColorSortingProperty.dullest);

// Sorts the colors in the palette from the highest combined
// saturation and value values to the lowest.
colorPalette.sortBy(ColorSortingProperty.richest);

// Sorts the colors in the palette from the lowest combined
// saturation and value values to the highest.
colorPalette.sortBy(ColorSortingProperty.muted);

// Sorts the colors by their distance to a red hue. (0°)
colorPalette.sortBy(ColorSortingProperty.red);

// Sorts the colors by their distance to a red-orange hue. (30°)
colorPalette.sortBy(ColorSortingProperty.redOrange);

// Sorts the colors by their distance to a orange hue. (60°)
colorPalette.sortBy(ColorSortingProperty.orange);

// Sorts the colors by their distance to a yellow-orange hue. (90°)
colorPalette.sortBy(ColorSortingProperty.yellowOrange);

// Sorts the colors by their distance to a yellow hue. (120°)
colorPalette.sortBy(ColorSortingProperty.yellow);

// Sorts the colors by their distance to a yellow-green hue. (150°)
colorPalette.sortBy(ColorSortingProperty.yellowGreen);

// Sorts the colors by their distance to a green hue. (180°)
colorPalette.sortBy(ColorSortingProperty.green);

// Sorts the colors by their distance to a cyan hue. (210°)
colorPalette.sortBy(ColorSortingProperty.cyan);

// Sorts the colors by their distance to a blue hue. (240°)
colorPalette.sortBy(ColorSortingProperty.blue);

// Sorts the colors by their distance to a blue-violet hue. (270°)
colorPalette.sortBy(ColorSortingProperty.blueViolet);

// Sorts the colors by their distance to a violet hue. (300°)
colorPalette.sortBy(ColorSortingProperty.violet);

// Sorts the colors by their distance to a magenta hue. (330°)
colorPalette.sortBy(ColorSortingProperty.magenta);
```

The [sortByHue] method will sort the colors based on their position in the
color wheel going in a single direction, clockwise or counter-clockwise.

```dart
// Sorts the colors in the palette, starting from 0° going in
// a clockwise direction around the wheel.
colorPalette.sortByHue();

// Sorts the colors in the palette, starting from 145° going in
// a counter-clockwise direction around the wheel.
colorPalette.sortByHue(startingFrom: 145, clockwise: false);
```

[ColorPalette] also wraps [ColorModel]'s color adjustment methods: [invert],
[opposite], [rotateHue], [warmer], and [cooler], but applies the color
adjustments to the whole palette.

```dart
// Invert every color in the palette.
colorPalette.invert();

// Set every color in the palette to their respective opposites.
colorPalette.opposite();

// Rotate the hues of every color in the palette by 15°.
colorPalette.rotateHue(15);

// Make every color in the palette 10% warmer.
colorPalette.warmer(10);

// Make every color in the palette 20% cooler.
colorPalette.cooler(20);
```

## Color Getters

[ColorPalette] has a variety of getters for retrieving colors with a specific
property:

```dart
/// Returns the color with the highest perceived brightness value.
ColorModel get brightest;

/// Returns the color with the lowest perceived brightness value.
ColorModel get dimmest;

/// Returns the color with the highest lightness value.
ColorModel get lightest;

/// Returns the color with the lowest lightness value.
ColorModel get darkest;

/// Returns the color with the highest intensity value.
ColorModel get mostIntense;

/// Returns the color with the lowest intensity value.
ColorModel get leastIntense;

/// Returns the color with the highest saturation value.
ColorModel get deepest;

/// Returns the color with the lowest saturation value.
ColorModel get dullest;

/// Returns the color with the highest combined saturation and value values.
ColorModel get richest;

/// Returns the color with the lowest combined saturation and value values.
ColorModel get muted;

/// Returns the color with the reddest hue. (0°)
ColorModel get red;

/// Returns the color with the most red-orange hue. (30°)
ColorModel get redOrange;

/// Returns the color with the orangest hue. (60°)
ColorModel get orange;

/// Returns the color with the most yellow-orange hue. (90°)
ColorModel get yellowOrange;

/// Returns the color with the yellowest hue. (120°)
ColorModel get yellow;

/// Returns the color with the most yellow-green hue. (150°)
ColorModel get yellowGreen;

/// Returns the color with the greenest hue. (180°)
ColorModel get green;

/// Returns the color with the most cyan hue. (210°)
ColorModel get cyan;

/// Returns the color with the most bluest hue. (240°)
ColorModel get blue;

/// Returns the color with the most blue-violet hue. (270°)
ColorModel get blueViolet;

/// Returns the color with the most violet hue. (300°)
ColorModel get violet;

/// Returns the color with the most magenta hue. (330°)
ColorModel get magenta;
```
