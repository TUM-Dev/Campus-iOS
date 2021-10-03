//
//  LectureDetailCollectionViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 6.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Alamofire
import XMLCoder

final class LectureDetailCollectionViewController: UICollectionViewController {
    private static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    private let sessionManager = Session.defaultSession

    private var currentSnapshot = NSDiffableDataSourceSnapshot<LectureDetailViewModel.Section, AnyHashable>()
    private var dataSource: UICollectionViewDiffableDataSource<LectureDetailViewModel.Section, AnyHashable>?
    private var endpoint: TUMOnlineAPI?
    private var viewModel: LectureDetailViewModel?

    func setLecture(withLVNr lvNr: String) {
        endpoint = TUMOnlineAPI.lectureDetails(lvNr: lvNr)
        fetch(animated: true)
    }

    func setLecture(_ lecture: Lecture) {
        viewModel = LectureDetailViewModel(lecture: lecture)
        endpoint = TUMOnlineAPI.lectureDetails(lvNr: lecture.lvNumber.description)
        fetch(animated: true)
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

    private func fetch(animated: Bool = true) {
        guard let endpoint = endpoint else { return }
        sessionManager.request(endpoint).responseDecodable(of: TUMOnlineAPIResponse<LectureDetail>.self, decoder: XMLDecoder()) { [weak self] response in
            guard let value = response.value?.rows?.first else { return }
            self?.viewModel = LectureDetailViewModel(lectureDetail: value)
            self?.reload(animated: animated)
        }
    }

    private func reload(animated: Bool = true) {
        guard let viewModel = viewModel else { return }
        currentSnapshot = NSDiffableDataSourceSnapshot<LectureDetailViewModel.Section, AnyHashable>()
        currentSnapshot.appendSections(viewModel.sections)

        for section in viewModel.sections {
            currentSnapshot.appendItems(section.cells, toSection: section)
        }

        dataSource?.apply(currentSnapshot, animatingDifferences: animated)
    }

    // MARK: - DataSource

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LectureDetailViewModel.Section, AnyHashable>(collectionView: collectionView) { [weak self]
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else {
                return nil
            }

            let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            let isLastCell = indexPath.item + 1 == self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)

            if let header = item as? LectureDetailViewModel.Header {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LectureDetailHeader.reuseIdentifier, for: indexPath) as! LectureDetailHeader
                cell.configure(viewModel: header)
                return cell
            } else if let item = item as? LectureDetailViewModel.Cell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LectureDetailCell.reuseIdentifier, for: indexPath) as! LectureDetailCell
                cell.configure(viewModel: item, isLastCell: isLastCell)
                return cell
            } else if let item = item as? LectureDetailViewModel.LinkCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LectureDetailLinkCell.reuseIdentifier, for: indexPath) as! LectureDetailLinkCell
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
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            default:
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            }

            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.interGroupSpacing = 5
            sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: LectureDetailCollectionViewController.sectionBackgroundDecorationElementKind)
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
            forDecorationViewOfKind: LectureDetailCollectionViewController.sectionBackgroundDecorationElementKind)
        return layout
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let linkCell = dataSource?.itemIdentifier(for: indexPath) as? LectureDetailViewModel.LinkCell else {
            guard let lectureDetailCell = dataSource?.itemIdentifier(for: indexPath) as? LectureDetailViewModel.Cell else { return }
            if lectureDetailCell.key == "Speaker" {
                let optionMenu = UIAlertController(title: nil, message: "Choose Speaker", preferredStyle: .actionSheet)
                
                var speakerList = lectureDetailCell.value
                var speakers = ""
                var singleSpeaker = ""
                var speakerForSearch = ""
                var iterations = 0
                
                for char in speakerList {
                    speakers.append(char)
                    let index = speakers.index(speakers.startIndex, offsetBy: 0)
                    speakerList.remove(at: index)
                    
                    if char == ","  || index == speakerList.endIndex {
                        iterations += 1
                        
                        var i = 0
                        
                        for c in speakers {
                            if c == "[" {
                                let x = speakers.index(speakers.startIndex, offsetBy: i)
                                speakers.removeSubrange(x..<speakers.endIndex)
                            } else if c == "," {
                                speakers.removeLast()
                            }
                            i += 1
                        }
                        
                        if speakerList.trimmingCharacters(in: .whitespaces).contains(speakers.trimmingCharacters(in: .whitespaces)) {
                            speakers.removeAll()
                            
                            iterations -= 1
                        }
                        
                        if !speakers.isEmpty {
                            speakerForSearch = speakers
                            
                            singleSpeaker = speakers
                            speakers.removeAll()
                            
                            let s = singleSpeaker
                            
                            let action = UIAlertAction(title: singleSpeaker, style: .default) {
                                _ in
                                                            
                                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                                guard let personSearchVC = storyboard.instantiateViewController(withIdentifier: "PersonSearchViewController") as? PersonSearchViewController else { return }
                                self.navigationController?.pushViewController(personSearchVC, animated: true)
                                personSearchVC.searchController.searchBar.text = s
                            }
                            
                            optionMenu.addAction(action)
                            
                            singleSpeaker.removeAll()
                        }
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    
                optionMenu.addAction(cancelAction)
                
                if iterations <= 1{
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    guard let personSearchVC = storyboard.instantiateViewController(withIdentifier: "PersonSearchViewController") as? PersonSearchViewController else { return }
                    self.navigationController?.pushViewController(personSearchVC, animated: true)
                    personSearchVC.searchController.searchBar.text = speakerForSearch
                } else if iterations > 1{
                    self.present(optionMenu, animated: true, completion: nil)
                }
                
                return
            }
            return
        }
        UIApplication.shared.open(linkCell.link, options: [:], completionHandler: nil)
    }
}
