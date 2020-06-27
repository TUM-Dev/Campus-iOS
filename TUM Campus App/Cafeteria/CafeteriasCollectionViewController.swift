//
//  CafeteriasTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

final class CafeteriasCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, CLLocationManagerDelegate {
    private let endpoint = EatAPI.canteens
    private let sessionManager = Session.defaultSession
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    private var mapCentered = false
    private var stretchyHeaderView: CafeteriaSectionHeader?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Cafeteria>?


    private enum Section: CaseIterable {
        case main
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        setupHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        fetch()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.stopUpdatingLocation()
        mapCentered = false
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Cafeteria>(collectionView: collectionView) {
            [weak self] (collectionView: UICollectionView, indexPath: IndexPath, cafeteria: Cafeteria) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CafeteriaCollectionViewCell.reuseIdentifier, for: indexPath) as! CafeteriaCollectionViewCell

            cell.configure(cafeteria: cafeteria, currentLocation: self?.locationManager.location)

            return cell
        }
    }

    private func setupHeader() {
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CafeteriaSectionHeader.identifier, for: indexPath) as? CafeteriaSectionHeader else { return UICollectionReusableView() }
            self?.stretchyHeaderView = header
            let cafeterias = self?.dataSource?.snapshot().itemIdentifiers ?? []
            header.mapView.addAnnotations(cafeterias)
            header.mapView.delegate = self
            header.isAccessibilityElement = true
            header.accessibilityLabel = "Cafeteria Map".localized
            return header
        }
    }

    private func setupUI() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .zero
        }

        let headerNib = UINib(nibName: CafeteriaSectionHeader.nibName, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CafeteriaSectionHeader.identifier)
        collectionView.contentInsetAdjustmentBehavior = .always

        title = "Cafeterias".localized
    }

    private func fetch() {
        sessionManager.request(endpoint).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { [weak self] response in
            var cafeterias: [Cafeteria] = response.value ?? []
            if let currentLocation = self?.locationManager.location {
                cafeterias.sortByDistance(to: currentLocation)
            }
            self?.stretchyHeaderView?.mapView.addAnnotations(response.value ?? [])

            var snapshot = NSDiffableDataSourceSnapshot<Section, Cafeteria>()
            snapshot.appendSections([.main])
            snapshot.appendItems(cafeterias, toSection: .main)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destination = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MealPlanTableViewController") as? MealPlanTableViewController else { return }
        destination.cafeteria = dataSource?.itemIdentifier(for: indexPath)
        navigationController?.pushViewController(destination, animated: true)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { CGSize(width: collectionView.bounds.width * 0.95, height: CGFloat(100)) }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { .init(width: view.frame.width, height: 340) }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0) }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        var cafeterias = dataSource?.snapshot().itemIdentifiers ?? []
        cafeterias.sortByDistance(to: location)

        var snapshot = NSDiffableDataSourceSnapshot<Section, Cafeteria>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cafeterias, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)

        if !mapCentered {
            var closestCanteens = cafeterias.prefix(3).map { $0.coordinate }
            closestCanteens.append(location.coordinate)
            let region: MKCoordinateRegion

            if closestCanteens.count > 1 {
                region = MKCoordinateRegion(coordinates: closestCanteens)
            } else {
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
            
            stretchyHeaderView?.mapView.setRegion(region, animated: true)
            mapCentered = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
