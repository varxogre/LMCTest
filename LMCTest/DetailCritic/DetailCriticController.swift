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
        setupTableView()
        initModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 23/255, green: 190/255, blue: 239/255, alpha: 1.0)
        
    }
    
    private func setupTableView() {
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "reviewCell")
        tableView.register(DetailCell.self, forCellReuseIdentifier: "detailCell")
        tableView.backgroundColor = .systemGray6
        tableView.addSubview(refreshControl)
    }
    
    private func initModel() {
        model = DetailStorage()
        model.delegate = self
        model.query = critic?.displayName.prepareWhitespace()
        model.fetchReviews()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        model.prepareModelForRefresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    deinit {
        print(#function)
    }
   
}

