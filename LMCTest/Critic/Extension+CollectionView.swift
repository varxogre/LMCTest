//
//  Extension+CollectionView.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import UIKit

extension CriticsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.critics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "criticCell", for: indexPath) as? CriticCell else {
            return UICollectionViewCell()
        }
        cell.criticNameLabel.text = model.critics[indexPath.row].displayName
        if let imageStr = model.critics[indexPath.row].multimedia?.resource.src {
            cell.criticImage.loadImageUsingCache(withUrl: imageStr)
        } else {
            cell.criticImage.image = UIImage(systemName: "film")
        }
        return cell
    }
}

extension CriticsViewController: UICollectionViewDelegate {
    
}
