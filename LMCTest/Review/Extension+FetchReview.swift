//
//  Extension+CellPagination.swift
//  LMCTest
//
//  Created by сергей on 04.02.2021.
//

import Foundation

extension ReviewsViewController: StorageUpdateProtocol {
    
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
    
    func onFetchFailed(with reason: String?) {
        activityIndicator.stopAnimating()
        if let reason = reason {
        showAlert(with: reason)
        }
    }
    
}
