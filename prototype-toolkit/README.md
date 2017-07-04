QML Prototype Toolkit
=====================

## Example

```qml
import Prototype.Components 0.1 as Proto

Proto.App {
  // Show the responsive controls
  showResponsiveControls: true

  // Quit when Ctrl+Q is pressed
  Proto.QuitOnControlQ { }
}
```

## Usage

### MainView

Inherits `Ubuntu.Components.MainView`.

The `MainView` Component is based on the Ubuntu SDK Component of the same name. It adds the possibilty to quit the app using the Ctrl+Q key combination.

In order to use it using the `MainView` name, __Prototype.Components must be imported after Ubuntu.Components__:

```qml
import QtQuick 2.2
import Ubuntu.Components 1.1
import Prototype.Components 0.1

MainView {
}
```

Otherwise, you have to use the `as` keyword to implicitely import it:

```qml
import QtQuick 2.2
import Ubuntu.Components 1.1 as Ubuntu
import Prototype.Components 0.1 as Prototype

Prototype.MainView {
}
```

#### Properties

Name             | Type        | Default   | Description
:--------------- | ----------- | --------- | ------------
_quitOnCtrlQ_    | `Boolean`   | `true`    | Allow to disable the “Quit on ctrl+Q” behavior.

### App

TODO

### AppControls

TODO

### ResponsiveControls

TODO

### Line

Inherits `QtQuick.Rectangle`.

The `Line` Component adds the possibilty to draw a line from a point to anthor one.

#### Properties

Name             | Type        | Default     | Description
:--------------- | ----------- | ---------   | ------------
_x1_             | `real`      | `undefined` | The x position of the first point.
_y1_             | `real`      | `undefined` | The y position of the first point.
_x2_             | `real`      | `undefined` | The x position of the second point.
_y2_             | `real`      | `undefined` | The y position of the second point.
_color_          | `color`     | `'black'`   | The line color
_height_         | `lineWidth` | `2`         | The line width.

### ListModelUtils

TODO

#### App Properties

## Installation

Get the latest version:

```sh
$ bzr branch lp:~willow-team/willow/prototype-toolkit
```

Set the `QML2_IMPORT_PATH` environment variable to the prototype-toolkit directory:

### Using Qt Creator

- Click on the _Projects_ button
- Click on the _Run_ tab
- In the _Run Environment_ section, click on _Details_, then _Add_
- Create the `QML2_IMPORT_PATH` variable with the path to the toolkit as a value.

### Using Make

```sh
$ export QML2_IMPORT_PATH=/path/to/prototype-toolkit
```
