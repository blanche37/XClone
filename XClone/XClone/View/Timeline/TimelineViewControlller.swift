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
    private let timelineView = TimelineView()
    private let viewModel: TimelineViewModelProtocol
    
    init(viewModel: TimelineViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = timelineView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        
    }
    
    
}
