//
//  Extension+FetchR.swift
//  LMCTest
//
//  Created by сергей on 06.02.2021.
//

import Foundation

extension DetailCriticController: StorageUpdateProtocol {
    
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
    }
}
