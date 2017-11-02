//
//  MovieDetailTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import AYSlidingPickerView

class MovieDetailTableViewController: UITableViewController, DetailView {
    
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
    var pickerView = AYSlidingPickerView()
    var barItem: UIBarButtonItem?
    
    weak var delegate: DetailViewDelegate?
    
    var binding: ImageViewBinding?

    var currentMovie: Movie? {
        didSet {
            binding = nil
            if let movie = currentMovie {
                let info = movie.name.components(separatedBy: ": ")
                titleLabel.text = movie.text
                dateLabel.text = info[0]
                title = movie.text
                yearLabel.text = movie.year.description
                ratingLabel.text = "★ " + movie.rating.description
                runTimeLabel.text = movie.runtime.description + " min"
                genreLabel.text = movie.genre
                actorsLabel.text = movie.actors
                directorLabel.text = movie.director
                descriptionLabel.text = movie.description
                binding = movie.poster.bind(to: posterView, default: #imageLiteral(resourceName: "movie"))
                tableView.reloadData()
            }
        }
    }
    
    var movies = [Movie]()
}

extension MovieDetailTableViewController {
    
    func fetch() {
        delegate?.dataManager()?.movieManager.fetch().onSuccess(in: .main) { movies in
            self.movies = movies
            self.currentMovie = movies.first
            self.setUpPickerView()
        }
    }
    
}

extension MovieDetailTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        self.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
}

extension MovieDetailTableViewController {
   
    func showMovies(_ send: AnyObject?) {
        pickerView.show()
        barItem?.action = #selector(MovieDetailTableViewController.hideMovies(_:))
        barItem?.image = UIImage(named: "collapse")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func hideMovies(_ send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = #selector(MovieDetailTableViewController.showMovies(_:))
        barItem?.image = UIImage(named: "expand")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for movie in movies {
            let item = AYSlidingPickerViewItem(title: movie.name) { (did) in
                if did {
                    self.currentMovie = movie
                    self.barItem?.action = #selector(MovieDetailTableViewController.showMovies(_:))
                    self.barItem?.image = UIImage(named: "expand")
                    self.tableView.reloadData()
                }
            }
            items.append(item!)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.mainView = navigationController?.view ?? view
        pickerView.items = items
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        pickerView.didDismissHandler = { self.hideMovies(nil) }
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(MovieDetailTableViewController.showMovies(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
}
