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
}



final class ReviewsStorage {
    
    weak var delegate: ReviewsStorageUpdateProtocol?
    var offset = 0
    var searchingOffset = 0
    var hasMore = false
    var isSearching = false
    var hasSearching = false
    var query: String?
    var reviews: [Review] = [] 
    var searchedReviews: [Review] = []
    
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
                    guard reviewData.numResults > 0 else {
                        self.delegate?.onFetchFailed(with: "К сожалению, по вашему запросу ничего не найдено...")
                        return
                    }
                    self.reviews.append(contentsOf: reviewData.results!)
                    if reviewData.hasMore {
                        self.offset += 20
                        if self.hasMore {
                            let indexPathsToReload = self.delegate?.calculateIndexPathsToReload(from: reviewData.results!)
                            self.delegate?.onFetchCompleted(with: indexPathsToReload)
                            print("onFetchCompleted(with indexPath)")
                        } else {
                            self.delegate?.onFetchCompleted(with: nil)
                            print("onFetchCompleted(withNil)")
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
                    guard reviewData.numResults > 0 else {
                        self.delegate?.onFetchFailed(with: "К сожалению, по вашему запросу ничего не найдено...")
                        return
                    }
                    self.searchedReviews.append(contentsOf: reviewData.results!)
                    print("searchedData was added")
                    if self.isSearching, self.hasSearching {
                        print("onFetchCompleted(with indexPath)")
//                        self.temp = 0
                        let indexPathsToReload = self.delegate?.calculateIndexPathsToReload(from: reviewData.results!)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.isSearching = true
                        print("onFetchCompleted(withNil)")
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

