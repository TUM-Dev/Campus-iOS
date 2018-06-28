//
//  MovieDetailTableViewController.swift
//  TUM Campus App
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
    @IBOutlet weak var websiteCell: UITableViewCell!
    
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
//            self.setUpPickerView()
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

extension MovieDetailTableViewController: TUMPickerControllerDelegate {
    typealias Element = Movie
    
    @objc func showMovies(_ send: AnyObject?) {
        let pickerView = TUMPickerController(elements: movies, delegate: self)
        present(pickerView, animated: true)
    }
    
    func didSelect(element: Movie) {
        currentMovie = element
    }
}

extension MovieDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return tableView.cellForRow(at: indexPath) == websiteCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) == websiteCell else { return }
        currentMovie?.url?.open(sender: self)
    }
    
}
