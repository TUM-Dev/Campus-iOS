//
//  CafeteriasTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import Alamofire

final class CafeteriasCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let endpoint: URLRequestConvertible = EatAPI.canteens
    let sessionManager: Session = Session.defaultSession
    var cafeterias: [Cafeteria] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Cafeterias"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }

    private func fetch() {
        sessionManager.request(endpoint).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { response in
            self.cafeterias = response.value ?? []
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cafeterias.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CafeteriaCell", for: indexPath) as! CafeteriaCollectionViewCell
        let cafeteria = cafeterias[indexPath.row]
        cell.configure(cafeteria)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destination = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MealPlanTableViewController") as? MealPlanTableViewController else { return }
        destination.cafeteria = cafeterias[indexPath.row]
        navigationController?.pushViewController(destination, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(120))
    }

}
