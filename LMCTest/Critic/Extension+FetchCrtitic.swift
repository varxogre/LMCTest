//
//  Extension+Fetch.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import Foundation

extension CriticsViewController: StorageUpdateProtocol {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        activityIndicator.stopAnimating()
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func onFetchFailed(with reason: String?) {
        activityIndicator.stopAnimating()
        if let reason = reason {
            showAlert(with: reason)
        }
    }   
}
