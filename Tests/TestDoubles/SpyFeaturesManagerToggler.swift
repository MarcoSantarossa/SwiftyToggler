//
//  SpyFeaturesManagerToggler.swift
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

class SpyFeaturesManagerToggler: FeaturesManagerTogglerProtocol {

	var forceTwoFeatures = false

	private(set) var isSetEnableCall = false
	private(set) var setEnableIsEnableAgument: Bool?
	private(set) var setEnableFeatureNameAgument: String?

	var featuresStatus: [FeatureStatus] {
		guard forceTwoFeatures else { return [] }

		return [
			FeatureStatus(name: "F1", isEnabled: false),
			FeatureStatus(name: "F2", isEnabled: true)
		]
	}

	func isEnabled(featureName: String) throws -> Bool {
		return true
	}

	func setEnable(_ isEnabled: Bool, featureName: String) throws {
		isSetEnableCall = true
		setEnableIsEnableAgument = isEnabled
		setEnableFeatureNameAgument = featureName
	}
}
