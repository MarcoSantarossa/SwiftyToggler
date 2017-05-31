//
//  FeaturesManager.swift
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

public final class FeaturesManager {
    
    /// Static instance to use as singleton
    public static let shared = FeaturesManager()

	var featuresStatus: [FeatureStatus] {
		return dict
			.flatMap { FeatureStatus(name: $0.key, isEnabled: $0.value.feature.isEnabled) }
			.sorted(by: { $0.name < $1.name })
	}

	fileprivate let featureChangesObserversPool: FeatureChangesObserversPoolProtocol
	fileprivate let featuresListCoordinator: FeaturesListCoordinatorProtocol
    fileprivate var dict = [String: FeatureProxyProtocol]()

	init(featureChangesObserversPool: FeatureChangesObserversPoolProtocol = FeatureChangesObserversPool(),
	     featuresListCoordinator: FeaturesListCoordinatorProtocol = FeaturesListCoordinator()) {
        self.featureChangesObserversPool = featureChangesObserversPool
		self.featuresListCoordinator = featuresListCoordinator
    }

    fileprivate func findFeatureProxy(for name: String) throws -> FeatureProxyProtocol {
        guard let proxy = dict[name] else {
            throw SwiftyTogglerError.featureNotFound
        }
        return proxy
    }
}

// MARK: - FeaturesManagerProtocol
extension FeaturesManager: FeaturesManagerProtocol {
    /// Adds a new features. If the feature name already exists, it will replace the previous one.
    /// - parameter feature: It's the feature which you want to add.
    /// - parameter name: The feature name associated to the feature to add.
    /// - parameter shouldRunWhenEnabled: Flag to run the feature as soon as it's enabled. By default is false.
	public func add(feature: FeatureProtocol, name: String, shouldRunWhenEnabled: Bool = false) {
		let proxy = FeatureProxy(feature: feature, shouldRunWhenEnabled: shouldRunWhenEnabled)
		dict[name] = proxy
	}

    /// Updates the `shouldRunWhenEnabled` value of a feature. If the feature name doesn't exist, will be thrown an error `SwiftyTogglerError.featureNotFound`.
    /// - parameter featureName: Feature name to update.
    /// - parameter shouldRunWhenEnabled: Flag to run the feature as soon as it's enabled.
    /// - throws: SwiftyTogglerError.featureNotFound if the feature name is not found.
	public func update(featureName: String, shouldRunWhenEnabled: Bool) throws {
		var proxy = try findFeatureProxy(for: featureName)
		proxy.shouldRunWhenEnabled = shouldRunWhenEnabled
	}

    /// Removes a feature.
    /// - parameter featureName: Feature name to remove.
	public func remove(featureName: String) {
		dict.removeValue(forKey: featureName)
	}

    /// Removes all the features.
	public func removeAll() {
		dict.removeAll()
	}

    /// Runs a feature.
    /// - parameter featureName: Feature name to run.
    /// - returns: `True` if the feature has been run, `False` if it hasn't been run because it is not enabled.
    @discardableResult
	public func run(featureName: String) throws -> Bool {
		let proxy = try findFeatureProxy(for: featureName)
		return proxy.run()
	}

    /// Checks if a feature is enabled.
    /// - parameter featureName: Feature name to check.
    /// - returns: `True` if the feature is enabled, `False` if it is not enabled.
	public func isEnabled(featureName: String) throws -> Bool {
		let proxy = try findFeatureProxy(for: featureName)
		return proxy.isFeatureEnable
	}
}

// MARK: - FeaturesManagerObserversProtocol
extension FeaturesManager: FeaturesManagerObserversProtocol {
    /// Adds an observer for all features changes.
    /// - parameter observer: Features changes observer.
	public func addChangesObserver(_ observer: FeatureChangesObserver) {
		featureChangesObserversPool.addObserver(observer, featureNames: nil)
	}

    /// Adds an observer for a specific feature changes.
    /// - parameter observer: Feature changes observer.
    /// - parameter featureName: Feature name to observer.
	public func addChangesObserver(_ observer: FeatureChangesObserver, featureName: String) {
		featureChangesObserversPool.addObserver(observer, featureNames: [featureName])
	}

    /// Adds an observer for an array of specific features changes.
    /// - parameter observer: Features changes observer.
    /// - parameter featureNames: Array of features name to observer.
	public func addChangesObserver(_ observer: FeatureChangesObserver, featureNames: [String]) {
		featureChangesObserversPool.addObserver(observer, featureNames: featureNames)
	}

    /// Removes an observer.
    /// - parameter observer: Observer to remove.
    /// - parameter featureNames: Array of features name to remove. If nil, the observer will be removed for all the features. By default is nil.
	public func removeChangesObserver(_ observer: FeatureChangesObserver, featureNames: [String]? = nil) {
		featureChangesObserversPool.removeObserver(observer, featureNames: featureNames)
	}
}

// MARK: - FeaturesManagerFeaturesListPresenterProtocol
extension FeaturesManager: FeaturesManagerFeaturesListPresenterProtocol {
    /// Presents the features list as modal in a new window.
    /// - parameter window: Window where to attach the features list. By default, it's a new window created on top of existing ones.
    /// - throws: SwiftyTogglerError.modalFeaturesListAlreadyPresented if there is already a modal features list.
	public func presentModalFeaturesList(in window: UIWindow = UIWindow(frame: UIScreen.main.bounds)) throws {
		try featuresListCoordinator.start(presentingMode: .modal(window))
	}

    /// Presents the features list inside a parent view controller.
    /// - parameter viewController: View controller where to present the features list.
    /// - parameter view: View where to present the features list. If nil, the features list will be added in the view controller's main view. By defeault, it's nil.
	public func presentFeaturesList(in viewController: UIViewController, view: UIView? = nil) {
		try? featuresListCoordinator.start(presentingMode: .inParent(viewController, view))
	}
}

extension FeaturesManager: FeaturesManagerTogglerProtocol {
    /// Enables/Disables a feature.
    /// - parameter isEnabled: New feature value. If `True` the feature will be enabled, if `False` it will be disabled. If the value is `True` and the feature is already enabled or if the value is `False` and the feature is already disabled, this function doesn't do anything.
    /// - parameter featureName: Feature name to update.
	public func setEnable(_ isEnabled: Bool, featureName: String) throws {
		var proxy = try findFeatureProxy(for: featureName)
		proxy.isFeatureEnable = isEnabled
		featureChangesObserversPool.notify(for: proxy.feature, featureName: featureName)
	}
}
