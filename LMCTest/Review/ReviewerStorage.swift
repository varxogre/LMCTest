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
    func onFetchFailed(with reason: String?)
}



final class ReviewsStorage {
    
    weak var delegate: ReviewsStorageUpdateProtocol?
    var offset = 0
    var searchingOffset = 0
    var hasMore = true
    var searchHasMore = true
    var isSearching = false {
        didSet {
            print("isSearching:\(isSearching)")
        }
    }
    var hasSearching = false {
        didSet {
            print("hasSearching: \(hasSearching)")
        }
    }
    var isFiltering = false {
        didSet {
            print("isFiltering:\(isFiltering)")
        }
    }
    let today: String = Date().customizeDate()
    var query: String?
    var reviews: [Review] = []
    var searchedReviews: [Review] = []
    var filteredByDate: [Review] = []
    
    func fetchReviews() {
        guard hasMore else { return }
        ReviewManager.getReviewsByOffset(offset: offset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                    print(error.localizedDescription)
            case .success(let reviewData):
                DispatchQueue.main.async {
                    guard reviewData.numResults > 0 else {
                        self.delegate?.onFetchFailed(with: "Что-то пошло не так, попробуйте ещё раз.")
                        return
                    }
                    self.reviews.append(contentsOf: reviewData.results!)
                    if self.hasMore {
                        let indexPathsToReload = self.delegate?.calculateIndexPathsToReload(from: reviewData.results!)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: nil)
                    }
                    if reviewData.hasMore {
                        self.offset += 20
                    }
                    self.hasMore = reviewData.hasMore
                }
            }
        }
    }
    
    func searchReviews() {
        guard searchHasMore else { return }
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
                    if !self.hasSearching {
                        self.searchedReviews.removeAll()
                    }
                    self.searchedReviews.append(contentsOf: reviewData.results!)
                    if self.isSearching, self.hasSearching {
                        let indexPathsToReload = self.delegate?.calculateIndexPathsToReload(from: reviewData.results!)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.isSearching = true
                        self.hasSearching = true
                        self.delegate?.onFetchCompleted(with: nil)
                    }
                    if reviewData.hasMore {
                        self.searchingOffset += 20
                    }
                    self.searchHasMore = reviewData.hasMore
                }
            }
        }
    }
    
    func freeModel() {
        searchingOffset = 0
        searchHasMore = true
        hasSearching = false
        isFiltering = false
    }
    
    func filterDates(by currentDate: String) {
        isFiltering = true
        let currentFilter = isSearching ? searchedReviews : reviews
        guard currentDate <= today else {
            filteredByDate.removeAll()
            delegate?.onFetchCompleted(with: nil)
            return
        }
        guard currentDate >= currentFilter.last!.publicationDate else {
            filteredByDate.removeAll()
            delegate?.onFetchCompleted(with: nil)
            return
        }
        filteredByDate.removeAll()
        for review in currentFilter {
            if review.publicationDate <= currentDate {
                filteredByDate.append(review)
            }
        }
        if filteredByDate.count > 0 {
                delegate?.onFetchCompleted(with: nil)
        } else {
            freeModel()
            self.delegate?.onFetchCompleted(with: nil)
        }
    }
    
    
}

