//
//  FeaturesListCoordinator.swift
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

protocol FeaturesListCoordinatorProtocol {
	func start(presentingMode: PresentingMode) throws
}

final class FeaturesListCoordinator: FeaturesListCoordinatorProtocol {

	fileprivate(set) var window: UIWindowProtocol?

	func start(presentingMode: PresentingMode) throws {
		switch presentingMode {
		case .modal(let parentWindow):
			try presentModal(in: parentWindow)
		case .inParent(let parentViewController, let parentView):
			presentIn(parentViewController, parentView: parentView)
		}
	}

	private func presentModal(in parentWindow: UIWindowProtocol) throws {
		guard self.window == nil else {
			throw SwiftyTogglerError.modalFeaturesListAlreadyPresented
		}
		parentWindow.rootViewControllerType = createFeaturestListViewController(presentingMode: .modal(parentWindow))
        parentWindow.makeKeyAndVisible()
        parentWindow.backgroundColor = .white
		self.window = parentWindow
	}

	private func createFeaturestListViewController(presentingMode: PresentingMode) -> FeaturesListViewController {
		let viewModel = FeaturesListViewModel(presentingMode: presentingMode)
		viewModel.delegate = self
		return FeaturesListViewController(viewModel: viewModel)
	}

	private func presentIn(_ parentViewController: UIViewControllerProtocol, parentView: UIViewProtocol?) {
        let viewController = createFeaturestListViewController(presentingMode: .inParent(parentViewController, parentView))
        parentViewController.addFillerChildViewController(viewController, toView: parentView)
	}
}

extension FeaturesListCoordinator: FeaturesListViewModelDelegate {
	func featuresListViewModelNeedsClose() {
		destroyWindow()
	}

	private func destroyWindow() {
		window?.isHidden = true
		window?.rootViewControllerType = nil
		window = nil
	}
}
