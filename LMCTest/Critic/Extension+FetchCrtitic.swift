//
//  Extension+Fetch.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import Foundation

extension CriticsViewController: CriticsStorageUpdateProtocol {
    
    func onFetchCompleted() {
        activityIndicator.stopAnimating()
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func onFetchFailed(with reason: String) {
        print(reason)
        activityIndicator.stopAnimating()
    }
    
    
}
