//
//  GradeCollectionViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 25.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import XMLCoder
import Charts

final class GradeCollectionViewController: UICollectionViewController, ProfileImageSettable {
    typealias ResponseType = APIResponse<TUMOnlineAPIResponse<Grade>,TUMOnlineAPIError>
    typealias ImporterType = Importer<Grade,ResponseType,XMLDecoder>

    @IBOutlet private weak var profileBarButtonItem: UIBarButtonItem!
    var profileImage: UIImage? {
        get { return profileBarButtonItem.image }
        set { profileBarButtonItem.image = newValue?.imageAspectScaled(toFill: CGSize(width: 32, height: 32)).imageRoundedIntoCircle().withRenderingMode(.alwaysOriginal) }
    }

    private static let endpoint = TUMOnlineAPI.personalGrades
    private static let primarySortDescriptor = NSSortDescriptor(keyPath: \Grade.semester, ascending: false)
    private static let secondarySortDescriptor = NSSortDescriptor(keyPath: \Grade.title, ascending: false)
    private static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    private static let gradeChartSectionName = "Chart"

    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: primarySortDescriptor, secondarySortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))

    private var currentSnapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    enum Section: Hashable {
        case chart(study: String)
        case grades(semester: String)

        var title: String {
            switch self {
            case let .chart(study):
                return study
            case let .grades(semester):
                return semester
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupCollectionView()
        setupDataSource()
        title = "Grades".localized
        loadProfileImage()
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
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: Grade.fetchRequest())
                _ = try? self?.importer.context.execute(deleteRequest)
                self?.reload(animated: animated)
            default: break
            }
            self?.setBackgroundLabel(withText: error.localizedDescription)
        })
    }

    private func reload(animated: Bool = true) {
        try? importer.fetchedResultsController.performFetch()

        currentSnapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()

        let sections = importer.fetchedResultsController.sections ?? []
        currentSnapshot.appendSections(sections.map { .grades(semester: $0.name) })

        for section in sections {
            guard let grades = section.objects as? [Grade] else { continue }
            currentSnapshot.appendItems(grades, toSection: .grades(semester: section.name))
        }


        if let grades = importer.fetchedResultsController.fetchedObjects {

            for (study,chart) in GradeChartViewModel(grades: grades).charts {
                guard let section = sections.first(where: { section in
                    guard let grades = section.objects as? [Grade] else { return false }
                    return grades.first?.studyID == study
                }) else { continue }

                currentSnapshot.insertSections([.chart(study: study)], beforeSection: .grades(semester: section.name))
                currentSnapshot.appendItems([chart], toSection: .chart(study: study))
            }
        }

        dataSource?.apply(currentSnapshot, animatingDifferences: animated)

        switch importer.fetchedResultsController.fetchedObjects?.count {
        case let .some(count) where count > 0:
            removeBackgroundLabel()
        case let .some(count) where count == 0:
            setBackgroundLabel(withText: "No Grades".localized)
        default:
            break
        }
    }

    // MARK: Setup

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { [weak self]
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else {
                return nil
            }

            let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            let isLastCell = indexPath.item + 1 == self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)

            if let grade = item as? Grade {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GradeCollectionViewCell.reuseIdentifier, for: indexPath) as! GradeCollectionViewCell
                cell.configure(grade: grade, lastCell: isLastCell)
                return cell
            } else if let chart = item as? GradeChartViewModel.Chart {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GradeChartCollectionViewCell.reuseIdentifier, for: indexPath) as! GradeChartCollectionViewCell
                cell.configure(chartViewModel: chart)
                return cell
            } else {
                return UICollectionViewCell()
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }

            let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SimpleHeaderView.reuseIdentifier,
                for: indexPath) as! SimpleHeaderView

            let section = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            titleSupplementary.configure(title: section.title)

            return titleSupplementary
        }

        fetch(animated: false)
    }

    private func setupCollectionView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = createLayout()
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider =  { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let chartSection: Bool
            if case .chart = self?.currentSnapshot.sectionIdentifiers[sectionIndex] {
                chartSection = true
            } else {
                chartSection = false
            }

            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: chartSection ? .absolute(240) : .estimated(88))

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
                elementKind: GradeCollectionViewController.sectionBackgroundDecorationElementKind)
            sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: chartSection ? 10 : titleSize.heightDimension.dimension,
                                                                                leading: 15,
                                                                                bottom: 10,
                                                                                trailing: 15)

            section.decorationItems = [sectionBackgroundDecoration]
            section.boundarySupplementaryItems = chartSection ? [] : [titleSupplementary]

            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: GradeCollectionViewController.sectionBackgroundDecorationElementKind)
        return layout
    }

    private func setupNavigationBarItem() {
        
    }

}
