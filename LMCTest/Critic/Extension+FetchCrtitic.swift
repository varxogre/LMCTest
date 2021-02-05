//
//  Extension+Fetch.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import Foundation

extension CriticsViewController: CriticsStorageUpdateProtocol {
    
    func calculateIndexPathsToReload(from newCritics: [Critic]) -> [IndexPath] {
        return [IndexPath()]
    }
    
    func onFetchCompleted() {
        activityIndicator.stopAnimating()
        collectionView.reloadSections(IndexSet(integer: 0))
        refreshControl.endRefreshing()
    }
    
    func onFetchFailed(with reason: String) {
        
    }
    
    
}
