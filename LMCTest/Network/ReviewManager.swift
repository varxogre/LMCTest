//
//  ReviewModel.swift
//  LMCTest
//
//  Created by сергей on 02.02.2021.
//

import Foundation

struct ReviewManager {
    
    static func getReviewsByOffset(offset: Int, completion: @escaping (Result<ReviewInfo, Error>) -> Void) {
        NetworkService.shared.performRequestByURL(
            url: APIConstants.reviews + "&offset=" + String(offset)) {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                if let reviews: ReviewInfo = NetworkService.shared.decodeJSON(with: data) {
                    completion(.success(reviews))
                }
            }
        }
    }
    
    static func getReviewsBySearch(with query: String, completion: @escaping (Result<ReviewInfo, Error>) -> Void) {
        NetworkService.shared.performRequestByURL(
            url: APIConstants.reviewsQuery + "&query=" + query) {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                if let reviews: ReviewInfo = NetworkService.shared.decodeJSON(with: data) {
                    completion(.success(reviews))
                }
            }
        }
    }
    
}

// MARK: - Info
struct ReviewInfo: Codable {
    let status, copyright: String
    let hasMore: Bool
    let numResults: Int
    let results: [MovieModel]

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case hasMore = "has_more"
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result
struct MovieModel: Codable {
    let displayTitle, mpaaRating: String
    let criticsPick: Int
    let byline, headline, summaryShort, publicationDate: String
    let openingDate: String?
    let dateUpdated: String
    let link: Link
    let multimedia: Multimedia?

    enum CodingKeys: String, CodingKey {
        case displayTitle = "display_title"
        case mpaaRating = "mpaa_rating"
        case criticsPick = "critics_pick"
        case byline, headline
        case summaryShort = "summary_short"
        case publicationDate = "publication_date"
        case openingDate = "opening_date"
        case dateUpdated = "date_updated"
        case link, multimedia
    }
}

// MARK: - Link
struct Link: Codable {
    let type: TypeEnum
    let url: String
    let suggestedLinkText: String

    enum CodingKeys: String, CodingKey {
        case type, url
        case suggestedLinkText = "suggested_link_text"
    }
}

enum TypeEnum: String, Codable {
    case article = "article"
}

// MARK: - Multimedia
struct Multimedia: Codable {
    let type: String
    let src: String
    let height, width: Int
}

