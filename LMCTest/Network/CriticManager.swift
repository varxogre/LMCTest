//
//  Critic.swift
//  LMCTest
//
//  Created by сергей on 02.02.2021.
//

import Foundation

struct CriticManager {
    
    static func getCritics(completion: @escaping (Result<CriticsInfo, Error>) -> Void) {
        NetworkService.shared.performRequestByURL(
            url: APIConstants.critics) {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                if let critics: CriticsInfo = NetworkService.shared.decodeJSON(with: data) {
                    completion(.success(critics))
                }
            }
        }
    }
    

    // TO-DO: searchFunc
    
}

// MARK: - CriticsInfo
struct CriticsInfo: Codable {
    let status, copyright: String
    let numResults: Int
    let results: [Critic]

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result
struct Critic: Codable {
    let displayName, sortName: String
    let status: Status
    let bio, seoName: String
    let multimedia: Media?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case sortName = "sort_name"
        case status, bio
        case seoName = "seo_name"
        case multimedia
    }
}

// MARK: - Multimedia
struct Media: Codable {
    let resource: Resource
}

// MARK: - Resource
struct Resource: Codable {
    let type: String
    let src: String
    let height, width: Int
    let credit: String
}

enum Status: String, Codable {
    case empty = ""
    case fullTime = "full-time"
    case partTime = "part-time"
}
