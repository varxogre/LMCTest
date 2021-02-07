//
//  NetworkService.swift
//  LMCTest
//
//  Created by сергей on 01.02.2021.
//

import Foundation

enum NetworkHandlerError: Error {
    case invalidURL
    case invalidResponse
    case apiError
    case decodingError
}

struct NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func performRequestByURL(url: String, completion: @escaping (Result<Data, NetworkHandlerError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        let urlSession = URLSession.shared
        urlSession.dataTask(with: url) {
            switch $0 {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                guard statusCode == 200 else {
                    if statusCode == 429 {
                        completion(.failure(.invalidResponse))
                    }
                    return
                }
                completion(.success(data))
            case .failure( _):
                completion(.failure(.apiError))
            }
        }.resume()
        
    }
    
    func decodeJSON<T: Decodable>(with data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            // TO-DO: handling error
            return nil
        }
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void)  -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
