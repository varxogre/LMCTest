//
//  CriticsStorage.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import Foundation

protocol CriticsStorageUpdateProtocol: class {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

final class CriticsStorage {
    
    weak var delegate: CriticsStorageUpdateProtocol?
    
    var critics: [Critic] = []
    var searchedCritic: [Critic] = []
    var isSearching = false
    
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
                    guard criticsInfo.numResults > 0 else {
                        self.delegate?.onFetchFailed(with: "К сожалению, по вашему запросу ничего не найдено...")
                        return
                    }
                    if criticsInfo.numResults == self.critics.count {
                        self.critics.removeAll()
                        self.critics.append(contentsOf: criticsInfo.results!)
                        self.delegate?.onFetchCompleted()
                        return
                    }
                    self.critics.append(contentsOf: criticsInfo.results!)
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }
    
    func searchCritic(with name: String) {
        CriticManager.getCritic(with: name) { [weak self] (result) in
            guard let self = self else { return }
            print(result)
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            case .success(let criticsInfo):
                DispatchQueue.main.async {
                    guard criticsInfo.numResults > 0 else {
                        self.delegate?.onFetchFailed(with: "К сожалению, по вашему запросу ничего не найдено...")
                        return
                    }
                    self.isSearching = true
                    self.searchedCritic.append(contentsOf: criticsInfo.results!)
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }
    
}
