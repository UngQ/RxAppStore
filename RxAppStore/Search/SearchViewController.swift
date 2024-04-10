//
//  SearchViewController.swift
//  RxMusic
//
//  Created by ungQ on 4/7/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {



	let viewModel = SearchViewModel()

	let resultTableView = UITableView()
	let historyView = UIView()
	let historyVC = SearchHistoryViewController()

	let bag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		configureNavigationBar()
		configureLayout()

		bind()
    }

	func bind() {
		//서치바 클릭시 히스토리 뷰 활성화 바인드
//		navigationItem.searchController?.searchBar.rx
//			.textDidBeginEditing
//			.bind(with: self, onNext: { owner, _ in
//				print("searchbar clikk")
//				owner.historyView.isHidden = false
//			})
//			.disposed(by: bag)
		//서치바 벗어나면 히스토리 뷰 비활성화 바인드
		navigationItem.searchController?.searchBar.rx
			.textDidEndEditing
			.bind(with: self, onNext: { owner, _ in
				owner.historyView.isHidden = true
			})
			.disposed(by: bag)

		resultTableView.rx.rowHeight
			.onNext(80)

		navigationItem.searchController?.searchBar.delegate = self


		//
		guard let searchBarText = navigationItem.searchController?.searchBar.rx.text.orEmpty else { return }
		guard let searchButtonClicked = navigationItem.searchController?.searchBar.rx.searchButtonClicked else { return }
		guard let searchBarClicked = navigationItem.searchController?.searchBar.rx.textDidBeginEditing else { return }
		guard let searchBarCancelButtonClicked = navigationItem.searchController?.searchBar.rx.cancelButtonClicked else { return }

		let searchTextObservable = Observable.merge(searchBarText.asObservable(),
													historyVC.historyTableView.rx
			.modelSelected(String.self)
			.map{ $0 })

		let searchTrigger = Observable.merge(searchButtonClicked.asObservable(),
											 historyVC.historyTableView.rx.modelSelected(String.self).map { _ in })

		let input = SearchViewModel.Input(searchBarText: searchTextObservable,
										  searchTrigger: searchTrigger,
										  searchBarClicked: searchBarClicked,
										  searchBarCancleButtonClicked: searchBarCancelButtonClicked,
										  allDeleteButtonClicked: historyVC.allDeleteButton.rx.tap)


		let output = viewModel.transform(input: input)

		searchTrigger.bind(with: self) { owner, _ in
			owner.historyView.isHidden = true
		}
		.disposed(by: bag)

		output.searchBarText
			.drive(with: self) { owner, value in
				owner.navigationItem.searchController?.searchBar.text = value
			}
			.disposed(by: bag)

		output.resultList.bind(to:
			resultTableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self) ) {
				row, element, cell in

			cell.appIconImageView.kf.setImage(with: element.artworkUrl512)
			cell.appNameLabel.text = element.trackCensoredName
			cell.downloadButton.rx.tap
				.subscribe(with: self) { owner, _ in
					owner.viewModel.repository.addAppData(element)
				}
				.disposed(by: cell.disposeBag)

		}
			.disposed(by: bag)


		output.searchHistoryList.bind(to: historyVC.historyTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
			row, element, cell in

			cell.textLabel?.text = element


		}
		.disposed(by: bag)

//		historyVC.historyTableView.rx.modelSelected(String.self)
//			.subscribe(with: self, onNext: { owner, value in
//				print(value)
//				input.searchBarText.onNext(value)
//
//				owner.historyView.isHidden.toggle()
//			})
//
//			.disposed(by: bag)


		resultTableView.rx.modelSelected(AppResult.self)
			.subscribe(with: self) { owner, data in
				let vc = DetailInfoViewController()
				vc.result = data

				owner.navigationController?.pushViewController(vc, animated: true)
			}
			.disposed(by: bag)

	}

	private func configureNavigationBar() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = ""
		searchController.searchBar.showsScopeBar = true

//		searchController.searchBar.delegate = self
		self.navigationItem.searchController = searchController

		navigationItem.hidesSearchBarWhenScrolling = false

		let titleLabel = UILabel()
		let titleView = UIView()
		titleView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		titleLabel.text = "검색"
		titleLabel.textAlignment = .left
		titleLabel.font = .boldSystemFont(ofSize: 20)

		self.navigationItem.titleView = titleView

	}

	private func configureLayout() {
		view.addSubview(resultTableView)
		view.addSubview(historyView)
		historyView.addSubview(historyVC.view)
		historyView.isHidden = true

		resultTableView.backgroundColor = .systemGreen
		resultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)

		resultTableView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
		historyView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}

		historyVC.view.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

	}




}


extension SearchViewController: UISearchBarDelegate {

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.historyView.isHidden = false
	}
}
