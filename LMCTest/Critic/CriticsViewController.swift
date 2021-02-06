//
//  SecondViewController.swift
//  LMCTest
//
//  Created by сергей on 02.02.2021.
//

import UIKit

class CriticsViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var segment: customSegmentedControl!
    
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
    
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 10.0, bottom: 50.0, right: 10.0)
    let itemsPerRow: CGFloat = 2
    var model: CriticsStorage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        segment.selectedSegmentIndex = 1
        tabBarController?.tabBar.isHidden = true
        
        collectionView.register(CriticCell.self, forCellWithReuseIdentifier: "criticCell")
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        
        model = CriticsStorage()
        model.fetchCritics()
        model.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func segment(_ sender: customSegmentedControl) {
        tabBarController?.selectedIndex = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = 1
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
        if model.isSearching {
            model.isSearching = false
            collectionView.reloadData()
        }
        model.fetchCritics()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "show" else { return }
        guard let sender = sender as? Critic else { return }
        if let detailVC = segue.destination as? DetailCriticController {
            detailVC.critic = sender
        }
    }
    
}

extension CriticsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var query = searchBar.text {
            query = query.prepareWhitespace()
            activityIndicator.startAnimating()
            model.searchedCritic.removeAll()
            self.model.searchCritic(with: query)
        }
    }
}
