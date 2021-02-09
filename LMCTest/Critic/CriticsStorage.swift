//
//  CriticsStorage.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import Foundation

final class CriticsStorage {
    
    weak var delegate: StorageUpdateProtocol?
    
    var isSearching = false
    var critics: [Critic] = []
    var searchedCritic: [Critic] = []
    
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
                    guard let results = criticsInfo.results else {
                        self.delegate?.onFetchFailed(with: "Что-то пошло не так, попробуйте ещё раз.")
                        return
                    }
                    if criticsInfo.numResults == self.critics.count {
                        self.critics.removeAll()
                        self.critics.append(contentsOf: results)
                        self.delegate?.onFetchCompleted(with: nil)
                        return
                    }
                    self.critics.append(contentsOf: results)
                    self.delegate?.onFetchCompleted(with: nil)
                }
            }
        }
    }
    
    func searchCritic(with name: String) {
        CriticManager.getCritic(with: name) { [weak self] (result) in
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
                    guard let results = criticsInfo.results else {
                        self.delegate?.onFetchFailed(with: "Что-то пошло не так, попробуйте ещё раз.")
                        return
                    }
                    self.isSearching = true
                    self.searchedCritic.append(contentsOf: results)
                    self.delegate?.onFetchCompleted(with: nil)
                }
            }
        }
    }
    
}
