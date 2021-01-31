//
//  BaseResult.swift
//  CleaniTunes
//
//  Created by hager gamal on 1/30/21.
//

import Foundation

// MARK: - Result
struct Result: Codable {
    let wrapperType: WrapperType?
    let kind: Kind?
    let artistID, trackID: Int?
    let artistName, trackName, trackCensoredName: String?
    let artistViewURL, trackViewURL: String?
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let releaseDate: Date?
    let trackTimeMillis: Int?
    let country: Country?
    let currency: Currency?
    let primaryGenreName: String?
    let collectionName: String?
    let longDescription: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case trackID = "trackId"
        case artistName, trackName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, trackTimeMillis, country, currency, primaryGenreName, collectionName, longDescription
    }
}

enum Country: String, Codable {
    case usa = "USA"
}

enum Currency: String, Codable {
    case usd = "USD"
}

enum Kind: String, Codable {
    case musicVideo = "music-video"
    case featureMovie = "feature-movie"
    case podcast = "podcast"
    var displayKind: String {
        switch self {
        case .musicVideo:
            return "Music Video"
        case .featureMovie:
            return "Movie"
        case .podcast:
            return "Podcast"
        }
    }
}

enum PrimaryGenreName: String, Codable {
    case childrenSMusic = "Children's Music"
    case dance = "Dance"
    case pop = "Pop"
    case rBSoul = "R&B/Soul"
}

enum WrapperType: String, Codable {
    case track = "track"
    case album = "collection"
    case book = "audiobook"
    
    var displayType: String {
        switch self {
        case .track:
            return "Track"
        case .album:
            return "Album"
        case .book:
            return "Book"
        }
    }
}
