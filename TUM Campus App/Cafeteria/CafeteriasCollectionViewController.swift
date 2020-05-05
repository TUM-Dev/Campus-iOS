//
//  CafeteriasTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class CafeteriasCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    typealias ImporterType = Importer<Cafeteria,[Cafeteria],JSONDecoder>
    
    let endpoint: URLRequestConvertible = EatAPI.canteens
    let sortDescriptor = NSSortDescriptor(keyPath: \ImporterType.EntityType.name, ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor)
//    lazy var menuImporter = Importer<Menu,MensaAPIResponse,JSONDecoder>(endpoint: TUMDevAppAPI.cafeterias, sortDescriptor: NSSortDescriptor(keyPath: \Menu.date, ascending: false), dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    var selectedIndexPath: IndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importer.fetchedResultsControllerDelegate = self
        importer.performFetch() { error in
            print(error)
        }
//        menuImporter.performFetch() { error in
//            print(error)
//        }

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Cafeterias"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! importer.fetchedResultsController.performFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetViewController = segue.destination as? CafeteriaDetailCollectionViewController, let indexPath = selectedIndexPath else { return }
        guard let cafeteria = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
        targetViewController.cafeteria = cafeteria
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CafeteriaCell", for: indexPath) as! CafeteriaCollectionViewCell
        guard let cafeteria = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }
        cell.configure(cafeteria)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(240))
    }

}
