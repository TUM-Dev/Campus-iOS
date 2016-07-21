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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let mvc = tabBarController as? CampusTabBarController {
            user = mvc.user
            manager = mvc.manager
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if var mvc = segue.destinationViewController as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destinationViewController as? PersonDetailTableViewController {
            mvc.user = user?.data
        }
    }
    
}

extension MoreTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 4:
            if let url =  NSURL(string: indexPath.row == 0 ? "https://tumcabe.in.tum.de/" : "mailto://tca-support.os.in@tum.de") {
                UIApplication.sharedApplication().openURL(url)
            }
        case 5:
            NSUserDefaults.standardUserDefaults().removeObjectForKey(LoginDefaultsKeys.Token.rawValue)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("Login")
            UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        default:
            break
        }
    }
    
}
