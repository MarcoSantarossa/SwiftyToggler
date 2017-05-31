//
//  SpyFeatureChangesObserversPool.swift
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

@testable import SwiftyToggler

class SpyFeatureChangesObserversPool: FeatureChangesObserversPoolProtocol {

	private(set) var isAddObserverCalled = false
	private(set) var isRemoveObserverCalled = false
	private(set) var isNotifyCalled = false

	private(set) var addObserverArgumentObserver: FeatureChangesObserver?
	private(set) var addObserverArgumentFeatureNames: [String]?

	private(set) var removeObserverArgumentObserver: FeatureChangesObserver?
	private(set) var removeObserverArgumentFeatureNames: [String]?

	private(set) var notifyArgumentFeature: FeatureProtocol?
	private(set) var notifyArgumentFeatureName: String?

	func addObserver(_ observer: FeatureChangesObserver, featureNames: [String]?) {
		isAddObserverCalled = true
		addObserverArgumentObserver = observer
		addObserverArgumentFeatureNames = featureNames
	}

	func removeObserver(_ observer: FeatureChangesObserver, featureNames: [String]?) {
		isRemoveObserverCalled = true
		removeObserverArgumentObserver = observer
		removeObserverArgumentFeatureNames = featureNames
	}

	func notify(for feature: FeatureProtocol, featureName: String) {
		isNotifyCalled = true
		notifyArgumentFeature = feature
		notifyArgumentFeatureName = featureName
	}
}
