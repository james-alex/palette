## [1.0.0] - March 17, 2021

* Migrated to null-safe code.

* Added support for the Oklab color space.

## [0.2.0] - October 6, 2020

* Upgraded the flutter_color_models package to v0.2.0+2 and renamed all instances
of HSV to HSB to be inline with the update. (HSV was changed to HSB to avoid a
naming conflict with Flutter's [Color] class's [value] parameter.)

* With the v0.2.0 update of flutter_color_models, all [ColorModel]s now implement
Flutter's [Color] class. __Note:__ The base [ColorModel] class does not implement
[Color], but all of the models that extend it ([RgbColor], [CmykColor], etc...) do.

* Added the [growable] parameter to all factory constructors, if `true`, the
constructed palette will be growable, if `false`, it will be fixed-length.

* Added the [unique] parameter to all factory constructors, if `true`, the
palette will be constructed with a [UniqueList](https://pub.dartlang.org/packages/unique_list),
otherwise the palette will be constructed with a [List].

* Added the [perceivedBrightness] parameter to all relevant factory constructors.
If `true`, colors will generated in the HSP color space, if `false`, colors will
be generated in the HSB color space.

* Added the [clockwise] parameter to the [ColorPalette.polyad] and
[ColorPalette.random] constructors. If `true`, colors will be generated in a
clockwise order around the color wheel, if `false`, colors will be generated
in a counter-clockwise order.

* Added the [closest] and [furthest] methods, for retreiving colors
from the palette with the closest and greatest distance in values to a color.
As well as the [ColorSortingProperty.similarity] and [ColorSortingProperty.difference]
sorting properties, for use with the [sortBy] method.

## [0.1.0] - March 27, 2020

* Initial release.
