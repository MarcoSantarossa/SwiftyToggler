![SwiftyToggler Banner](https://raw.githubusercontent.com/MarcoSantarossa/SwiftyToggler/master/Resources/Banner/SwiftyTogglerBanner.png)

![Swift 3.1](https://img.shields.io/badge/Swift-3.1-F16D39.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Twitter](https://img.shields.io/badge/twitter-@MarcoSantaDev-blue.svg?style=flat)](http://twitter.com/MarcoSantaDev)

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [TODO](#todo)
- [Communication](#communication)
- [Credits](#credits)
- [License](#license)

## Requirements

- iOS 8.0+
- Xcode 8.1+
- Swift 3.1+

## Installation

### CocoaPods

Create a `Podfile` file in the root of your application and the following content:

```ruby
use_frameworks!

target '<Your Target Name>' do
    pod 'SwiftyToggler', '~> 1.0.0'
end
```

Then, run `pod install`.

### Carthage

Create a `Cartfile ` file in the root of your application and the following content:

```ogdl
github "MarcoSantarossa/SwiftyToggler" ~> 1.0.0
```

Then, run `carthage update` to build the framework and drag the built `SwiftyToggler.framework` into your Xcode project.

### Swift Package Manager

Create a `Package.swift` file in the root of your application and the following content:

```swift
import PackageDescription

let package = Package(
  name: "YourApp",
  dependencies: [
    .Package(url: "https://github.com/MarcoSantarossa/SwiftyToggler.git", “1.0.0”)
  ]
)
```

## Usage

### Create A Feature

There are two ways to create a feature:

#### Implementing FeatureProtocol

The library provides the protocol `FeatureProtocol` which you can implement:

```Swift
class MyProtocol: FeatureProtocol {

	private let parentViewController: UIViewController
	private let featureViewController: UIViewController

	var isEnabled: Bool = false

	init(parentViewController: UIViewController) {
		self.parentViewController = parentViewController
		featureViewController = UIViewController()
	}

	// Main function of Feature. It's called when the future has been run.
	func main() {
		parentViewController.present(featureViewController, animated: true, completion: nil)
	}

	// It's called when the future has been disabled.
	func dispose() {
		featureViewController.dismiss(animated: true, completion: nil)
	}
}
```

#### Extending Feature [Recommended]

The library provides the class `Feature<T>` which you can extend. It has a generic property which is the payload of the feature. The payload is a clean way to manage the dependencies of your feature:

```Swift
struct MyPayload {
    let parentViewController: UIViewController
}

class MyFeature: Feature<MyPayload> {

	private let featureViewController: UIViewController

	override init(payload: MyPayload?, isEnabled: Bool = false) {
		featureViewController = UIViewController()

		super.init(payload: payload, isEnabled: isEnabled)
	}

    override func main() {
        payload?.parentViewController.present(featureViewController, animated: true, completion: nil)
    }

    override func dispose() {
        featureViewController.dismiss(animated: true, completion: nil)
    }
}
```

### Add A Feature

```Swift
class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let featurePayload = MyPayload(parentViewController: self)
		let feature = MyFeature(payload: featurePayload)
		FeaturesManager.shared.add(feature: feature, name: "MyFeature", shouldRunWhenEnabled: true)
	}
}
```

### Remove A Feature

```Swift
FeaturesManager.shared.remove(featureName: "MyFeature")
// or
FeaturesManager.shared.removeAll()
```

### Run A Feature

```Swift
do {
	let isRunning = try FeaturesManager.shared.run(featureName: "MyFeature")
	print("Is the feature running: \(isRunning)")
} catch SwiftyTogglerError.featureNotFound {
	print("Feature not found")
} catch {}
```

### Enable/Disable A Feature

```Swift
do {
	try FeaturesManager.shared.setEnable(true, featureName: "MyFeature")
} catch SwiftyTogglerError.featureNotFound {
	print("Feature not found")
} catch {}
```

### Changes Observer

You can observer when a feature changes the value `isEnable`:

```Swift
class ViewController: UIViewController {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		FeaturesManager.shared.addChangesObserver(self)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		FeaturesManager.shared.removeChangesObserver(self)
	}
}

extension ViewController: FeatureChangesObserver {
	func featureDidChange(name: String, isEnabled: Bool) {

	}
}
```

### Present Features List

![Presenting Mode Screenshots](https://raw.githubusercontent.com/MarcoSantarossa/SwiftyToggler/master/Resources/Screenshots/SwiftyTogglerPresentingModes.jpg)

#### Modal

```Swift
do {
	try FeaturesManager.shared.presentModalFeaturesList()
} catch SwiftyTogglerError.modalFeaturesListAlreadyPresented {
	print("Features List already presented as modal")
} catch {}
```

#### Child View Controller

```Swift
class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		FeaturesManager.shared.presentFeaturesList(in: self)
	}
}
```

### Advanced

#### shouldRunWhenEnabled

You can use this flag to run the feature as soon as it's enabled. You can set it with:

```Swift
FeaturesManager.shared.add(feature: feature, name: "MyFeature", shouldRunWhenEnabled: true)
// or
do {
	try FeaturesManager.shared.update(featureName: "MyFeature", shouldRunWhenEnabled: true)
} catch SwiftyTogglerError.featureNotFound {
	print("Feature not found")
} catch {}
```

## TODO

[ ] Add another example in example project.

[ ] Add feature dependencies.

[ ] Update features list table if a new feature is added when the table is visible.

[ ] Call `dispose()` when a feature is removed.

[ ] Allow async call to feature `main()` and `dispose()`.

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Credits

SwiftyToggler is owned and maintained by [Marco Santarossa](https://marcosantadev.com). You can follow him on Twitter at [@MarcoSantaDev](https://twitter.com/MarcoSantaDev).

## License

SwiftyToggler is released under the MIT license. [See LICENSE](https://github.com/MarcoSantarossa/SwiftyToggler/blob/master/LICENSE) for details.