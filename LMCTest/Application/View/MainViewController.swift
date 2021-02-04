//
//  MainViewController.swift
//  LMCTest
//
//  Created by сергей on 02.02.2021.
//

import UIKit

class MainController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
//        tabBar.isHidden = true
    }
    
    private func setupTabBarController() {
        viewControllers = [createReviewsNavigationController(), createCriticsNavigationController()]
    }
    
    private func createReviewsNavigationController() -> UIViewController {
        let reviewsVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
        reviewsVC.title = "Reviews"
        return reviewsVC
    }
    
    private func createCriticsNavigationController() -> UINavigationController {
        let criticsVC = CriticsViewController()
        criticsVC.title = "Critics"
        return UINavigationController(rootViewController: criticsVC)
    }
    
    
}
