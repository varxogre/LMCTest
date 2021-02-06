//
//  APIConstants.swift
//  LMCTest
//
//  Created by сергей on 01.02.2021.
//

import Foundation

let apiKey = "api-key=trK8WVXQHLYqHovSH6Djd1WeQNwEXPpF"
let baseURL = "https://api.nytimes.com/svc/movies/v2/"

enum APIConstants: Hashable {
    static let reviews = baseURL + "reviews/all.json?" + apiKey
    static let reviewsQuery = baseURL + "reviews/search.json?" + apiKey
    static let critics = baseURL + "critics/all.json?" + apiKey
}




