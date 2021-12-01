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
    private var dataSource: UICollectionViewDiffableDataSource<String, AnyHashable>?
    private var currentSnapshot = NSDiffableDataSourceSnapshot<String, AnyHashable>()
    private let newsImporter = NewsImporter()
    private let movieImporter = Importer<Movie,[Movie],JSONDecoder>(
        endpoint: TUMCabeAPI.movie,
        sortDescriptor: NSSortDescriptor(keyPath: \Movie.date, ascending: false),
        dateDecodingStrategy: .formatted(DateFormatter.yyyyMMddhhmmss))

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
        fetch(animated)
    }

    private func setupCollectionView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = createLayout()
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let tumFilmSection = self?.currentSnapshot.indexOfSection("TU Film")
            let groupFractionalWidth: CGFloat
            if layoutEnvironment.container.effectiveContentSize.width > 500 {
                groupFractionalWidth = sectionIndex == tumFilmSection ?  0.2 : 0.425
            } else {
                groupFractionalWidth = sectionIndex == tumFilmSection ? 0.4 : 0.85
            }

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .absolute(sectionIndex == tumFilmSection ? 300 : 250))

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
        dataSource = UICollectionViewDiffableDataSource<String, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in

            if let news = item as? News {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.reuseIdentifier, for: indexPath) as! NewsCollectionViewCell
                cell.configure(news: news)
                return cell
            } else if let movie = item as? Movie {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
                cell.configure(movie: movie)
                return cell
            } else {
                return nil
            }
        }
        dataSource?.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SimpleHeaderView.reuseIdentifier,
                for: indexPath) as! SimpleHeaderView

            let sectionTitle = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            titleSupplementary.configure(title: sectionTitle)

            return titleSupplementary
        }
    }

    @objc private func fetch(_ animated: Bool = false) {
        let group = DispatchGroup()

        if animated {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.refreshControl?.beginRefreshing()
            }
        }

        group.enter()
        newsImporter.performFetch(success: {
            group.leave()
        }, error: { _ in
            group.leave()
        })

        group.enter()
        movieImporter.performFetch(success: {
            group.leave()
        }, error: { _ in
            group.leave()
        })

        group.notify(queue: .main) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.collectionView.refreshControl?.endRefreshing()
            }
            self?.reload(animated: animated)
        }
    }

    private func reload(animated: Bool = false) {
        currentSnapshot = NSDiffableDataSourceSnapshot<String, AnyHashable>()

        try? movieImporter.fetchedResultsController.performFetch()
        if var movies = movieImporter.fetchedResultsController.fetchedObjects {

            movies.sort { (lhs, rhs) -> Bool in
                guard let lhs = lhs.date else { return true }
                guard let rhs = rhs.date else { return false }
                return lhs > rhs
            }
            let section = "TU Film"
            currentSnapshot.appendSections([section])
            currentSnapshot.appendItems(movies, toSection: section)
        }

        try? newsImporter.fetchedResultsController.performFetch()
        if let sources = newsImporter.fetchedResultsController.fetchedObjects?
            .filter({ ($0.news?.count ?? 0) > 0 })
            .filter({ $0.id != 2 })
            .filter({ $0.title != nil }) {

            // Exclude id from news sources which is TU Film siince its handled by another endpoint
            currentSnapshot.appendSections(sources.compactMap{ $0.title })
            for source in sources {
                guard var news = source.news?.allObjects as? [News], let title = source.title else { return }
                news.sort { (lhs, rhs) -> Bool in
                    guard let lhs = lhs.date else { return true }
                    guard let rhs = rhs.date else { return false }
                    return lhs > rhs
                }
                currentSnapshot.appendItems(news, toSection: title)
            }
        }

        dataSource?.apply(currentSnapshot, animatingDifferences: true)
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let news = dataSource?.itemIdentifier(for: indexPath) as? News, let link = news.link {
            UIApplication.shared.open(link)
        } else if let movie = dataSource?.itemIdentifier(for: indexPath) as? Movie {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let detailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailCollectionViewController") as? MovieDetailCollectionViewController else { return }
            navigationController?.pushViewController(detailVC, animated: true)
            detailVC.setMovie(movie)
        }
    }

}
