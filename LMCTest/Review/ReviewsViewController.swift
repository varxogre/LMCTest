//
//  ViewController.swift
//  LMCTest
//
//  Created by сергей on 01.02.2021.
//

import UIKit

class ReviewsViewController: UIViewController, ReviewsStorageUpdateProtocol {
    
    
    var model: ReviewsStorage!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var searchBar: UISearchBar!
    
    lazy var refreshControl = UIRefreshControl()
    lazy var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivity()
        tabBarController?.tabBar.isHidden = true
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "cell")
        
        model = ReviewsStorage()
        model.fetchReviews()
        model.delegate = self
        
        searchBar.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func createActivity() {
        let activity = UIActivityIndicatorView(style: .large)
        view.addSubview(activity)
        view.bringSubviewToFront(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        activityIndicator = activity
        activity.startAnimating()
    }
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        if model.isSearching {
            model.isSearching = false
            tableView.reloadData()
            freeModel()
        }
        model.fetchReviews()
    }
    
    @IBAction func segment(_ sender: customSegmentedControl) {
        tabBarController?.selectedIndex = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = 0
    }

    @IBAction func dateChanged(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    
}


extension ReviewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            activityIndicator.startAnimating()
            model.query = query
            freeModel()
            self.model.searchReviews()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
}
