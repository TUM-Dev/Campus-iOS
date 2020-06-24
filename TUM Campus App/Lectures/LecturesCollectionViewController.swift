//
//  LecturesCollectionViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 23.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import CoreData
import XMLCoder
import Alamofire

final class LecturesCollectionViewController: UICollectionViewController {
    typealias ImporterType = Importer<Lecture, APIResponse<LectureAPIResponse,TUMOnlineAPIError>, XMLDecoder>

    private static let endpoint = TUMOnlineAPI.personalLectures
    private static let sortDescriptor = NSSortDescriptor(keyPath: \Lecture.semesterID, ascending: false)
    private static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))

    var currentSnapshot = NSDiffableDataSourceSnapshot<String, Lecture>()
    var dataSource: UICollectionViewDiffableDataSource<String, Lecture>?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupDataSource()
        title = "Lectures".localized
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch(animated: animated)
    }

    @objc private func fetch(animated: Bool = true) {
        if animated {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.refreshControl?.beginRefreshing()
            }
        }
        importer.performFetch(success: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.collectionView.refreshControl?.endRefreshing()
                self?.reload()
            }
        }, error: { [weak self] error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.collectionView.refreshControl?.endRefreshing()
            }
            switch error {
            case is TUMOnlineAPIError:
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: Lecture.fetchRequest())
                _ = try? self?.importer.context.execute(deleteRequest)
                self?.reload()
            default: break
            }
            self?.setBackgroundLabel(withText: error.localizedDescription)
        })
    }

    private func reload() {
        try? importer.fetchedResultsController.performFetch()

        currentSnapshot = NSDiffableDataSourceSnapshot<String, Lecture>()
        let sections = importer.fetchedResultsController.sections ?? []
        currentSnapshot.appendSections(sections.map { $0.name })

        for section in sections {
            guard let lectures = section.objects as? [Lecture] else { continue }
            currentSnapshot.appendItems(lectures, toSection: section.name)
        }

        dataSource?.apply(currentSnapshot)

        switch importer.fetchedResultsController.fetchedObjects?.count {
        case let .some(count) where count > 0:
            removeBackgroundLabel()
        case let .some(count) where count == 0:
            setBackgroundLabel(withText: "No Lectures".localized)
        default:
            break
        }
    }

    // MARK: Setup

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, Lecture>(collectionView: collectionView) { [weak self]
            (collectionView, indexPath, lecture) -> UICollectionViewCell? in
            guard let self = self,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LectureCollectionViewCell.reuseIdentifier, for: indexPath) as? LectureCollectionViewCell else { return nil }

            let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            let lecture = self.currentSnapshot.itemIdentifiers(inSection: sectionIdentifier)[indexPath.row]
            let isLastCell = indexPath.item + 1 == self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)

            cell.configure(lecture: lecture, lastCell: isLastCell)

            return cell
        }

        dataSource?.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LectureHeaderView.reuseIdentifier,
                for: indexPath) as! LectureHeaderView

            let sectionTitle = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            titleSupplementary.configure(title: sectionTitle)

            return titleSupplementary
        }
    }

    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = createLayout()
    }

    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(88))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 30, trailing: 15)

        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))

        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)

        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: LecturesCollectionViewController.sectionBackgroundDecorationElementKind)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: titleSize.heightDimension.dimension, leading: 10, bottom: 25, trailing: 10)
        section.decorationItems = [sectionBackgroundDecoration]

        section.boundarySupplementaryItems = [titleSupplementary]

        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: LecturesCollectionViewController.sectionBackgroundDecorationElementKind)
        return layout
    }

}
