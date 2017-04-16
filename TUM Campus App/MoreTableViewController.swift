//
//  MoreTableViewController.swift
//  
//
//  Created by Mathias Quintero on 12/8/15.
//
//

import UIKit

class MoreTableViewController: UITableViewController, ImageDownloadSubscriber, DetailViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView! {
        didSet {
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = avatarView.frame.width / 2
        }
    }
    
    var manager: TumDataManager?
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        nameLabel.text = user?.name
        avatarView.image = user?.image ?? UIImage(named: "avatar")
    }
    
    func updateImageView() {
        updateView()
    }
    
    func dataManager() -> TumDataManager {
        return manager ?? TumDataManager(user: nil)
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
                mvc.searchManagers = [TumDataItems.RoomSearch]
            }
        }
    }
    
}

extension MoreTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            if indexPath.row == 1 {
                handleNotYetImplemented()  // MVV
            }
        case 3:
            if indexPath.row == 1 || indexPath.row == 2 {
                handleNotYetImplemented()  // Services and Default Campus
            }
        case 4:
            if let url =  URL(string: indexPath.row == 0 ? "https://tumcabe.in.tum.de/" : "mailto://tca-support.os.in@tum.de") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 5:
            PersistentUser.reset()
            let storyboard = UIStoryboard(name: "Setup", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
        default:
            break
        }
    }
    
}

extension MoreTableViewController {
    func handleNotYetImplemented() {
        let alert = UIAlertController(title: "Not Yet Implemented!", message: "This feature will come soon. Stay tuned!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
