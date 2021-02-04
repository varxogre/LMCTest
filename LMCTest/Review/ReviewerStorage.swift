//
//  ReviewerStorage.swift
//  LMCTest
//
//  Created by сергей on 03.02.2021.
//

import Foundation

protocol ReviewsStorageUpdateProtocol: class {
    func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath]
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
    func updateTable()
}



class ReviewsStorage {
    
    weak var delegate: ReviewsStorageUpdateProtocol?
    var temp = 0
    var offset = 0
    var searchingOffset = 0
    var hasMore = false
    var isSearching = false
    var query: String? {
        didSet {
            print(query)
        }
    }
    var reviews: [Review] = [] {
        didSet {
            print("reviews count: \(reviews.count)")
        }
    }
    var searchedReviews: [Review] = [] {
        didSet {
            print("searchingReviews count: \(searchedReviews.count)")
        }
    }
    
    func fetchReviews() {
        ReviewManager.getReviewsByOffset(offset: offset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            case .success(let reviewData):
                DispatchQueue.main.async {
                    self.reviews.append(contentsOf: reviewData.results)
                    if reviewData.hasMore {
                        self.offset += 20
                        if self.hasMore {
                            let indexPathsToReload = self.delegate?.calculateIndexPathsToReload(from: reviewData.results)
                            self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        } else {
                            self.delegate?.onFetchCompleted(with: nil)
                        }
                    }
                    self.hasMore = reviewData.hasMore
                }
            }
        }
    }
    
    func searchReviews() {
        ReviewManager.getReviewsBySearch(with: query!, offset: searchingOffset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            case .success(let reviewData):
                DispatchQueue.main.async {
                    self.searchedReviews.append(contentsOf: reviewData.results)
                    print("searchedData was added")
                    if self.isSearching, self.temp == self.searchedReviews.count {
                            let indexPathsToReload = self.delegate?.calculateIndexPathsToReload(from: reviewData.results)
                            self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        } else {
                            self.isSearching = true
                            self.delegate?.onFetchCompleted(with: nil)
                        }
                    if reviewData.hasMore {
                        self.searchingOffset += 20
                    }
                }
            }
        }
    }
    
    
}

