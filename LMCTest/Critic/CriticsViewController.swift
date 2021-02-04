//
//  SecondViewController.swift
//  LMCTest
//
//  Created by сергей on 02.02.2021.
//

import UIKit

class CriticsViewController: UIViewController {
    
    var critics: [Critic]?

    @IBAction func segment(_ sender: customSegmentedControl) {
        tabBarController?.selectedIndex = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}


