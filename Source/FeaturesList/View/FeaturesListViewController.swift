//
//  FeaturesListViewController.swift
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

class FeaturesListViewController: BaseViewController<FeaturesListViewModelUIBindingProtocol>, UITableViewDataSource {

	@IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableContainerView: UIView!
    @IBOutlet private var placeholderView: UIView!
	
	@IBOutlet private weak var closeButtonHeightConstraint: NSLayoutConstraint!
	@IBOutlet private weak var titleLabelHeightConstaint: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.accessibilityIdentifier = "features_list_table_view"

		registerTableCell()
		tableView.reloadData()

        updatePlaceholderVisibility()
		updateCloseButtonVisibility()
		updateTitleLabelVisibility()
	}

	private func registerTableCell() {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: String(describing: FeaturesListCell.self), bundle: bundle)
		tableView.register(nib, forCellReuseIdentifier: FeaturesListCell.cellIdentifier)
	}

    private func updatePlaceholderVisibility() {
        tableView.isHidden = viewModel.shouldShowPlaceholder
        if viewModel.shouldShowPlaceholder {
            tableContainerView.addFillerSubview(placeholderView)
        } else {
            placeholderView.removeFromSuperview()
        }
    }
    
	private func updateCloseButtonVisibility() {
		closeButtonHeightConstraint.constant = viewModel.closeButtonHeight
	}

	private func updateTitleLabelVisibility() {
		titleLabelHeightConstaint.constant = viewModel.titleLabelHeight
	}

	@IBAction private func closeButtonDidTap(_ sender: UIButton) {
		viewModel.closeButtonDidTap()
	}

	// MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.featuresCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FeaturesListCell.cellIdentifier, for: indexPath)

		if let featuresListCell = cell as? FeaturesListCell,
			let featureStatus = viewModel.featureStatus(at: indexPath) {
			configure(cell: featuresListCell, featureStatus: featureStatus)
		}

		return cell
	}

	private func configure(cell: FeaturesListCell, featureStatus: FeatureStatus) {
		let featureSwiftValueDidChangeClosure = { [unowned self] (name, isEnabled) in
			self.viewModel.updateFeature(name: name, isEnabled: isEnabled)
		}
		cell.configure(featureStatus: featureStatus,
					   featureSwiftValueDidChangeClosure: featureSwiftValueDidChangeClosure)
	}
}
