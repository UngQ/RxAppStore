//
//  Network.swift
//  RxMusic
//
//  Created by ungQ on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
	case invalidURL
	case unknownResponse
	case statusError
}

class iTunesNetwork {

	static func fetchAppStoreData(text: String) -> Observable<AppStoreResponse> {

		return Observable.create { observer in
			guard let url = URL(string: "https://itunes.apple.com/search?term=\(text)&country=KR&media=software") else {

				observer.onError(APIError.invalidURL)
				return Disposables.create()
			}
//			var urlRequest = URLRequest(url: url)
//			urlRequest.setValue("ungq", forHTTPHeaderField: "User-Agent")

			URLSession.shared.dataTask(with: url) { data, response, error in

				print("DataTask Succeed")

				if let _ = error {
					print("Error")
					observer.onError(APIError.unknownResponse)
					return
				}

				guard let response = response as? HTTPURLResponse,
					  (200...299).contains(response.statusCode) else {
					print("Response Error")
					observer.onError(APIError.statusError)
					return
				}

				print("여기")
				if let data = data,
				   let appData = try? JSONDecoder().decode(AppStoreResponse.self, from: data) {
					print(appData.resultCount)
					observer.onNext(appData)
				} else {
					print("에러?")
					observer.onError(APIError.unknownResponse)
				}
			}.resume()

			return Disposables.create()
		}
	}
}
