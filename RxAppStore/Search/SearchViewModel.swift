//
//  SearchViewModel.swift
//  RxMusic
//
//  Created by ungQ on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {

	let repository = AppRepository()

	let savedHistoryIdentifier = "history"

	var savedHistoryList: [String] = []
	let bag = DisposeBag()

	struct Input {
		let searchBarText: ControlProperty<String>
		let searchButtonClicked: ControlEvent<Void>
		let searchBarClicked: ControlEvent<Void>
		let searchBarCancleButtonClicked: ControlEvent<Void>
		let allDeleteButtonClicked: ControlEvent<Void>
	}

	struct Output {

		let searchHistoryList: PublishSubject<[String]>
		let resultList: PublishSubject<[AppResult]>
	}

	func transform(input: Input) -> Output {
		print(#function)

		let searchHistoryList = PublishSubject<[String]>()
		let resultList = PublishSubject<[AppResult]>()

		//서치바 진입시 검색 기록 바인딩
		input.searchBarClicked
			.subscribe(with: self) { owner, _ in
				if let savedList = UserDefaults.standard.object(forKey: owner.savedHistoryIdentifier) as? [String] {
					owner.savedHistoryList = savedList
					searchHistoryList.onNext(savedList)

				}
			}
			.disposed(by: bag)

		//검색 기록 모두 삭제 바인딩
		input.allDeleteButtonClicked
			.subscribe(with: self) { owner, _ in
				owner.savedHistoryList.removeAll()
				UserDefaults.standard.setValue(owner.savedHistoryList, forKey: owner.savedHistoryIdentifier)
				print(owner.savedHistoryList)
				searchHistoryList.onNext(owner.savedHistoryList)
			}
			.disposed(by: bag)


		//서치바 검색시, 네트워크 연결 바인딩
		input.searchButtonClicked
			.withLatestFrom(input.searchBarText)
			.flatMap { iTunesNetwork.fetchAppStoreData(text: $0 ) }
			.subscribe(with: self) { owner, value in
				resultList.onNext(value.results)
			}
			.disposed(by: bag)

		//서치바 검색시, 검색 기록 추가 바인딩
		input.searchButtonClicked
			.withLatestFrom(input.searchBarText)
			.subscribe(with: self) { owner, value in

				print(owner.savedHistoryList)
				owner.savedHistoryList.insert(value, at: 0)
				UserDefaults.standard.setValue(owner.savedHistoryList, forKey: owner.savedHistoryIdentifier)
				print(owner.savedHistoryList)
				searchHistoryList.onNext(owner.savedHistoryList)

			}
			.disposed(by: bag)

		//서치바 취소 버튼 클릭시, 테이블뷰 비우기 바인딩
		input.searchBarCancleButtonClicked
			.subscribe(with: self) { owner, _ in
				let result: [AppResult] = []
				resultList.onNext(result)
			}
			.disposed(by: bag)




		return Output(searchHistoryList: searchHistoryList,
					  resultList: resultList)
	}


}
