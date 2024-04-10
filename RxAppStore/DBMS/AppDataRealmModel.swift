//
//  AppDataRealmModel.swift
//  RxAppStore
//
//  Created by ungQ on 4/8/24.
//

import Foundation
import RealmSwift

final class AppDataRealmModel: Object {

	@Persisted(primaryKey: true) var bundleId: String

	@Persisted var artworkUrl512: String
	@Persisted var firstScreenshotUrl: String
	@Persisted var secondScreenshotUrl: String

	@Persisted var overview: String

	@Persisted var sellerName: String
	@Persisted var trackCensoredName: String

	convenience init(bundleId: String,
					 artworkUrl512: String,
					 firstScreenshotUrl: String,
					 secondScreenshotUrl: String,
					 overview: String,
					 sellerName: String,
					 trackCensoredName: String) {
		self.init()
		self.bundleId = bundleId
		self.artworkUrl512 = artworkUrl512
		self.firstScreenshotUrl = firstScreenshotUrl
		self.secondScreenshotUrl = secondScreenshotUrl
		self.overview = overview
		self.sellerName = sellerName
		self.trackCensoredName = trackCensoredName

	}
}

extension AppDataRealmModel {
	func toStruct() -> AppResult {
		return AppResult(artworkUrl512: URL(string: self.artworkUrl512)!,
						 screenshotUrls: [URL(string:self.firstScreenshotUrl)!, URL(string:self.secondScreenshotUrl)!],
						 description: self.description,
						 bundleId: self.bundleId,
						 sellerName: self.sellerName,
						 trackCensoredName: self.trackCensoredName)
	}
}
