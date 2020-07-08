//
//  PersonDetailViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 4.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Alamofire
import XMLCoder
import ContactsUI

final class PersonDetailCollectionViewController: UICollectionViewController, CNContactViewControllerDelegate {
    private static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    private let sessionManager = Session.defaultSession

    private var currentSnapshot = NSDiffableDataSourceSnapshot<PersonDetailViewModel.Section, AnyHashable>()
    private var dataSource: UICollectionViewDiffableDataSource<PersonDetailViewModel.Section, AnyHashable>?
    private var endpoint: TUMOnlineAPI?
    private var person: PersonDetail?
    private var viewModel: PersonDetailViewModel?
    
    func setPerson(withID id: String) {
        endpoint = TUMOnlineAPI.personDetails(identNumber: id)
        fetch(animated: true)
    }

    func setPerson(_ person: Person) {
        viewModel = PersonDetailViewModel(person: person)
        endpoint = TUMOnlineAPI.personDetails(identNumber: person.obfuscatedID)
        fetch(animated: true)
    }

    func setPerson(withProfile profile: Profile) {
        viewModel = PersonDetailViewModel(profile: profile)
        guard let id = profile.obfuscatedID else { return }
        endpoint = TUMOnlineAPI.personDetails(identNumber: id)
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
        sessionManager.request(endpoint).responseDecodable(of: PersonDetail.self, decoder: XMLDecoder()) { [weak self] response in
            guard let value = response.value else { return }
            self?.person = value
            self?.viewModel = PersonDetailViewModel(person: value)
            self?.reload(animated: animated)
        }
    }
    
    private func reload(animated: Bool = true) {
        guard let viewModel = viewModel else { return }
        currentSnapshot = NSDiffableDataSourceSnapshot<PersonDetailViewModel.Section, AnyHashable>()
        currentSnapshot.appendSections(viewModel.sections)

        for section in viewModel.sections {
            currentSnapshot.appendItems(section.cells, toSection: section)
        }

        dataSource?.apply(currentSnapshot, animatingDifferences: animated)
    }

    // MARK: - Setup

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<PersonDetailViewModel.Section, AnyHashable>(collectionView: collectionView) { [weak self]
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else {
                return nil
            }

            let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            let isLastCell = indexPath.item + 1 == self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)

            if let header = item as? PersonDetailViewModel.Header {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonDetailHeaderCell.reuseIdentifier, for: indexPath) as! PersonDetailHeaderCell
                cell.configure(viewModel: header)
                return cell
            } else if let item = item as? PersonDetailViewModel.Cell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonDetailCollectionViewCell.reuseIdentifier, for: indexPath) as! PersonDetailCollectionViewCell
                cell.configure(viewModel: item, isLastCell: isLastCell)
                return cell
            } else {
                return UICollectionViewCell()
            }
        }

        fetch(animated: false)
    }

    private func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
    }


    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider =  { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let size: NSCollectionLayoutSize
            switch sectionIndex {
            case 0:
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(140))
            default:
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            }

            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.interGroupSpacing = 5
            sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: PersonDetailCollectionViewController.sectionBackgroundDecorationElementKind)
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
            forDecorationViewOfKind: PersonDetailCollectionViewController.sectionBackgroundDecorationElementKind)
        return layout
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) as? PersonDetailViewModel.Cell else { return }
        switch item.actionType {
        case .none: break
        case .call:
            let number = item.value.replacingOccurrences(of: " ", with: "")
            if let url = URL(string: "tel://\(number)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .mail:
            if let url = URL(string: "mailto:\(item.value)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .openURL:
            if let url = URL(string: item.value) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .showRoom: break
        }
    }

    // MARK: - IBActions

    @IBAction func addContactToAddressBook() {
        guard let person = person else { return }

        let contact = CNMutableContact()

        contact.contactType = .person
        if let title = person.title {
            contact.namePrefix = title
        }
        contact.givenName = person.firstName
        contact.familyName = person.name

        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: person.email as NSString)]
        if let organisation = person.organisations.first {
            contact.departmentName = organisation.name
        }

        var phoneNumbers: [CNLabeledValue<CNPhoneNumber>] = person.privateContact.compactMap { info in
            switch info {
            case .phone(let number), .mobilePhone(let number) : return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: number))
            default: return nil
            }
        }

        phoneNumbers.append(contentsOf: person.officialContact.compactMap { info in
            switch info {
            case .phone(let number), .mobilePhone(let number) : return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: number))
            default: return nil
            }
        })

        phoneNumbers.append(contentsOf: person.phoneExtensions.map { phoneExtension in
            return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: phoneExtension.phoneNumber))
        })

        contact.phoneNumbers = phoneNumbers

        if let imageData = person.image?.jpegData(compressionQuality: 1) {
            contact.imageData = imageData
        }

        var urls: [CNLabeledValue<NSString>] = person.privateContact.compactMap{ info in
            switch info {
            case .homepage(let urlString): return CNLabeledValue(label: CNLabelWork, value: urlString as NSString)
            default: return nil
            }
        }

        urls.append(contentsOf: person.officialContact.compactMap { info in
            switch info {
            case .homepage(let urlString): return CNLabeledValue(label: CNLabelWork, value: urlString as NSString)
            default: return nil
            }
        })

        contact.urlAddresses = urls

        contact.organizationName = "TUM"
        if let room = person.rooms.first {
            contact.note = room.locationDescription
        }

        let contactViewController = CNContactViewController(forNewContact: contact)
        contactViewController.contactStore = CNContactStore()
        contactViewController.delegate = self
        navigationController?.pushViewController(contactViewController, animated: true)
    }

    // MARK: - CNContactViewControllerDelegate

    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        navigationController?.popToViewController(self, animated: true)
    }

}
