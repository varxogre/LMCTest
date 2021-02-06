//
//  Extension+FetchR.swift
//  LMCTest
//
//  Created by сергей on 06.02.2021.
//

import Foundation

extension DetailCriticController: DetailStorageUpdateProtocol {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
            return indexPath.row >= model.reviews.count - 1
    }
    
    func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath] {
            let startIndex = model.reviews.count - newReviews.count
            let endIndex = startIndex + newReviews.count
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 1) }
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        print("onFetch")
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
        activityIndicator.stopAnimating()
        print(reason)
    }
}
