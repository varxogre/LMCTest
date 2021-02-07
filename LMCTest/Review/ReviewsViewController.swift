//
//  ViewController.swift
//  LMCTest
//
//  Created by сергей on 01.02.2021.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    
    var model: ReviewsStorage!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var searchBar: UISearchBar!
    
    lazy var refreshControl: UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        view.addSubview(activity)
        view.bringSubviewToFront(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return activity
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        tabBarController?.tabBar.isHidden = true
        setupTableView()
        initModel()
        
    }
    
    private func setupTableView() {
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "cell")
        tableView.addSubview(refreshControl)
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .systemGray6
    }
    
    private func initModel() {
        model = ReviewsStorage()
        model.fetchReviews()
        model.delegate = self
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if model.isSearching {
            model.isSearching = false
            model.prepareModelForRefresh()
            tableView.reloadData()
        }
        if model.isFiltering {
            model.prepareModelForRefresh()
            tableView.reloadData()
            refreshControl.endRefreshing()
        } else {
            model.fetchReviews()
        }
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(
            title: "Ooops.", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func segment(_ sender: customSegmentedControl) {
        tabBarController?.selectedIndex = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = 0
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        activityIndicator.startAnimating()
        model.filterDates(by: sender.date.customizeDate())
    }
    
}


extension ReviewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            activityIndicator.startAnimating()
            model.query = query
            model.prepareModelForRefresh()
            model.searchReviews()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
