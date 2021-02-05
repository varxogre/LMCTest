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
    
    var model: CriticsStorage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        segment.selectedSegmentIndex = 1
        tabBarController?.tabBar.isHidden = true
        
        collectionView.register(CriticCell.self, forCellWithReuseIdentifier: "criticCell")
        collectionView.addSubview(refreshControl)
        
        model = CriticsStorage()
        model.fetchCritics()
        model.delegate = self
        
        
    }
    

    @IBAction func segment(_ sender: customSegmentedControl) {
        tabBarController?.selectedIndex = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = 1
    }
    
    @objc func refresh(_ sender: AnyObject) {
       
    }
    
}

extension CriticsViewController: UISearchBarDelegate {
    
}
