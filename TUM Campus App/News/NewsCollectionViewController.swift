//
//  NewsCollectionViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 13.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

final class NewsCollectionViewController: UICollectionViewController {
    private var dataSource: UICollectionViewDiffableDataSource<NewsSource, News>!
    private var currentSnapshot = NSDiffableDataSourceSnapshot<NewsSource, News>()
    private let importer = NewsImporter()

    private enum Section: Int, CaseIterable {
        case news
        case movie

        var columns: Int {
            switch self {
            case .news: return 1
            case .movie: return 3
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News".localized
        setupCollectionView()
        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupCollectionView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = createLayout()
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))

            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)

            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<NewsSource, News>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, news: News) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.reuseIdentifier, for: indexPath) as! NewsCollectionViewCell

            cell.configure(news: news)

            return cell
        }
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: NewsCategoryHeaderView.reuseIdentifier,
                for: indexPath) as! NewsCategoryHeaderView

            let newsSource = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            titleSupplementary.configure(source: newsSource)

            return titleSupplementary
        }
        fetch()
    }

    @objc private func fetch(_ animated: Bool = false) {
        if animated {
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.beginRefreshing()
            }
        }
        importer.performFetch(success: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.collectionView.refreshControl?.endRefreshing()
            }
            self?.reload()
        }, error: { [weak self] error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.collectionView.refreshControl?.endRefreshing()
            }
            self?.setBackgroundLabel(withText: error.localizedDescription)
        })
    }

    private func reload() {
        try? importer.fetchedResultsController.performFetch()
        currentSnapshot.deleteSections(currentSnapshot.sectionIdentifiers)
        currentSnapshot.deleteAllItems()
        guard let sources = importer.fetchedResultsController.fetchedObjects?.filter({ ($0.news?.count ?? 0) > 0 }) else { return }
        currentSnapshot.appendSections(sources)
        for source in sources {
            guard var news = source.news?.allObjects as? [News] else { return }
            news.sort { (lhs, rhs) -> Bool in
                guard let lhs = lhs.date else { return true }
                guard let rhs = rhs.date else { return false }
                return lhs > rhs
            }
            currentSnapshot.appendItems(news, toSection: source)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let news = dataSource.itemIdentifier(for: indexPath), let link = news.link else { return }
        UIApplication.shared.open(link)
    }

}
