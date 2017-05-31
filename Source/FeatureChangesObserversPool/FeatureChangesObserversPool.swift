//
//  FeatureChangesObserversPool.swift
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

final class FeatureChangesObserversPool: FeatureChangesObserversPoolProtocol {

	private struct Constants {
		static let allFeaturesKey = "*"
	}

    private var observersPool = [String: Set<FeatureChangesObserversPoolWeakElement>]()

    func addObserver(_ observer: FeatureChangesObserver, featureNames: [String]?) {
		let featureNames = featureNames ?? [Constants.allFeaturesKey]
        featureNames.forEach { (featureName) in
            var observers = observersPool[featureName] ?? []
            let weakRef = FeatureChangesObserversPoolWeakElement(value: observer)
            observers.insert(weakRef)
            observersPool[featureName] = observers
        }
    }
    
    func removeObserver(_ observer: FeatureChangesObserver, featureNames: [String]?) {
        let featuresToDelete = featureNames ?? Array(observersPool.keys)
        featuresToDelete.forEach { (featureName) in
            guard var observers = observersPool[featureName] else { return }
            observers = remove(observer: observer, in: observers)
            if observers.isEmpty == true {
                observersPool.removeValue(forKey: featureName)
            } else {
                observersPool[featureName] = observers
            }
        }
    }
    
    private func remove(observer: FeatureChangesObserver, in observers: Set<FeatureChangesObserversPoolWeakElement>) -> Set<FeatureChangesObserversPoolWeakElement> {
        guard let observerFound = observers.first(where: { $0.value === observer }) else { return observers }
        var newObservers = observers
        newObservers.remove(observerFound)
        return newObservers
    }
    
    func notify(for feature: FeatureProtocol, featureName: String) {
		var observers = observersPool[featureName] ?? nil
		if let observersAllFeatures = observersPool[Constants.allFeaturesKey] {
			observers = observers != nil ? observers?.union(observersAllFeatures) : observersAllFeatures
		}
		observers?.forEach { $0.value?.featureDidChange(name: featureName, isEnabled: feature.isEnabled) }
    }
}
