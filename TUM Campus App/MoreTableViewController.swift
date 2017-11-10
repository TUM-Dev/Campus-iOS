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

class MoreTableViewController: UITableViewController, DetailView, MFMailComposeViewControllerDelegate {
    
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
    weak var delegate: DetailViewDelegate?
    
    var binding: ImageViewBinding?
    
    var user: User? {
        return delegate?.dataManager()?.user
    }
    
    var isLoggedIn: Bool {
        return user != nil
    }
    
    func updateView() {
        if isLoggedIn {
            nameLabel.text = user?.name
            binding = user?.data?.avatar.bind(to: avatarView, default: #imageLiteral(resourceName: "avatar"))
            logoutLabel.text = "Log Out"
            logoutLabel.textColor = .red
        } else {
            nameLabel.text = "Stranger"
            avatarView.image = #imageLiteral(resourceName: "avatar")
            logoutLabel.text = "Log In"
            logoutLabel.textColor = .green
        }
    }

}

extension MoreTableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        if user?.data == nil {
            delegate?.dataManager()?.userDataManager.fetch().onResult(in: .main) { _ in
                self.updateView()
            }
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
            mvc.delegate = delegate
        }
        if let mvc = segue.destination as? PersonDetailTableViewController {
            mvc.user = user?.data
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showPersonDetail" {
            return user?.data != nil
        }
        return true
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
        case 4:
            
            let systemVersion = UIDevice.current.systemVersion
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]! as! String
            let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"]! as! String
            
            if indexPath.row == 0 {
                "https://tumcabe.in.tum.de/".url?.open(sender: self)
            } else if indexPath.row == 1 {
                sendEmail(recipient: "tca-support.os.in@tum.de", subject: "[iOS]", body: "<br><br>iOS Version: \(systemVersion) <br> App Version: \(appVersion) <br> Build Version: \(buildVersion)")
            }
            
        case 5:
            delegate?.dataManager()?.loginManager.logOut()
            
            let loginViewController = ViewControllerProvider.loginNavigationViewController
            // Since this is a shared object, we want to bring it into a usable state for the user before showing it
            // Without popping to the root view controller, we would show the wait for token view controller if the
            // user logged in and out and wanted to log in again in the same session.
            (loginViewController as? UINavigationController)?.popToRootViewController(animated: false)
            self.present(loginViewController, animated: true)
        
        case 6:
            delegate?.dataManager()?.config.betaApp.open(sender: self)
            
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
            
            self.present(mailVC, animated: true)
        } else {
            print("error can't send mail")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

