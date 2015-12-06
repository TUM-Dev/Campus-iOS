//
//  MovieDetailTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import AYSlidingPickerView

class MovieDetailTableViewController: UITableViewController, TumDataReceiver {
    
    var pickerView = AYSlidingPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        delegate?.dataManager().getMovies(self)
        title = "Tap To Select Movie"
    }
    
    var delegate: DetailViewDelegate?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for movie in movies {
            let item = AYSlidingPickerViewItem(title: movie.name) { (did) in
                if did {
                    self.currentMovie = movie
                    self.tableView.reloadData()
                }
            }
            items.append(item)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.mainView = view
        pickerView.items = items
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        pickerView.addGestureRecognizersToNavigationBar(navigationController?.navigationBar)
    }
    
    func receiveData(data: [DataElement]) {
        movies.removeAll()
        for element in data {
            if let movieElement = element as? Movie {
                movies.append(movieElement)
                if currentMovie == nil {
                    currentMovie = movieElement
                }
            }
        }
        setUpPickerView()
    }

    var currentMovie: Movie? {
        didSet {
            if let movie = currentMovie {
                let info = movie.name.componentsSeparatedByString(": ")
                titleLabel.text = info[1]
                dateLabel.text = info[0]
                yearLabel.text = movie.year.description
                ratingLabel.text = "★ " + movie.rating.description
                runTimeLabel.text = movie.runtime.description + " min"
                genreLabel.text = movie.genre
                actorsLabel.text = movie.actors
                directorLabel.text = movie.director
                descriptionLabel.text = movie.description
                posterView.image = movie.image
            }
        }
    }
    
    var movies = [Movie]()
    
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}
