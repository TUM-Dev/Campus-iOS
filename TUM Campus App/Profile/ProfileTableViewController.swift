//
//  ProfileTableViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import XMLParsing

final class ProfileTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<Profile,ProfileAPIResponse,XMLDecoder>
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tumIDLabel: UILabel!
    @IBOutlet private weak var signOutLabel: UILabel!

    private let endpoint: URLRequestConvertible = TUMOnlineAPI.identify
    private let sortDescriptor = NSSortDescriptor(keyPath: \Profile.surname, ascending: false)
    private let loginController: AuthenticationHandler = AuthenticationHandler(delegate: nil)
    private let coreDataStack = appDelegate.persistentContainer

    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor)

    private enum Section: Int {
        case profile
        case myTUM
        case general
        case contact
        case login
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        importer.performFetch(success: {
            DispatchQueue.main.async {
                let context = appDelegate.persistentContainer.viewContext
                let profileRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
                if let profile = try? context.fetch(profileRequest).first {
                    self.nameLabel.text = "\(profile.firstname ?? "") \(profile.surname ?? "")"
                    self.tumIDLabel.text = profile.tumID ?? profile.role.rawValue
                }
            }
        })
        
        switch loginController.credentials {
        case .none, .noTumID:
            nameLabel.text = "Not logged in".localized
            signOutLabel.text = "Sign In".localized
            signOutLabel.textColor = .green
        default:
            signOutLabel.text = "Sign Out".localized
            signOutLabel.textColor = .red
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (Section(rawValue: indexPath.section), indexPath.row) {
        case (.myTUM, 0):
            performSegue(withIdentifier: "showTuition", sender: nil)
        case (.general, 1):
            performSegue(withIdentifier: "showTUMSexy", sender: nil)
        case (.contact, 0):
            guard let url = URL(string: "https://www.tum.app") else { return }
            UIApplication.shared.open(url)
        case (.contact, 1):
            guard let url = URL(string: "https://github.com/TUM-Dev/Campus-iOS") else { return }
            UIApplication.shared.open(url)
        case (.contact, 2):
            guard let url = URL(string: "https://www.tum.app") else { return }
            UIApplication.shared.open(url)
        case (.login, 0):
            loginController.logout()
            presentLoginViewController()
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func presentLoginViewController() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: .main)
        guard let navCon = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
        guard let loginViewController = navCon.children.first as? LoginViewController else { return }
        loginViewController.loginController = loginController
        present(navCon, animated: true)
    }

}
