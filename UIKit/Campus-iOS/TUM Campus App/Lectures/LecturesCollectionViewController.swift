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

final class LecturesCollectionViewController: UICollectionViewController, ProfileImageSettable {
    typealias ImporterType = Importer<Lecture, APIResponse<TUMOnlineAPIResponse<Lecture>,TUMOnlineAPIError>,XMLDecoder>

    @IBOutlet private weak var profileImageBarButtonItem: UIBarButtonItem!
    var profileImage: UIImage? {
        get { return profileImageBarButtonItem.image }
        set { profileImageBarButtonItem.image = newValue?.imageAspectScaled(toFill: CGSize(width: 32, height: 32)).imageRoundedIntoCircle().withRenderingMode(.alwaysOriginal) }
    }

    private static let endpoint = TUMOnlineAPI.personalLectures
    private static let primarySortDescriptor = NSSortDescriptor(keyPath: \Lecture.semesterID, ascending: false)
    private static let secondarySortDescriptor = NSSortDescriptor(keyPath: \Lecture.id, ascending: false)
    private static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: primarySortDescriptor, secondarySortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))

    private var currentSnapshot = NSDiffableDataSourceSnapshot<String, Lecture>()
    private var dataSource: UICollectionViewDiffableDataSource<String, Lecture>?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupDataSource()
        loadProfileImage()
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
                self?.reload(animated: animated)
            }
        }, error: { [weak self] error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.collectionView.refreshControl?.endRefreshing()
            }
            switch error {
            case is TUMOnlineAPIError:
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: Lecture.fetchRequest())
                _ = try? self?.importer.context.execute(deleteRequest)
                self?.reload(animated: animated)
            default: break
            }
            self?.setBackgroundLabel(withText: error.localizedDescription)
        })
    }

    private func reload(animated: Bool = true) {
        try? importer.fetchedResultsController.performFetch()

        currentSnapshot = NSDiffableDataSourceSnapshot<String, Lecture>()
        let sections = importer.fetchedResultsController.sections ?? []
        currentSnapshot.appendSections(sections.map { $0.name })

        for section in sections {
            guard let lectures = section.objects as? [Lecture] else { continue }
            currentSnapshot.appendItems(lectures, toSection: section.name)
        }

        dataSource?.apply(currentSnapshot, animatingDifferences: animated)

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
                withReuseIdentifier: SimpleHeaderView.reuseIdentifier,
                for: indexPath) as! SimpleHeaderView

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
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))

        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)

        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: LecturesCollectionViewController.sectionBackgroundDecorationElementKind)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: titleSize.heightDimension.dimension, leading: 15, bottom: 10, trailing: 15)
        section.decorationItems = [sectionBackgroundDecoration]

        section.boundarySupplementaryItems = [titleSupplementary]

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30

        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: LecturesCollectionViewController.sectionBackgroundDecorationElementKind)
        return layout
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let lecture = dataSource?.itemIdentifier(for: indexPath) else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "LectureDetailCollectionViewController") as? LectureDetailCollectionViewController else { return }
        navigationController?.pushViewController(detailVC, animated: true)
        detailVC.setLecture(lecture)
    }

}
