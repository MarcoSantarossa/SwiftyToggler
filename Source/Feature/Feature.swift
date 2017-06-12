//
//  Feature.swift
//
//  Copyright (c) 2017 Marco Santarossa (https://marcosantadev.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/**
 
    Extend this class to create a your feature object.
    It has a generic property `FeaturePayload` which is the payload of your feature.
    You can use the payload inside the methods `main()` and `dispose()` to perform your actions
    You may use the payload to add a parent view controller, some states of your application an so on to manage the feature.

    Example:

    ```
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
*/
open class Feature<FeaturePayload>: FeatureProtocol {
    public var payload: FeaturePayload?
    public var isEnabled: Bool

    /// Override it if you have to initialise some properties.
    /// - parameter payload: Payload used by the feature.
    /// - parameter isEnabled: By default. it is false.
	public init(payload: FeaturePayload?, isEnabled: Bool = false) {
        self.payload = payload
		self.isEnabled = isEnabled
    }

    /// Main function of Feature. It's called when the future has been run.
	open func main() {
        fatalError("Feature base class: main method not implemented")
    }
    
    /// It's called when the future has been disabled.
    open func dispose() {}
}
