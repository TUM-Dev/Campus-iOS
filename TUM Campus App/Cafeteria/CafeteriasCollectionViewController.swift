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
    private let endpoint: URLRequestConvertible = EatAPI.canteens
    private let sessionManager: Session = Session.defaultSession
    private let locationManager: CLLocationManager = CLLocationManager()
    private var mapCentered = false

    private var stretchyHeaderView: CafeteriaSectionHeader?

    private var cafeterias: [Cafeteria] = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, Cafeteria>?


    private enum Section: CaseIterable {
        case main
    }


    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        setupHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLocationManager()
        fetch()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapCentered = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.stopUpdatingLocation()
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Cafeteria>(collectionView: collectionView) {
            [weak self] (collectionView: UICollectionView, indexPath: IndexPath, cafeteria: Cafeteria) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CafeteriaCell", for: indexPath) as! CafeteriaCollectionViewCell
            cell.configure(cafeteria)
            if let currentLocation = self?.locationManager.location {
                let distanceFormatter = MKDistanceFormatter()
                distanceFormatter.unitStyle = .abbreviated
                let distance = cafeteria.coordinate.location.distance(from: currentLocation)
                cell.distanceLabel.text = distanceFormatter.string(fromDistance: distance)
            } else {
                cell.distanceLabel.text = ""
            }
            return cell
        }
    }

    private func setupHeader() {
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CafeteriaSectionHeader.identifier, for: indexPath) as? CafeteriaSectionHeader else { return UICollectionReusableView() }
            self?.stretchyHeaderView = header
            header.mapView.addAnnotations(self?.cafeterias ?? [])
            header.mapView.delegate = self
            return header
        }
    }

    private func setupLocationManager() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }

    private func setupUI() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .zero
        }

        let headerNib = UINib(nibName: CafeteriaSectionHeader.nibName, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CafeteriaSectionHeader.identifier)
        collectionView.contentInsetAdjustmentBehavior = .always

        title = "Cafeterias"
    }

    private func fetch() {
        sessionManager.request(endpoint).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { [weak self] response in
            self?.cafeterias = response.value ?? []
            if let currentLocation = self?.locationManager.location {
                self?.cafeterias.sortByDistance(to: currentLocation)
            }
            self?.stretchyHeaderView?.mapView.addAnnotations(response.value ?? [])

            var snapshot = NSDiffableDataSourceSnapshot<Section, Cafeteria>()
            snapshot.appendSections([.main])
            snapshot.appendItems(response.value ?? [], toSection: .main)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.95, height: CGFloat(120))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 340)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }


    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if !mapCentered {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            stretchyHeaderView?.mapView.setRegion(region, animated: true)
            mapCentered = true
        }

        cafeterias.sortByDistance(to: location)

        var snapshot = NSDiffableDataSourceSnapshot<Section, Cafeteria>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cafeterias, toSection: .main)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
