//
//  CriticsStorage.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import Foundation

protocol CriticsStorageUpdateProtocol: class {
    func calculateIndexPathsToReload(from newCritics: [Critic]) -> [IndexPath]
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

final class CriticsStorage {
    
    weak var delegate: CriticsStorageUpdateProtocol?
    
    var critics: [Critic] = []
    
    func fetchCritics() {
        CriticManager.getCritics { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            case .success(let criticsInfo):
                DispatchQueue.main.async {
                    self.critics.append(contentsOf: criticsInfo.results)
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }
    
    func searchCritic(with Name: String) {
//        CriticManager
    }
    
}
