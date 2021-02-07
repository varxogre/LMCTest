//
//  Extension+DetailTableView.swift
//  LMCTest
//
//  Created by сергей on 06.02.2021.
//

import UIKit

extension DetailCriticController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell(for:)) {
            model.fetchReviews()
        }
    }
}

extension DetailCriticController: UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : model.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                            "detailCell",
                                                           for: indexPath) as? DetailCell else {return UITableViewCell()}
            
            guard let critic = critic else { return UITableViewCell()}
            cell.configureCellWith(critic.displayName, critic.status.rawValue, critic.bio.prepareBio(), image: critic.multimedia?.resource.src)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                            "reviewCell",
                                                           for: indexPath) as? ReviewCell else {return UITableViewCell()}
            let source = model.reviews[indexPath.row]
            cell.configureCellWith(source.displayTitle, source.summaryShort, source.byline, source.dateUpdated)
            if let imageStr = model.reviews[indexPath.row].multimedia?.src {
                cell.mainImage.loadImageUsingCache(withUrl: imageStr)
            } else {
                cell.mainImage.image = UIImage(systemName: "film")
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.estimatedRowHeight
        } else {
            return  view.frame.width / 2.5
        }
    }
}
