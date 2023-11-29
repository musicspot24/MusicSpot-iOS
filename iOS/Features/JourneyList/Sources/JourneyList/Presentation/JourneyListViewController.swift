//
//  JourneyListViewController.swift
//  JourneyList
//
//  Created by 이창준 on 11/22/23.
//

import Combine
import UIKit

import MSUIKit

public final class JourneyListViewController: UIViewController {
    
    typealias JourneyListDataSource = UICollectionViewDiffableDataSource<Int, Journey>
    typealias JourneyCellRegistration = UICollectionView.CellRegistration<JourneyCell, Journey>
    typealias JourneySnapshot = NSDiffableDataSourceSnapshot<Int, Journey>
    
    // MARK: - Constants
    
    private enum Typo {
        static let title: String = "지난 여정"
    }
    
    private enum Metric {
        static let titleStackSpacing: CGFloat = 4.0
        static let collectionViewHorizontalInset: CGFloat = 10.0
        static let collectionViewVerticalInset: CGFloat = 24.0
        static let interGroupSpacing: CGFloat = 12.0
    }
    
    // MARK: - Properties
    
    private var viewModel: JourneyListViewModel
    
    private var dataSource: JourneyListDataSource?
    
    private var currentSnapshot: JourneySnapshot? {
        return self.dataSource?.snapshot()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private let titleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.titleStackSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.headerTitle)
        label.textColor = .msColor(.primaryTypo)
        label.text = Typo.title
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        label.text = "현재 위치에 0개의 여정이 있습니다."
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Initializer
    
    public init(viewModel: JourneyListViewModel,
                nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyle()
        self.configureLayout()
        self.configureCollectionView()
        self.bind()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    // MARK: - Combine Binding
    
    func bind() {
        self.viewModel.state.journeys
            .receive(on: DispatchQueue.main)
            .sink { journeys in
                self.subtitleLabel.text = "현재 위치에 \(journeys.count)개의 여정이 있습니다."
                var snapshot = JourneySnapshot()
                snapshot.appendSections([.zero])
                snapshot.appendItems(journeys, toSection: .zero)
                self.dataSource?.apply(snapshot)
            }
            .store(in: &self.cancellables)
    }
    
}

// MARK: - CollectionView

private extension JourneyListViewController {
    
    func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            return self.configureSection()
        })
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource = self.configureDataSource()
    }
    
    func configureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(JourneyCell.estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.interGroupSpacing
        
        return section
    }
    
    private func fetchImage(url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else { throw NSError(domain: "fetch error", code: 1004) }
        
        return data
    }
    
    func configureDataSource() -> JourneyListDataSource {
        // TODO: 최적화 & 캐싱
        let cellRegistration = JourneyCellRegistration { cell, _, itemIdentifier in
            let cellModel = JourneyCellModel(location: itemIdentifier.location,
                                             date: itemIdentifier.date,
                                             songTitle: itemIdentifier.song.title,
                                             songArtist: itemIdentifier.song.artist)
            cell.update(with: cellModel)
            let photoURLs = itemIdentifier.spots
                .flatMap { $0.photoURLs }
                .compactMap { URL(string: $0) }
            
            Task {
                cell.addImageView(count: photoURLs.count)
                
                await withTaskGroup(of: (index: Int, imageData: Data).self) { group in
                    for (index, photoURL) in photoURLs.enumerated() {
                        group.addTask(priority: .background) { [weak self] in
                            guard let imageData = try? await self?.fetchImage(url: photoURL) else {
                                return (0, Data())
                            }
                            return (index, imageData)
                        }
                    }
                    
                    for await (index, imageData) in group {
                        cell.updateImages(imageData: imageData, atIndex: index)
                    }
                }
            }
        }
      
        let dataSource = JourneyListDataSource(collectionView: self.collectionView,
                                               cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        })
        
        return dataSource
    }
    
}

// MARK: - UI Configuration

private extension JourneyListViewController {
    
    func configureStyle() {
        self.view.backgroundColor = .msColor(.primaryBackground)
    }
    
    func configureLayout() {
        self.view.addSubview(self.titleStack)
        self.titleStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.titleStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.titleStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        [
            self.titleLabel,
            self.subtitleLabel
        ].forEach {
            self.titleStack.addArrangedSubview($0)
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.titleStack.bottomAnchor,
                                                     constant: Metric.collectionViewVerticalInset),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                         constant: Metric.collectionViewHorizontalInset),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                          constant: -Metric.collectionViewHorizontalInset)
        ])
    }
    
}

// MARK: - Preview

import MSData
import MSDesignSystem
import MSNetworking
@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let journeyRepository = JourneyRepositoryImplementation()
    let testViewModel = JourneyListViewModel(repository: journeyRepository)
    let testViewController = JourneyListViewController(viewModel: testViewModel)
    return testViewController
}
