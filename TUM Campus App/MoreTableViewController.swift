//
//  MoreTableViewController.swift
//  
//
//  Created by Mathias Quintero on 12/8/15.
//
//

import UIKit
import Sweeft
import MessageUI

class MoreTableViewController: UITableViewController, ImageDownloadSubscriber, DetailViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var bibNumber: UILabel!
    @IBOutlet weak var avatarView: UIImageView! {
        didSet {
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = avatarView.frame.width / 2
        }
    }
    
    let secionsForLoggedInUsers = [0, 1]
    let unhighlightedSectionsIfNotLoggedIn = [1] // Best Variable name ever!
    
    var manager: TumDataManager?
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    var isLoggedIn: Bool {
        return user != nil
    }
    
    func updateView() {
        if isLoggedIn {
            nameLabel.text = user?.name
            avatarView.image = user?.image ?? #imageLiteral(resourceName: "avatar")
            logoutLabel.text = "Log Out"
            logoutLabel.textColor = .red
        } else {
            nameLabel.text = "Stranger"
            avatarView.image = #imageLiteral(resourceName: "avatar")
            logoutLabel.text = "Log In"
            logoutLabel.textColor = .green
        }
    }
    
    func updateImageView() {
        updateView()
    }
    
    func dataManager() -> TumDataManager? {
        return manager
    }

}

extension MoreTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let mvc = tabBarController as? CampusTabBarController {
            user = User.shared
            manager = mvc.manager
        }
        if let savedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            bibNumber.text = savedUsername
        } else {
            bibNumber.text = "Not logged in"
        }
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? PersonDetailTableViewController {
            mvc.user = user?.data
        }
        if let mvc = segue.destination as? SearchViewController {
            if (tableView.indexPathForSelectedRow?.section == 2 && tableView.indexPathForSelectedRow?.row == 0) {
//                mvc.searchManagers = [TumDataItems.RoomSearch]
            }
        }
    }
    
}

extension MoreTableViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoggedIn else {
            cell.alpha = 1.0
            return
        }
        if unhighlightedSectionsIfNotLoggedIn.contains(indexPath.section) {
            cell.alpha = 0.5
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        guard !isLoggedIn else {
            return true
        }
        return !secionsForLoggedInUsers.contains(indexPath.section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 2:
            if indexPath.row == 2 {
                self.navigationController?.pushViewController(MVGNearbyStationsViewController(), animated: true)
            }
        case 4:
            
            let systemVersion = UIDevice.current.systemVersion
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]! as! String
            let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"]! as! String
            
            if indexPath.row == 0 {
                if let url =  URL(string: "https://tumcabe.in.tum.de/") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if indexPath.row == 1 {
                sendEmail(recipient: "tca-support.os.in@tum.de", subject: "[iOS]", body: "<br><br>iOS Version: \(systemVersion) <br> App Version: \(appVersion) <br> Build Version: \(buildVersion)")
            }
            
        case 5:
            PersistentUser.reset()
            User.shared = nil
            Usage.value = false
            
            let loginViewController = ViewControllerProvider.loginNavigationViewController
            self.present(loginViewController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func sendEmail(recipient: String, subject: String, body: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([recipient])
            mailVC.setSubject(subject)
            mailVC.setMessageBody(body, isHTML: true)
            
            present(mailVC, animated: true)
        } else {
            print("error can't send mail")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
