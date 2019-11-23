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

class ProfileTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<Profile,ProfileAPIResponse,XMLDecoder>
    
    let endpoint: URLRequestConvertible = TUMOnlineAPI.identify
    let sortDescriptor = NSSortDescriptor(keyPath: \Profile.surname, ascending: false)
    let loginController: AuthenticationHandler = AuthenticationHandler(delegate: nil)
    let coreDataStack = appDelegate.persistentContainer

    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor)
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tumIDLabel: UILabel!
    @IBOutlet weak var signOutLabel: UILabel!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = true
        
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
            nameLabel.text = "Not logged in"
            signOutLabel.text = "Sign In"
            signOutLabel.textColor = .green
        default:
            signOutLabel.text = "Sign Out"
            signOutLabel.textColor = .red
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (1,0):
            performSegue(withIdentifier: "showTuition", sender: nil)
        case (2,1):
            performSegue(withIdentifier: "showTUMSexy", sender: nil)
        case (4,0):
            loginController.logout()
            presentLoginViewController()
        default:
            break
        }
        
    }
    
    private func presentLoginViewController() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: .main)
        guard let navCon = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
        guard let loginViewController = navCon.children.first as? LoginViewController else { return }
        loginViewController.loginController = loginController
        self.present(navCon, animated: true)
    }

}
