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
            user = mvc.user
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
    }
    
}

extension MoreTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 4:
            if let url =  URL(string: indexPath.row == 0 ? "https://tumcabe.in.tum.de/" : "mailto://tca-support.os.in@tum.de") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 5:
            UserDefaults.standard.removeObject(forKey: LoginDefaultsKeys.Token.rawValue)
            let storyboard = UIStoryboard(name: "Setup", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
        default:
            break
        }
    }
    
}
