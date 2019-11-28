//
//  StudyRoomTableViewController.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData

class StudyRoomTableViewController: UITableViewController{
    var rooms : [StudyRoom] = []
    
    var dateFomatter = DateFormatter()
    var secondDateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        rooms.sort(by: { (lhs, rhs) -> Bool in
            if let lhsCode = lhs.code{
                if let rhsCode = rhs.code{
                    if lhsCode==rhsCode{
                        return true
                    }else{
                        return lhsCode<rhsCode
                    }
                }else{
                    rhs.code = ""
                }
            }else{
                lhs.code = ""
            }
            return lhs.code! < rhs.code!
        })
            
        rooms.sort(by: { (lhs, rhs) -> Bool in
            if let lhsName = lhs.name{
                if let rhsName = rhs.name{
                    if lhsName==rhsName{
                        return true
                    }else{
                        return lhsName>rhsName
                    }
                }else{
                    rhs.name = ""
                }
            }else{
                lhs.name = ""
            }
            return lhs.name! > rhs.name!
        })
        
        rooms.sort(by: { (lhs, rhs) -> Bool in
            if lhs.status==rhs.status{
                return true
            }else if lhs.status == "frei"{
                return true
            }else if lhs.status == "belegt" {
                if rhs.status == "frei"{
                    return false
                }else{
                    return true
                }
            }
            return false
        })
        
        dateFomatter.locale = Locale.init(identifier: "de_DE")
        dateFomatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        secondDateFormatter.locale = Locale.current
        secondDateFormatter.dateFormat = "HH:mm"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyRoomCell", for: indexPath) as! StudyRoomCell
        
        cell.roomNameLabel.text = rooms[indexPath.row].name
        cell.roomNumberLabel.text = rooms[indexPath.row].code
        switch rooms[indexPath.row].status {
        case "frei":
            cell.roomStatusLabel.textColor = .systemGreen
            cell.roomStatusLabel.text = "Free"
        case "belegt":
            cell.roomStatusLabel.textColor = .systemRed
            
            guard let occupiedUntilString = rooms[indexPath.row].occupiedUntil else{return cell}
            guard let occupiedUntilDate = dateFomatter.date(from: occupiedUntilString) else{return cell}
            
            cell.roomStatusLabel.text = "Occupied until \(secondDateFormatter.string(from: occupiedUntilDate))"
            
        default:
            cell.roomStatusLabel.textColor = .systemGray
            cell.roomStatusLabel.text = "Unknown"
        }
        return cell
    }
}
