//
//  Extension+CollectionView.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import UIKit

extension CriticsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model.isSearching {
            return model.searchedCritic.count
        } else {
            return model.critics.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "criticCell", for: indexPath) as? CriticCell else {
            return UICollectionViewCell()
        }
        if model.isSearching {
            cell.criticNameLabel.text = model.searchedCritic[indexPath.row].displayName
            if let imageStr = model.searchedCritic[indexPath.row].multimedia?.resource.src {
                cell.criticImage.loadImageUsingCache(withUrl: imageStr)
            } else {
                cell.criticImage.image = UIImage(named: "person")
            }
        } else {
            cell.criticNameLabel.text = model.critics[indexPath.row].displayName
            if let imageStr = model.critics[indexPath.row].multimedia?.resource.src {
                cell.criticImage.loadImageUsingCache(withUrl: imageStr)
            } else {
                cell.criticImage.image = UIImage(named: "person")
            }
        }
        return cell
    }
}

extension CriticsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension CriticsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "show", sender: self)
    }
}
