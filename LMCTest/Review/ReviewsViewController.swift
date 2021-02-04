//
//  ViewController.swift
//  LMCTest
//
//  Created by сергей on 01.02.2021.
//

import UIKit

class ReviewsViewController: UIViewController, ReviewsStorageUpdateProtocol {
    
    
    private var model: ReviewsStorage!
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    var activityIndicator: UIActivityIndicatorView  {
        let activity = UIActivityIndicatorView(style: .large)
        view.addSubview(activity)
        view.bringSubviewToFront(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        return activity
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "cell")
        
        model = ReviewsStorage()
        model.fetchReviews()
        model.delegate = self
        searchBar.delegate = self
        activityIndicator.startAnimating()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        activityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.stopAnimating()
    }
    
    @IBAction func segment(_ sender: customSegmentedControl) {
        tabBarController?.selectedIndex = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = 0
    }
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if model.isSearching {
            model.isSearching = false
            tableView.reloadData()
            freeModel()
        }
        model.fetchReviews()
    }
    
    
}

extension ReviewsViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if model.isSearching {
            return indexPath.row >= model.searchedReviews.count - 1
        } else {
            return indexPath.row >= model.reviews.count - 1
        }
    }
    
    func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath] {
        if model.isSearching {
            let startIndex = model.searchedReviews.count - newReviews.count
            print("startIndex: \(startIndex)")
            let endIndex = startIndex + newReviews.count
            print("endIndex: \(endIndex)")
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        } else {
            let startIndex = model.reviews.count - newReviews.count
            let endIndex = startIndex + newReviews.count
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        }
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        activityIndicator.stopAnimating()
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            refreshControl.endRefreshing()
            tableView.reloadData()
            return
        }
        
        refreshControl.endRefreshing()
        tableView.beginUpdates()
        tableView.insertRows(at: newIndexPathsToReload, with: .automatic)
        tableView.endUpdates()
    }
    
    func onFetchFailed(with reason: String) {
        // TO-DO: alert controller with error
    }
    
    private func freeModel() {
        model.temp = model.searchedReviews.count
        model.searchingOffset = 0
        model.searchedReviews.removeAll()
    }
    
    func updateTable() {
        tableView.reloadData()
    }
}

extension ReviewsViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            if model.isSearching {
                return model.searchReviews()
            } else {
                model.fetchReviews()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.isSearching {
            print(#function)
            print("search")
            return model.searchedReviews.count
        } else {
            print(#function)
            print("review")
            return model.reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ReviewCell else {
            let cell = UITableViewCell()
            return cell
        }
        if model.isSearching {
            activityIndicator.stopAnimating()
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
        return 150
    }
    
}

extension ReviewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            activityIndicator.startAnimating()
            print(query)
            model.query = query
            freeModel()
            self.model.searchReviews()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
}
