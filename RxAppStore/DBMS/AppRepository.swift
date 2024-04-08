//
//  AppRepository.swift
//  RxAppStore
//
//  Created by ungQ on 4/8/24.
//

import Foundation
import RealmSwift

final class  AppRepository {


	var realm: Realm?

	init() {
		do {
			realm = try Realm()
		} catch {
			print(error)
		}
	}

	func addAppData(_ data: AppResult) {
		guard let realm = realm else { return }

		print(realm.configuration.fileURL)

		let artworkURL = String(describing: data.artworkUrl512)
		let firstScreenshot = String(describing: data.screenshotUrls[0])
		let secondScreenshot = String(describing: data.screenshotUrls[1])

		let item = AppDataRealmModel(bundleId: data.bundleId,
									 artworkUrl512: artworkURL,
									 firstScreenshotUrl: firstScreenshot,
									 secondScreenshotUrl: secondScreenshot,
									 overview: data.description,
									 sellerName: data.sellerName,
									 trackCensoredName: data.trackCensoredName
									 )

		do {
			try realm.write {
				realm.add(item, update: .modified)
			}
		} catch {
			print("Realm add error")
		}


	}


}
