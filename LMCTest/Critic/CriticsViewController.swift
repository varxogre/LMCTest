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
        setupCollection()
        initModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupCollection() {
        collectionView.register(CriticCell.self, forCellWithReuseIdentifier: "criticCell")
        collectionView.backgroundColor = .systemGray6
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
    }
    
    private func initModel() {
        model = CriticsStorage()
        model.fetchCritics()
        model.delegate = self
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
        if model.isSearching {
            model.isSearching = false
            collectionView.reloadData()
        }
        model.fetchCritics()
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(
            title: "Ooops.", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func segment(_ sender: UISegmentedControl) {
        tabBarController?.selectedIndex = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "show" else { return }
        guard let sender = sender as? Critic else { return }
        if let detailVC = segue.destination as? DetailCriticController {
            detailVC.critic = sender
            detailVC.navigationItem.title = sender.displayName
        }
    }
    
}

extension CriticsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var query = searchBar.text {
            query = query.prepareWhitespace().capitalized
            activityIndicator.startAnimating()
            model.searchedCritic.removeAll()
            self.model.searchCritic(with: query)
        }
        searchBar.resignFirstResponder()
    }
}
