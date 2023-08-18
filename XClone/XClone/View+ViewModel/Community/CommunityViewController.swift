//
//  CommunityViewController.swift
//  XClone
//
//  Created by yun on 2023/08/03.
//

import UIKit
import Combine

final class CommunityViewController: UIViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Section, Community>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Community>
    
    private enum Section {
        case standard
    }
    
    private let discoverLabel = UILabel()
    private let tableView = UITableView()
    private let showMoreButton = UIButton()
    private lazy var dataSource = configureDataSource()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: CommunityViewModelProtocol
    
    init(viewModel: CommunityViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(viewModel: CommunityViewModel())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        setupViews()
        tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: "CommunityCell")
    }
    
    private func configureDataSource() -> DataSource {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as? CommunityTableViewCell
            return cell?.configureCell(community: itemIdentifier)
        }
    }
    
    private func createSnapshot(community: [Community]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.standard])
        snapshot.appendItems(community, toSection: .standard)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bindToViewModel() {
        viewModel.communitySubject
            .sink { [weak self] communities in
                self?.createSnapshot(community: communities)
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        discoverLabel.text = "Discover"
        discoverLabel.textColor = .white
        discoverLabel.font = .boldSystemFont(ofSize: 20)
        
        tableView.backgroundColor = .black
        tableView.isScrollEnabled = false
        showMoreButton.setTitleColor(.systemBlue, for: .normal)
        showMoreButton.setTitle("more...", for: .normal)
        
        [discoverLabel, tableView, showMoreButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            discoverLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            discoverLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: discoverLabel.topAnchor, constant: 20),
            tableView.heightAnchor.constraint(equalToConstant: 360),
            
            showMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            showMoreButton.topAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
    
}
