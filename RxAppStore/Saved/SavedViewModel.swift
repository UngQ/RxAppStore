//
//  SavedViewModel.swift
//  RxAppStore
//
//  Created by ungQ on 4/8/24.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class SavedViewModel {

	let repository = AppRepository()

	var savedList: Results<AppDataRealmModel>!
	var observationToken: NotificationToken?

	let bag = DisposeBag()

	struct Input {



	}

	struct Output {

		let savedList: Driver<[AppResult]>

	}

	init() {
		savedList = repository.realm?.objects(AppDataRealmModel.self)
	}


	func transform(input: Input) -> Output {
		var list: [AppResult] = []
		let outputList = BehaviorRelay(value: list)

		observationToken = savedList.observe { changes in
			switch changes {
			case .initial(let collectionType):
				list = Array(self.savedList).map { $0.toStruct() }
				outputList.accept(list)
			case .update(let collectionType, let deletions, let insertions, let modifications):
				list = Array(self.savedList).map { $0.toStruct() }
				outputList.accept(list)
			case .error(let error):
				print("error")
			}
		}


		return Output(savedList: outputList.asDriver(onErrorJustReturn: []))
	}


}
