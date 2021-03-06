//
//  Extension+TableView.swift
//  LMCTest
//
//  Created by сергей on 04.02.2021.
//

import UIKit


extension ReviewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: model.isLoadingCell) {
            if model.isFiltering {
                model.prepareModelForRefresh()
                tableView.reloadData()
            }
            if model.isSearching {
                model.searchReviews()
            } else {
                model.fetchReviews()
            }
        }
    }
}

extension ReviewsViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.isFiltering {
            return model.filteredByDate.count
        } else
        if model.isSearching {
            return model.searchedReviews.count
        } else {
            return model.reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ReviewCell else {
            let cell = UITableViewCell()
            return cell
        }
        if model.isFiltering {
            let source = model.filteredByDate[indexPath.row]
            cell.configureCellWith(source.displayTitle, source.summaryShort, source.byline, source.dateUpdated)
            if let imageStr = model.filteredByDate[indexPath.row].multimedia?.src {
                cell.mainImage.loadImageUsingCache(withUrl: imageStr)
            } else {
                cell.mainImage.image = UIImage(systemName: "film")
            }
        } else
        if model.isSearching {
            let source = model.searchedReviews[indexPath.row]
            cell.configureCellWith(source.displayTitle, source.summaryShort, source.byline, source.dateUpdated)
            if let imageStr = model.searchedReviews[indexPath.row].multimedia?.src {
                cell.mainImage.loadImageUsingCache(withUrl: imageStr)
            } else {
                cell.mainImage.image = UIImage(systemName: "film")
            }
        } else {
            let source = model.reviews[indexPath.row]
            cell.configureCellWith(source.displayTitle, source.summaryShort, source.byline, source.dateUpdated)
            if let imageStr = model.reviews[indexPath.row].multimedia?.src {
                cell.mainImage.loadImageUsingCache(withUrl: imageStr)
            } else {
                cell.mainImage.image = UIImage(systemName: "film")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  view.frame.width / 2.5
    }
    
}

