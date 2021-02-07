//
//  APIConstants.swift
//  LMCTest
//
//  Created by сергей on 01.02.2021.
//

import Foundation


enum APIConstants {
    static let apiKey = "api-key=trK8WVXQHLYqHovSH6Djd1WeQNwEXPpF"
    static let baseURL = "https://api.nytimes.com/svc/movies/v2/"
    static let reviews = baseURL + "reviews/all.json?" + apiKey
    static let reviewsQuery = baseURL + "reviews/search.json?" + apiKey
    static let critics = baseURL + "critics/all.json?" + apiKey
}





