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
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyRoomCell", for: indexPath) as! StudyRoomCell
        
        cell.roomNameLabel.text = rooms[indexPath.row].name
        cell.roomNumberLabel.text = rooms[indexPath.row].code
        cell.roomStatusLabel.text = rooms[indexPath.row].status
        
        return cell
    }
}
