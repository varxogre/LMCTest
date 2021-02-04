//
//  Extension+CellPagination.swift
//  LMCTest
//
//  Created by сергей on 04.02.2021.
//

import Foundation

extension ReviewsViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if model.isSearching {
            return indexPath.row >= model.searchedReviews.count - 1
        } else {
            return indexPath.row >= model.reviews.count - 1
        }
    }
    
    func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath] {
        if model.isSearching {
            let startIndex = model.searchedReviews.count - newReviews.count
            print("startIndex: \(startIndex)")
            let endIndex = startIndex + newReviews.count
            print("endIndex: \(endIndex)")
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        } else {
            let startIndex = model.reviews.count - newReviews.count
            let endIndex = startIndex + newReviews.count
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        }
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        activityIndicator.stopAnimating()
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            refreshControl.endRefreshing()
            tableView.reloadData()
            return
        }
        
        refreshControl.endRefreshing()
        tableView.beginUpdates()
        tableView.insertRows(at: newIndexPathsToReload, with: .automatic)
        tableView.endUpdates()
    }
    
    func onFetchFailed(with reason: String) {
        // TO-DO: alert controller with error
    }
    
    func freeModel() {
        model.temp = model.searchedReviews.count
        model.searchingOffset = 0
        model.searchedReviews.removeAll()
    }
    
}
