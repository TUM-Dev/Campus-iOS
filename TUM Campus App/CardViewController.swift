//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell

class CardViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "logo-white")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.navigationItem.titleView = imageView
        if let bounds = imageView.superview?.bounds {
            imageView.frame = CGRectMake(bounds.origin.x+10, bounds.origin.y+10, bounds.width-20, bounds.height-20)
        }
        imageView.clipsToBounds = true
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = UIColor.clearColor()
        let dataManager = TumDataManager()
        let cafeteriasManager = CafeteriaManager(mainManager: dataManager)
        cafeteriasManager.fetchData() { (response) in
            print(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return filmCell()
    }
    
    func filmCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("film") as? TUFilmCardCell ?? TUFilmCardCell()
        cell.movie = Movie()
        let handler = { () -> () in
            if let path = self.tableView.indexPathForCell(cell) {
                self.tableView.deleteRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Top)
            }
        }
        cell.defaultColor = tableView.backgroundColor
        cell.setSwipeGestureWithView(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State1) { (void) in handler() }
        cell.setSwipeGestureWithView(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State2) { (void) in handler() }
        cell.setSwipeGestureWithView(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State3) { (void) in handler() }
        cell.setSwipeGestureWithView(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State4) { (void) in handler() }
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}

