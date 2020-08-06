# DSCenterPinMapView

[![Version](https://img.shields.io/cocoapods/v/DSCenterPinMapView.svg?style=flat)](http://cocoapods.org/pods/DSCenterPinMapView)
[![License](https://img.shields.io/cocoapods/l/DSCenterPinMapView.svg?style=flat)](http://cocoapods.org/pods/DSCenterPinMapView)
[![Language](https://img.shields.io/badge/language-Swift-orange.svg?style=flat)]()
[![Supports](https://img.shields.io/badge/supports-CocoaPods?style=flat)]()
[![Platform](https://img.shields.io/cocoapods/p/DSCenterPinMapView.svg?style=flat)](http://cocoapods.org/pods/DSCenterPinMapView)
<br />

## Examples

 ![](/Screenshots/example.gif)  ![](/Screenshots/example_2.gif)

## Requirements
- iOS 11.0+
- Xcode 11.6

## Installation

DSCenterPinMapView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DSCenterPinMapView'
```
## Usage

1. Change the class of a view from UIView to DSCenterPinMapView 
2. Programmatically:

```
let pinMapView = DSCenterPinMapView(frame: myFrame)

```

```
let pinMapView = DSCenterPinMapView(frame: myFrame)

```

## Customization 

##### pinImage
Center Pin's Pin image view's image to assign a custom pin asset
```swift
pinMapView.pinImage = UIImage(named: "my-pin-image")
```

##### shadowImage
Center Pin's Shadow image view's image to assign a custom pin asset
```swift
pinMapView.shadowImage = UIImage(named: "my-shadow-image")
```

##### shadowImageWhenDragged
Alternate shadow image, if specified the center pin's shadow will change to this one while the user us dragging the map
```swift
pinMapView.shadowImageWhenDragged = UIImage(named: "my-optional-second-shadow-image")
```

##### shadowAlpha
Center Pin's Shadow image view alpha value customization
```swift
pinMapView.shadowAlpha = 0.8
```

##### Center Pin and Shadow Offsets
Different offsets if you want to adjust your custom assets for pin and shadow
```swift
pinMapView.pinOffsetY = 13
pinMapView.shadowOffsetX = 12
pinMapView.shadowOffsetY = 10
```

#### isDragging
If you would like to know if map is being moved

#### Delegate
You can implement DSCenterPinMapView delegate to implement your own didStartDragging and didEndDragging functionality.
```swift
pinMapView.delegate = self

extension MyViewController: DSCenterPinMapViewDelegate {

    func didStartDragging() {
        // My custom actions
    }

    func didEndDragging() {
        // My custom actions
        selectedLocation = pinMapView.mapview.centerCoordinate
    }

}

```

You can also set your own MKMapView delegate while keeping DSCenterPinMapView core functionality by using updateDragging() un MKMapViewDelegate
```swift
pinMapView.mapview.delegate = self

extension MyViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // My custom implementation
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // My custom implementation
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // My custom implementation
        pinMapView.updateDragging() // Place this code to keep DSCenterPinMapView delegate functionality
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // My custom implementation
        pinMapView.updateDragging() // Place this code to keep DSCenterPinMapView delegate functionality
    }

}

```

#### Animate Pin
If you would like to animate your pin while its being dragged you shloud use UIImageView animation. example:
```swift

pinMapView.delegate = self

let pinImages = (1...36).map { UIImage(named: "pin-\($0)")! }
pinMapView.pin.pin.animationImages = pinImages
pinMapView.pin.pin.animationDuration = 0.8

pinMapView.delegate = self

extension MyViewController: DSCenterPinMapViewDelegate {

    func didStartDragging() {
        // My custom actions
        pinMapView.pin.pin.startAnimating()
    }

    func didEndDragging() {
        // My custom actions
        pinMapView.pin.pin.stopAnimating()
    }

}

```

## Author

Daniel Esteban Salinas Suárez, danielesalinas23@gmail.com

## License

DSCenterPinMapView is available under the MIT license. See the LICENSE file for more info.
