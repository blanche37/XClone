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
    private typealias DataSource = UITableViewDiffableDataSource<Section, Twit>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Twit>
    
    private enum Section {
        case standard
    }
    
    private(set) var tableView = UITableView()
    private let tableViewHeaderView = UIView()
    private var viewModel: TimelineViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource = configureDataSource()
    
    init(viewModel: TimelineViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(viewModel: TimelineViewModel())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TimelineTableViewCell.self, forCellReuseIdentifier: "TimelineCell") // TODO: 상수로 정리
        bindToViewModel()
        setupViews()
    }
    
    private func bindToViewModel() {
        viewModel.twitSubject
            .sink { [weak self] in
                print($0)
                self?.createSnapshot(twit: $0)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .foryou)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                Task {
                    self.viewModel.setupTwits([])
                    let twits = try await self.viewModel.requestForyou()
                    self.viewModel.setupTwits(twits)
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .following)
            .sink { _ in
                Task {
                    self.viewModel.setupTwits([])
                    let twits = try await self.viewModel.requestFollowing()
                    self.viewModel.setupTwits(twits)
                }
            }
            .store(in: &cancellables)
        
        tableView.didScrollPublisher
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if let previousOffset = viewModel.tableViewPreviousOffset {
                    if self.tableView.contentOffset.y > previousOffset
                    && abs(previousOffset - self.tableView.contentOffset.y) >= 100 {
                        // 사용자가 아래로 스크롤 중
                        NotificationCenter.default.post(name: .hideBar, object: nil)

                    } else if self.tableView.contentOffset.y < previousOffset
                           && abs(previousOffset - self.tableView.contentOffset.y) >= 20 {
                        // 사용자가 위로 스크롤 중
                        NotificationCenter.default.post(name: .displayBar, object: nil)
                    }
                }

                viewModel.tableViewPreviousOffset = self.tableView.contentOffset.y
            }
            .store(in: &cancellables)

        
    }
    
    private func createSnapshot(twit: [Twit]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.standard])
        snapshot.appendItems(twit)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureDataSource() -> DataSource {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as? TimelineTableViewCell
            // 셀설정
            cell?.profileImageView.image = UIImage(named: itemIdentifier.profileImage ?? "")
            cell?.nickNameLabel.text = itemIdentifier.nickName
            cell?.contentLabel.text = itemIdentifier.content
            cell?.tagNameLabel.text = itemIdentifier.mentionId
            if itemIdentifier.contentImage != nil {
                cell?.setContentImageViewConstraints(isImageExist: true)
                cell?.contentImageView.image = UIImage(named: itemIdentifier.contentImage ?? "")
            } else {
                cell?.setContentImageViewConstraints(isImageExist: false)
            }
            return cell
        }
    }
    
    
    private func setupViews() {
        tableView.backgroundColor = .black
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableViewHeaderView.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: 100))
        tableView.tableHeaderView = tableViewHeaderView
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary: [String: Any] = ["table": tableView]
        
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", metrics: nil, views: viewDictionary)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", metrics: nil, views: viewDictionary)
        [hConstraints, vConstraints].forEach {
            view.addConstraints($0)
        }
    }
}
