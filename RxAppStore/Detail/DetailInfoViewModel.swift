//
//  DetailInfoViewModel.swift
//  RxAppStore
//
//  Created by ungQ on 4/8/24.
//

import Foundation
import RxSwift
import RxCocoa



class DetailInfoViewModel {


	struct Input {
		let data: BehaviorSubject<AppResult>
	}

	struct Output {
		let data: BehaviorSubject<AppResult>

	}

	func transform(input: Input) -> Output {
//		input.data
//
//
//		let data = PublishSubject<AppResult>()
//
//			data.onNext(result)






		return Output(data: input.data)
	}



}


