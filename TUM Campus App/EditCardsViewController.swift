//
//  EditCardsViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

protocol EditCardsViewControllerDelegate {
    func didUpdateCards()
}


class EditCardsViewController: UITableViewController {
    
    var delegate: EditCardsViewControllerDelegate?
    var enabled: [CardKey] {
        get {
            return PersistentCardOrder.value.cards
        }
        set {
            PersistentCardOrder.value.cards = newValue
            delegate?.didUpdateCards()
        }
    }
    
    var disabled: [CardKey] {
        return (CardKey.all - enabled).array
    }
    
    var arrays: [[CardKey]] {
        return [enabled, disabled]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEditing(true, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Enabled"
        case 1:
            return "Disabled"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return enabled.count
        case 1:
            return disabled.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "card", for: indexPath)
        cell.textLabel?.text = arrays[indexPath.section][indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        switch indexPath.section {
        case 0:
            return .delete
        case 1:
            return .insert
        default:
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if destinationIndexPath.section == 0 {
            enabled.move(itemAt: sourceIndexPath.row, to: destinationIndexPath.row)
        } else {
            enabled.remove(at: sourceIndexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("Editing!!!")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            enabled.remove(at: indexPath.row)
            tableView.reloadData()
        case 1:
            enabled.append(disabled[indexPath.row])
            tableView.reloadData()
        default:
            break
        }
    }
    
    @IBAction func pressedDone(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
