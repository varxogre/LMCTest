//
//  DetailStorage.swift
//  LMCTest
//
//  Created by сергей on 06.02.2021.
//

import Foundation

final class DetailStorage {
    weak var delegate: StorageUpdateProtocol?
    var offset = 0
    var hasMore = true
    var isFirstRequest = true
    var query: String?
    var reviews: [Review] = []
    
    
    func fetchReviews() {
        guard hasMore else { return }
        ReviewManager.getReviewsByReviewer(with: query!, offset: offset) { [weak self] (result) in
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
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: reviewData.results!)
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
    
    func prepareModelForRefresh() {
        offset = 0
        hasMore = true
        isFirstRequest = true
        fetchReviews()
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= reviews.count - 1
    }
    
    private func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath] {
        let startIndex = reviews.count - newReviews.count
        let endIndex = startIndex + newReviews.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 1) }
    }
    
    
}

