//
//  DetailCriticController.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import UIKit

class DetailCriticController: UIViewController {
    
    var model: DetailStorage!
    var critic: Critic?
    
    @IBOutlet var tableView: UITableView!
    
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
    
    lazy var refreshControl: UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "reviewCell")
        tableView.register(DetailCell.self, forCellReuseIdentifier: "detailCell")
        tableView.addSubview(refreshControl)
        model = DetailStorage()
        model.delegate = self
        model.fetchReviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 23/255, green: 190/255, blue: 239/255, alpha: 1.0)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        model.offset = 0
        model.hasMore = true
        model.isFirstRequest = true
        model.fetchReviews()
    }
   
}

