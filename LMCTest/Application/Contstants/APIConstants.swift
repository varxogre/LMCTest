//
//  APIConstants.swift
//  LMCTest
//
//  Created by сергей on 01.02.2021.
//

import Foundation
//"https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=ferdinand&api-key=trK8WVXQHLYqHovSH6Djd1WeQNwEXPpF"
let apiKey = "api-key=trK8WVXQHLYqHovSH6Djd1WeQNwEXPpF"
let baseURL = "https://api.nytimes.com/svc/movies/v2/"

/// https://api.nytimes.com/svc/movies/v2/critics/{reviewer}.json? all or reviewerName
// https://api.nytimes.com/svc/movies/v2/reviews/all.json?
// https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=godfather&api-key=yourkey query
enum APIConstants: Hashable {
    static let reviews = baseURL + "reviews/all.json?" + apiKey
    static let reviewsQuery = baseURL + "reviews/search.json?" + apiKey
    static let critics = baseURL + "critics/all.json?" + apiKey
}




