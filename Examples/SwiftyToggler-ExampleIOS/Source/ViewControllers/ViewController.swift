//
//  ViewController.swift
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

import UIKit
import SwiftyToggler

class ViewController: UIViewController {

	@IBAction func showFeaturestListButtonDidTap(_ sender: Any) {
		do {
			try FeaturesManager.shared.presentModalFeaturesList(in: UIWindow())
		} catch {
			print(error.localizedDescription)
		}
	}

	@IBAction func loadFeaturesButtonDidTap(_ sender: Any) {
		addTabBarFeature()
	}

	@IBAction func LoadEnableAllFeaturesButtonDidTap(_ sender: Any) {
		addTabBarFeature()
		try? FeaturesManager.shared.setEnable(true, featureName: CreditsFeature.name)
	}

	private func addTabBarFeature() {
        guard let navigationController = navigationController else { return }
        let tabBarFeaturePayload = CreditsFeaturePayload(navigationController: navigationController, navigationItem: navigationItem)
		let tabBarFeature = CreditsFeature(payload: tabBarFeaturePayload)
		FeaturesManager.shared.add(feature: tabBarFeature, name: CreditsFeature.name, shouldRunWhenEnabled: true)

		do {
			try FeaturesManager.shared.update(featureName: "MyFeature", shouldRunWhenEnabled: true)
		} catch SwiftyTogglerError.featureNotFound {
			print("Feature not found")
		} catch {}
	}

	@IBAction func removeFeaturesButtonDidTap(_ sender: Any) {
		FeaturesManager.shared.removeAll()
	}
}
