//
//  FeaturesManagerProtocol.swift
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

protocol FeaturesManagerProtocol {
    func add(feature: FeatureProtocol, name: String, shouldRunWhenEnabled: Bool)
	func update(featureName: String, shouldRunWhenEnabled: Bool) throws
	func remove(featureName: String)
	func removeAll()
	func isEnabled(featureName: String) throws -> Bool
    @discardableResult
    func run(featureName: String) throws -> Bool
}

protocol FeaturesManagerObserversProtocol {
	func addChangesObserver(_ observer: FeatureChangesObserver, featureNames: [String])
	func addChangesObserver(_ observer: FeatureChangesObserver, featureName: String)
	func removeChangesObserver(_ observer: FeatureChangesObserver, featureNames: [String]?)
}

protocol FeaturesManagerFeaturesListPresenterProtocol {
	func presentModalFeaturesList(in window: UIWindow) throws
	func presentFeaturesList(in viewController: UIViewController, view: UIView?)
}

protocol FeaturesManagerTogglerProtocol {
	var featuresStatus: [FeatureStatus] { get }

	func setEnable(_ isEnabled: Bool, featureName: String) throws
}
