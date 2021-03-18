import 'dart:math' show Random;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_palette/flutter_palette.dart';

/// The colors used for testing.
const List<Color> _testColors = <Color>[
  RgbColor(0, 0, 0), // Black
  RgbColor(144, 144, 144), // Grey
  RgbColor(255, 255, 255), // White
  RgbColor(255, 0, 0), // Red
  RgbColor(0, 255, 0), // Green
  RgbColor(0, 0, 255), // Blue
  RgbColor(255, 255, 0), // Yellow
  RgbColor(0, 255, 255), // Cyan
  RgbColor(255, 0, 255), // Magenta
  RgbColor(240, 111, 12), // Hue 26°
  RgbColor(240, 111, 12), // Hue 26° Duplicate
  RgbColor(102, 204, 51), // Hue 101°
  RgbColor(102, 204, 51), // Hue 101° Duplicate
  RgbColor(51, 204, 153), // Hue 161°
  RgbColor(51, 204, 153), // Hue 161° Duplicate
  RgbColor(12, 102, 153), // Hue 201°
  RgbColor(12, 102, 153), // Hue 201° Duplicate
  RgbColor(120, 42, 212), // Hue 267°
  RgbColor(120, 42, 212), // Hue 267° Duplicate
  RgbColor(209, 16, 110), // Hue 331°
  RgbColor(209, 16, 110), // Hue 331° Duplicate
];

/// Intervals used to add variability to the values generated in the tests.
const List<double> _vm = <double>[0.125, 0.375, 0.5, 1.0, 1.225];

void main() {
  group('Palette Generators', () {
    group('Adjacent', () {
      group('Uniform', () {
        void tester({required bool growable}) {
          for (var i = 3; i < _testColors.length; i++) {
            final color = RgbColor.fromColor(_testColors[i]);

            for (var j = 1; j <= 288; j++) {
              for (var k = 0; k < _vm.length; k++) {
                final distance = ((j % 24) + 1) * i * _vm[k];

                final colorPalette = ColorPalette.adjacent(
                  color,
                  numberOfColors: j,
                  distance: distance,
                  perceivedBrightness: false,
                  growable: growable,
                );

                for (var l = 0; l < colorPalette.length; l++) {
                  var index = l;
                  if (colorPalette.length.isEven) index++;

                  final expectedHue = (color.hue +
                          (((index / 2).ceil() * distance) *
                              (index % 2 == 0 ? -1 : 1))) %
                      360;

                  expect(
                      _round(colorPalette[l].hue), equals(_round(expectedHue)));
                  expect(_round(colorPalette[l].saturation),
                      equals(_round(color.saturation)));
                }
              }
            }
          }
        }

        test('Growable', () {
          tester(growable: true);
        });

        test('Fixed-Length', () {
          tester(growable: false);
        });
      });

      group('Variable', () {
        void tester({required bool growable}) {
          for (var i = 3; i < _testColors.length; i++) {
            final color =
                RgbColor.fromColor(_testColors[i]).toHsbColor().toList();

            for (var j = 1; j <= 288; j++) {
              for (var k = 0; k < _vm.length; k++) {
                final distance = ((j % 24) + 1) * i * _vm[k];
                final hueVariability = (j % 3) * i * _vm[k];
                final sbVariability = (j % 2) * i * _vm[k];

                final colorPalette = ColorPalette.adjacent(
                  _testColors[i],
                  numberOfColors: j,
                  distance: distance,
                  hueVariability: hueVariability,
                  saturationVariability: sbVariability,
                  brightnessVariability: sbVariability,
                  perceivedBrightness: false,
                  growable: growable,
                );

                for (var l = 0; l < colorPalette.length; l++) {
                  var index = l;
                  if (colorPalette.length.isEven) index++;

                  final expectedHue = (color[0] +
                          (((index / 2).ceil() * distance) *
                              (index % 2 == 0 ? -1 : 1))) %
                      360;

                  final values = colorPalette[l].toHsbColor().toList();

                  expect(_hueIsInRange(values[0], expectedHue, hueVariability),
                      equals(true));
                  expect(_isInRange(values[1], color[1], sbVariability),
                      equals(true));
                  expect(_isInRange(values[2], color[2], sbVariability),
                      equals(true));
                }
              }
            }
          }
        }

        test('Growable', () {
          tester(growable: true);
        });

        test('Fixed-Length', () {
          tester(growable: false);
        });
      });
    });

    group('Polyad', () {
      group('Uniform', () {
        void tester({required bool growable}) {
          for (var i = 3; i < _testColors.length; i++) {
            final color = RgbColor.fromColor(_testColors[i]);

            for (var j = 1; j <= 288; j++) {
              final colorPalette = ColorPalette.polyad(
                color,
                numberOfColors: i,
                perceivedBrightness: false,
                growable: growable,
              );

              for (var k = 0; k < colorPalette.length; k++) {
                final expectedHue =
                    (color.hue + ((360 / colorPalette.length) * k)) % 360;

                expect(
                    _round(colorPalette[k].hue), equals(_round(expectedHue)));
                expect(_round(colorPalette[k].saturation),
                    equals(_round(color.saturation)));
              }
            }
          }
        }

        test('Growable', () {
          tester(growable: true);
        });

        test('Fixed-Length', () {
          tester(growable: false);
        });
      });

      group('Variable', () {
        void tester({required bool growable}) {
          for (var i = 3; i < _testColors.length; i++) {
            final color = RgbColor.fromColor(_testColors[i]);

            for (var j = 1; j <= 288; j++) {
              for (var k = 0; k < _vm.length; k++) {
                final hueVariability = (j % 3) * i * _vm[k];
                final sbVariability = (j % 2) * i * _vm[k];

                final colorPalette = ColorPalette.polyad(
                  color,
                  numberOfColors: j,
                  hueVariability: hueVariability,
                  saturationVariability: sbVariability,
                  brightnessVariability: sbVariability,
                  perceivedBrightness: false,
                  growable: growable,
                );

                final colorValues = color.toHsbColor().toList();

                for (var l = 0; l < colorPalette.length; l++) {
                  final expectedHue =
                      (color.hue + ((360 / colorPalette.length) * l)) % 360;

                  final values = colorPalette[l].toHsbColor().toList();

                  expect(_hueIsInRange(values[0], expectedHue, hueVariability),
                      equals(true));
                  expect(_isInRange(values[1], colorValues[1], sbVariability),
                      equals(true));
                  expect(_isInRange(values[2], colorValues[2], sbVariability),
                      equals(true));
                }
              }
            }
          }
        }

        test('Growable', () {
          tester(growable: true);
        });

        test('Fixed-Length', () {
          tester(growable: false);
        });
      });
    });

    group('Random', () {
      void tester({required bool growable}) {
        final rng = Random();

        for (var i = 1; i <= 288; i++) {
          for (var j = 0; j < 40; j++) {
            final minHue = (360 / (j + 1)) * j;
            final maxHue = 360 - minHue;
            final minSB = rng.nextInt(101);
            final maxSB = rng.nextInt(101 - minSB) + minSB;

            final colorPalette = ColorPalette.random(
              i,
              minHue: minHue,
              maxHue: maxHue,
              minSaturation: minSB,
              maxSaturation: maxSB,
              minBrightness: minSB,
              maxBrightness: maxSB,
              perceivedBrightness: false,
              growable: growable,
            );

            final distance = (minHue - maxHue) / colorPalette.length;
            final variability = distance.abs() / 4;

            for (var k = 1; k < colorPalette.length; k++) {
              if (colorPalette[k].isMonochromatic) {
                continue;
              }

              var values = colorPalette[k].toHsbColor().toList();

              values = values.map(_round).toList();

              final expectedHue = (colorPalette[0].hue + (distance * k)) % 360;

              expect(_hueIsInRange(values[0], expectedHue, variability),
                  equals(true));
              expect(values[1] >= minSB && values[1] <= maxSB, equals(true));
              expect(values[2] >= minSB && values[2] <= maxSB, equals(true));
            }
          }
        }
      }

      test('Growable', () {
        tester(growable: true);
      });

      test('Fixed-Length', () {
        tester(growable: false);
      });
    });

    group('Split Complimentary', () {
      group('Uniform', () {
        void tester({required bool growable}) {
          for (var i = 3; i < _testColors.length; i++) {
            final color = RgbColor.fromColor(_testColors[i]);

            for (var j = 1; j <= 288; j++) {
              for (var k = 0; k < _vm.length; k++) {
                final distance = ((j % 24) + 1) * i * _vm[k];

                final colorPalette = ColorPalette.splitComplimentary(
                  color,
                  numberOfColors: j,
                  distance: distance,
                  perceivedBrightness: false,
                  growable: growable,
                );

                for (var l = 1; l < colorPalette.length; l++) {
                  var index = l;
                  if (colorPalette.length.isEven) {
                    index--;
                  }

                  final expectedHue = (color.hue +
                          (((index / 2).ceil() * distance) *
                              (index % 2 == 0 ? -1 : 1)) +
                          180) %
                      360;

                  expect(
                      _round(colorPalette[l].hue), equals(_round(expectedHue)));
                  expect(_round(colorPalette[l].saturation),
                      equals(_round(color.saturation)));
                }
              }
            }
          }
        }

        test('Growable', () {
          tester(growable: true);
        });

        test('Fixed-Length', () {
          tester(growable: false);
        });
      });

      group('Variable', () {
        void tester({required bool growable}) {
          for (var i = 3; i < _testColors.length; i++) {
            final color = RgbColor.fromColor(_testColors[i]);

            for (var j = 1; j <= 288; j++) {
              for (var k = 0; k < _vm.length; k++) {
                final distance = ((j % 24) + 1) * i * _vm[k];
                final hueVariability = (j % 3) * i * _vm[k];
                final sbVariability = (j % 2) * i * _vm[k];

                final colorPalette = ColorPalette.splitComplimentary(
                  color,
                  numberOfColors: j,
                  distance: distance,
                  hueVariability: hueVariability,
                  saturationVariability: sbVariability,
                  brightnessVariability: sbVariability,
                  perceivedBrightness: false,
                  growable: growable,
                );

                final colorValues = color.toHsbColor().toList();

                for (var l = 1; l < colorPalette.length; l++) {
                  var index = l;
                  if (colorPalette.length.isEven) {
                    index--;
                  }

                  final expectedHue = (color.hue +
                          (((index / 2).ceil() * distance) *
                              (index % 2 == 0 ? -1 : 1)) +
                          180) %
                      360;

                  final values = colorPalette[l].toHsbColor().toList();

                  expect(_hueIsInRange(values[0], expectedHue, hueVariability),
                      equals(true));
                  expect(_isInRange(values[1], colorValues[1], sbVariability),
                      equals(true));
                  expect(_isInRange(values[2], colorValues[2], sbVariability),
                      equals(true));
                }
              }
            }
          }
        }

        test('Growable', () {
          tester(growable: true);
        });

        test('Fixed-Length', () {
          tester(growable: false);
        });
      });
    });

    group('Opposites', () {
      group('Inserted', () {
        void tester({required bool growable}) {
          final colorPalette = ColorPalette.opposites(
            ColorPalette.from(_testColors),
            growable: growable,
          );

          for (var i = 0; i < colorPalette.length; i++) {
            final color = RgbColor.fromColor(_testColors[(i / 2).floor()]);

            if (i % 2 == 0) {
              expect(colorPalette[i], equals(color));
            } else {
              expect(colorPalette[i], equals(color.rotateHue(180)));
            }
          }
        }

        test('Growable', () {
          tester(growable: true);
        });

        test('Fixed-Length', () {
          tester(growable: false);
        });
      });

      group('Appended', () {
        void tester({required bool growable}) {
          final colorPalette = ColorPalette.opposites(
            ColorPalette.from(_testColors),
            insertOpposites: false,
            growable: growable,
          );

          for (var i = 0; i < colorPalette.length; i++) {
            if (i < _testColors.length) {
              expect(colorPalette[i], equals(_testColors[i]));
            } else {
              expect(
                  colorPalette[i],
                  equals(RgbColor.fromColor(_testColors[i % _testColors.length])
                      .rotateHue(180)));
            }
          }
        }

        test('Growable', () {
          tester(growable: true);
        });

        test('Fixed-Length', () {
          tester(growable: false);
        });
      });
    });
  });

  group('Sorting Palettes', () {
    test('Brightest', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.brightest);

        num? lastBrightness;

        for (var color in colorPalette.colors) {
          final brightness = color.toHspColor().perceivedBrightness;

          lastBrightness ??= brightness;

          expect(brightness <= lastBrightness, equals(true));

          lastBrightness = brightness;
        }
      }
    });

    test('Dimmest', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.dimmest);

        num? lastBrightness;

        for (var color in colorPalette.colors) {
          final brightness = color.toHspColor().perceivedBrightness;

          lastBrightness ??= brightness;

          expect(brightness >= lastBrightness, equals(true));

          lastBrightness = brightness;
        }
      }
    });

    test('Lightest', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.lightest);

        num? lastLightness;

        for (var color in colorPalette.colors) {
          final lightness = color.toHslColor().lightness;

          lastLightness ??= lightness;

          expect(lightness <= lastLightness, equals(true));

          lastLightness = lightness;
        }
      }
    });

    test('Darkest', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.darkest);

        num? lastLightness;

        for (var color in colorPalette.colors) {
          final lightness = color.toHslColor().lightness;

          lastLightness ??= lightness;

          expect(lightness >= lastLightness, equals(true));

          lastLightness = lightness;
        }
      }
    });

    test('Most Intense', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.mostIntense);

        num? lastIntensity;

        for (var color in colorPalette.colors) {
          final intensity = color.toHsiColor().intensity;

          lastIntensity ??= intensity;

          expect(intensity <= lastIntensity, equals(true));

          lastIntensity = intensity;
        }
      }
    });

    test('Least Intense', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.leastIntense);

        num? lastIntensity;

        for (var color in colorPalette.colors) {
          final intensity = color.toHsiColor().intensity;

          lastIntensity ??= intensity;

          expect(intensity >= lastIntensity, equals(true));

          lastIntensity = intensity;
        }
      }
    });

    test('Deepest', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.deepest);

        num? lastSaturation;

        for (var color in colorPalette.colors) {
          final saturation = color.saturation;

          lastSaturation ??= saturation;

          expect(saturation <= lastSaturation, equals(true));

          lastSaturation = saturation;
        }
      }
    });

    test('Dullest', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.dullest);

        num? lastSaturation;

        for (var color in colorPalette.colors) {
          final saturation = color.saturation;

          lastSaturation ??= saturation;

          expect(saturation >= lastSaturation, equals(true));

          lastSaturation = saturation;
        }
      }
    });

    test('Richest', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.richest);

        num? lastValue;

        for (var color in colorPalette.colors) {
          final hsb = color.toHsbColor();

          final value = hsb.saturation + hsb.brightness;

          lastValue ??= value;

          expect(value <= lastValue, equals(true));

          lastValue = value;
        }
      }
    });

    test('Muted', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        colorPalette.sortBy(ColorSortingProperty.muted);

        num? lastValue;

        for (var color in colorPalette.colors) {
          final hsb = color.toHsbColor();

          final value = hsb.saturation + hsb.brightness;

          lastValue ??= value;

          expect(value >= lastValue, equals(true));

          lastValue = value;
        }
      }
    });

    const colorProperties = <ColorSortingProperty>[
      ColorSortingProperty.red,
      ColorSortingProperty.redOrange,
      ColorSortingProperty.orange,
      ColorSortingProperty.yellowOrange,
      ColorSortingProperty.yellow,
      ColorSortingProperty.yellowGreen,
      ColorSortingProperty.green,
      ColorSortingProperty.cyan,
      ColorSortingProperty.blue,
      ColorSortingProperty.blueViolet,
      ColorSortingProperty.violet,
      ColorSortingProperty.magenta,
    ];

    test('Colors', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        for (var j = 0; j < colorProperties.length; j++) {
          colorPalette.sortBy(colorProperties[j]);

          num? lastDistance;

          for (var color in colorPalette.colors) {
            final distance = _calculateDistance(color.hue, j * 30);

            lastDistance ??= distance;

            expect(distance >= lastDistance, equals(true));

            lastDistance = distance;
          }
        }
      }
    });
  });

  group('Transforming Palettes', () {
    test('Inverted', () {
      final colorPalette = ColorPalette.from(_testColors);

      colorPalette.invert();

      for (var i = 0; i < colorPalette.length; i++) {
        expect(colorPalette[i].inverted, equals(_testColors[i]));
      }
    });

    test('Opposite', () {
      final colorPalette = ColorPalette.from(_testColors);

      colorPalette.opposite();

      for (var i = 0; i < colorPalette.length; i++) {
        expect(colorPalette[i].opposite, equals(_testColors[i]));
      }
    });

    test('Rotate Hue', () {
      for (var i = 0; i < _testColors.length; i++) {
        final colorPalette = ColorPalette.polyad(
          _testColors[i],
          numberOfColors: ((i % 3) + 1) * 32,
          hueVariability: 360,
          saturationVariability: 100,
          brightnessVariability: 100,
          perceivedBrightness: false,
        );

        final hues = colorPalette.colors.map((color) => color.hue).toList();

        final distance = (i - (_testColors.length / 2)) * 12.25;

        colorPalette.rotateHue(distance);

        for (var j = 0; j < colorPalette.length; j++) {
          if (colorPalette[j].isMonochromatic) {
            continue;
          }

          final expectedHue = (hues[j] + distance) % 360;

          expect(_round(colorPalette[j].hue), equals(_round(expectedHue)));
        }
      }
    });

    test('Warmer', () {
      for (var i = 3; i < _testColors.length; i++) {
        for (var j = 1; j <= 24; j++) {
          final colorPalette = ColorPalette.polyad(
            _testColors[i],
            numberOfColors: ((i % 3) + 1) * 32,
            hueVariability: 360,
            saturationVariability: 100,
            brightnessVariability: 100,
            perceivedBrightness: false,
          );

          final hues = colorPalette.colors.map((color) => color.hue).toList();

          final distance = (100 / 24) * j;

          colorPalette.warmer(distance);

          for (var k = 0; k < colorPalette.length; k++) {
            var expectedHue = hues[k];

            final adjustment =
                _calculateDistance(expectedHue, 90) * (distance / 100);

            if (expectedHue >= 0 && expectedHue <= 90) {
              expectedHue += adjustment;
              if (expectedHue > 90) expectedHue = 90;
            } else if (expectedHue >= 270 && expectedHue <= 360) {
              expectedHue = (expectedHue + adjustment) % 360;
            } else {
              expectedHue -= adjustment;
              if (expectedHue < 90) expectedHue = 90;
            }

            expect(_round(colorPalette[k].hue), equals(_round(expectedHue)));
          }
        }
      }
    });

    test('Cooler', () {
      for (var i = 3; i < _testColors.length; i++) {
        for (var j = 1; j <= 24; j++) {
          final colorPalette = ColorPalette.polyad(
            _testColors[i],
            numberOfColors: ((i % 3) + 1) * 32,
            hueVariability: 360,
            saturationVariability: 100,
            brightnessVariability: 100,
            perceivedBrightness: false,
          );

          final hues = colorPalette.colors.map((color) => color.hue).toList();

          final distance = (100 / 24) * j;

          colorPalette.cooler(distance);

          for (var k = 0; k < colorPalette.length; k++) {
            var expectedHue = hues[k];

            final adjustment =
                _calculateDistance(expectedHue, 270) * (distance / 100);

            if (expectedHue >= 0 && expectedHue <= 90) {
              expectedHue = (expectedHue - adjustment) % 360;
            } else if (expectedHue >= 270 && expectedHue <= 360) {
              expectedHue -= adjustment;
              if (expectedHue < 270) expectedHue = 270;
            } else {
              expectedHue += adjustment;
              if (expectedHue > 270) expectedHue = 270;
            }

            expect(_round(colorPalette[k].hue), equals(_round(expectedHue)));
          }
        }
      }
    });

    test('Color Conversion', () {
      final colorPalette = ColorPalette.from(_testColors);
      final colorSpaces = ColorSpace.values;

      for (var i = 0; i < colorSpaces.length; i++) {
        colorPalette.toColorSpace(colorSpaces[i]);

        colorPalette.colors.every((color) {
          var colorIsInCorrectSpace = false;

          switch (i) {
            case 0:
              colorIsInCorrectSpace = color is CmykColor;
              break;
            case 1:
              colorIsInCorrectSpace = color is HsiColor;
              break;
            case 2:
              colorIsInCorrectSpace = color is HslColor;
              break;
            case 3:
              colorIsInCorrectSpace = color is HspColor;
              break;
            case 4:
              colorIsInCorrectSpace = color is HsbColor;
              break;
            case 5:
              colorIsInCorrectSpace = color is LabColor;
              break;
            case 6:
              colorIsInCorrectSpace = color is RgbColor;
              break;
            case 7:
              colorIsInCorrectSpace = color is XyzColor;
              break;
          }

          return colorIsInCorrectSpace;
        });
      }
    });
  });
}

/// Rounds [value] to the thousandth.
num _round(num value) => (value * 1000).round() / 1000;

/// Returns `true` if [value] is in the range
/// of `expectedValue +/- variability`.
bool _isInRange(num value, num expectedValue, num variability) {
  value = _round(value);
  expectedValue = _round(expectedValue);

  if (value >= expectedValue - variability &&
      value <= expectedValue + variability) {
    return true;
  }

  return false;
}

/// Returns `true` if [value] is in the range of
/// `expectedValue +/- (variability / 2)` in degrees.
bool _hueIsInRange(num value, num expectedValue, num variability) {
  // Round the [value] and [expectedValue] to the thousandth.
  value = _round(value);
  expectedValue = _round(expectedValue);
  // Allow for a 1/1000th margin of error.
  variability += 0.001;

  final distance1 = _round(
      value > expectedValue ? value - expectedValue : expectedValue - value);
  final distance2 = _round(value > expectedValue
      ? (expectedValue + 360) - value
      : (value + 360) - expectedValue);

  return (distance1 < distance2 ? distance1 : distance2) <= variability
      ? true
      : false;
}

/// Calculates the distance between [hue1] and [hue2].
num _calculateDistance(num hue1, num hue2) {
  assert(hue1 >= 0 && hue1 <= 360);
  assert(hue2 >= 0 && hue2 <= 360);
  final distance1 = hue1 > hue2 ? hue1 - hue2 : hue2 - hue1;
  final distance2 = hue1 > hue2 ? (hue2 + 360) - hue1 : (hue1 + 360) - hue2;
  return distance1 < distance2 ? distance1 : distance2;
}
