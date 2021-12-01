//
//  MovieDetailCollectionViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 7.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Alamofire

final class MovieDetailCollectionViewController: UICollectionViewController {
    private static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    private let sessionManager = Session.defaultSession

    private var currentSnapshot = NSDiffableDataSourceSnapshot<MovieDetailViewModel.Section, AnyHashable>()
    private var dataSource: UICollectionViewDiffableDataSource<MovieDetailViewModel.Section, AnyHashable>?
    private var viewModel: MovieDetailViewModel?

    func setMovie(_ movie: Movie) {
        viewModel = MovieDetailViewModel(movie: movie)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        reload(animated: animated)
    }

    private func reload(animated: Bool = true) {
        guard let viewModel = viewModel else { return }
        currentSnapshot = NSDiffableDataSourceSnapshot<MovieDetailViewModel.Section, AnyHashable>()
        currentSnapshot.appendSections(viewModel.sections)

        for section in viewModel.sections {
            currentSnapshot.appendItems(section.cells, toSection: section)
        }

        dataSource?.apply(currentSnapshot, animatingDifferences: animated)
    }

    // MARK: - DataSource

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MovieDetailViewModel.Section, AnyHashable>(collectionView: collectionView) { [weak self]
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else {
                return nil
            }

            let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            let isLastCell = indexPath.item + 1 == self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)

            if let header = item as? MovieDetailViewModel.Header {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailHeader.reuseIdentifier, for: indexPath) as! MovieDetailHeader
                cell.configure(viewModel: header)
                return cell
            } else if let item = item as? MovieDetailViewModel.Cell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCell.reuseIdentifier, for: indexPath) as! MovieDetailCell
                cell.configure(viewModel: item, isLastCell: isLastCell)
                return cell
            } else if let item = item as? MovieDetailViewModel.LinkCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailLinkCell.reuseIdentifier, for: indexPath) as! MovieDetailLinkCell
                cell.configure(viewModel: item, isLastCell: isLastCell)
                return cell
            } else {
                return nil
            }
        }
    }

    // MARK: - CollectionView

    private func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider =  { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let size: NSCollectionLayoutSize
            switch sectionIndex {
            case 0:
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240))
            default:
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            }

            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.interGroupSpacing = 5
            sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: MovieDetailCollectionViewController.sectionBackgroundDecorationElementKind)
            sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                                                leading: 15,
                                                                                bottom: 10,
                                                                                trailing: 15)

            sectionLayout.decorationItems = [sectionBackgroundDecoration]

            return sectionLayout
        }

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: MovieDetailCollectionViewController.sectionBackgroundDecorationElementKind)
        return layout
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) as? MovieDetailViewModel.LinkCell else { return }
        UIApplication.shared.open(item.link, options: [:], completionHandler: nil)
    }
}
