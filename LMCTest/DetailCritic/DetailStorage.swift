//
//  DetailStorage.swift
//  LMCTest
//
//  Created by сергей on 06.02.2021.
//

import Foundation

protocol DetailStorageUpdateProtocol: class {
    func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath]
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class DetailStorage {
    weak var delegate: DetailStorageUpdateProtocol?
    var offset = 0
    var hasMore = true
    var isFirstRequest = true
    var query: String = "Renata%20Adler"
    var reviews: [Review] = []
    var critic: Critic?
    
    
    func fetchReviews() {
        guard hasMore else { return }
        ReviewManager.getReviewsByReviewer(with: query, offset: offset) { [weak self] (result) in
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
                    if self.isFirstRequest {
                        self.reviews.removeAll()
                    }
                    self.reviews.append(contentsOf: reviewData.results!) 
                    if self.hasMore, !self.isFirstRequest {
                        let indexPathsToReload = self.delegate?.calculateIndexPathsToReload(from: reviewData.results!)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        print("onFetchCompleted(with indexPath)")
                    } else {
                        self.delegate?.onFetchCompleted(with: nil)
                        print("onFetchCompleted(withNil)")
                    }
                    if reviewData.hasMore {
                        self.offset += 20
                    }
                    self.isFirstRequest = false
                    self.hasMore = reviewData.hasMore
                }
            }
        }
    }
    
    
}

