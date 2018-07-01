//
//  MoreTableViewController.swift
//  
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import Sweeft
import MessageUI

class MoreTableViewController: UITableViewController, DetailView, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
    
    var config: Config? {
        return delegate?.dataManager()?.config
    }
    
    var isLoggedIn: Bool {
        return user != nil
    }
    
    func updateView() {
        if isLoggedIn {
            nameLabel.text = user?.data?.name
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
            
            if indexPath.row == 0 {
                config?.tumCabeHomepage.open(sender: self)
            } else if indexPath.row == 1 {
                sendEmail(recipient: "app@tum.de",
                          subject: "[iOS]",
                          body: "<br><br>iOS Version: \(systemVersion) <br> App Version: \(Bundle.main.version) <br> Build Version: \(Bundle.main.build)")
            }
            
        case 5:
            delegate?.dataManager()?.logout()
            
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

