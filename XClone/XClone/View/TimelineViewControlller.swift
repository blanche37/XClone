//
//  TimelineViewControlller.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import UIKit
import Combine
import CombineCocoa

final class TimelineViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let tableView = UITableView()
    private let viewModel: TimelineViewModelProtocol = TimelineViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
    }
    
    
}
