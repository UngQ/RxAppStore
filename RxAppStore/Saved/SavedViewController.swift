//
//  SavedViewController.swift
//  RxAppStore
//
//  Created by ungQ on 4/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SavedViewController: UIViewController {

	let savedTableView = UITableView()

	let viewModel = SavedViewModel()

	let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .systemMint


		configureLayout()

		bind()
    }

	func bind() {

		let input = SavedViewModel.Input()

		let output = viewModel.transform(input: input)

		output.savedList
			.drive(savedTableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)) {
				row, element, cell in

				cell.appNameLabel.text = element.trackCensoredName
				cell.downloadButton.rx.tap
					.bind(onNext: { _ in
						print("hI \(row)")
					})

					.disposed(by: cell.disposeBag)
			}
			.disposed(by: bag)

	}


	func configureLayout() {
		view.addSubview(savedTableView)

		savedTableView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}

		savedTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
		savedTableView.backgroundColor = .systemCyan
	}

}
