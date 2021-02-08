//
//  ReviewerStorage.swift
//  LMCTest
//
//  Created by сергей on 03.02.2021.
//

import Foundation

protocol StorageUpdateProtocol: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String?)
}



final class ReviewsStorage {
    
    weak var delegate: StorageUpdateProtocol?
    var offset = 0
    var searchingOffset = 0
    var hasMore = true
    var searchHasMore = true
    var isSearching = false
    var hasSearched = false
    var isFiltering = false
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
                DispatchQueue.main.async {
                    if error  == .invalidResponse {
                        self.delegate?.onFetchFailed(with: "Слишком много запросов, попробуйте повторить через минуту.")
                    }
                }
            case .success(let reviewData):
                DispatchQueue.main.async {
                    guard reviewData.numResults > 0 else {
                        self.delegate?.onFetchFailed(with: "Что-то пошло не так, попробуйте ещё раз.")
                        return
                    }
                    self.reviews.append(contentsOf: reviewData.results!)
                    if self.hasMore {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: reviewData.results!)
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
            case .failure(_):
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailed(with:  "К сожалению, по вашему запросу ничего не найдено...")
                }
            case .success(let reviewData):
                DispatchQueue.main.async {
                    guard reviewData.numResults > 0 else {
                        self.delegate?.onFetchFailed(with: "К сожалению, по вашему запросу ничего не найдено...")
                        return
                    }
                    if !self.hasSearched {
                        self.searchedReviews.removeAll()
                    }
                    self.searchedReviews.append(contentsOf: reviewData.results!)
                    if self.isSearching, self.hasSearched {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: reviewData.results!)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.isSearching = true
                        self.hasSearched = true
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
    
    func prepareModelForRefresh() {
        searchingOffset = 0
        searchHasMore = true
        hasSearched = false
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
            prepareModelForRefresh()
            self.delegate?.onFetchCompleted(with: nil)
        }
    }
    
    func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath] {
        if isSearching {
            let startIndex = searchedReviews.count - newReviews.count
            let endIndex = startIndex + newReviews.count
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        } else {
            let startIndex = reviews.count - newReviews.count
            let endIndex = startIndex + newReviews.count
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if isFiltering {
            return indexPath.row >= filteredByDate.count - 1
        } else if isSearching {
            return indexPath.row >= searchedReviews.count - 1
        } else {
            return indexPath.row >= reviews.count - 1
        }
    }
    
}

