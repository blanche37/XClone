//
//  ViewController.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import UIKit
import Combine
import CombineCocoa

final class ContainerViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItem()
    }
    
    func setupTabBarItem() {
        let timelineViewController = TimelineViewController(viewModel: TimelineViewModel())
        timelineViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        self.setViewControllers([timelineViewController], animated: true)
    }
}

