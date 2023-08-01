//
//  SearchViewController.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import UIKit
import Combine
import CombineCocoa

final class SearchViewController: UIViewController {
    private let searchView = SearchView()
    private let viewModel: SearchViewModelProtocol
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = searchView
    }
}
