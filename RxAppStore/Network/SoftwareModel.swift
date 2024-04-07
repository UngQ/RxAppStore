//
//  SoftwareModel.swift
//  RxMusic
//
//  Created by ungQ on 4/7/24.
//

import Foundation

struct AppStoreResponse: Codable {
	var resultCount: Int
	var results: [AppResult]
}

struct AppResult: Codable {
	var artworkUrl512: URL
	var screenshotUrls: [URL]
////	var currency: String
//	var primaryGenreName: String
//	var primaryGenreId: Int
//	var minimumOsVersion: String
//	var fileSizeBytes: String
//	var sellerUrl: URL
//	var formattedPrice: String
//	var trackContentRating: String
//	var releaseNotes: String
//	var artistId: Int
//	var artistName: String
//	var genres: [String]
//	var price: Double
	var description: String
//	var genreIds: [String]
//	var bundleId: String
//	var releaseDate: Date
//	var sellerName: String
//	var currentVersionReleaseDate: Date
//	var trackId: Int
//	var trackName: String
////	var averageUserRating: Double
	var trackCensoredName: String
	var trackViewUrl: URL
//	var contentAdvisoryRating: String
//	var version: String
//	var wrapperType: String
//	var userRatingCount: Int
}
