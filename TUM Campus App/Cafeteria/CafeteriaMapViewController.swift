//
//  CafeteriaMapViewController.swift
//  TUMCampusApp
//
//  Created by AW on 05.10.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class CafeteriaMapViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var centerMapOnUserBtn: UIButton!
    @IBOutlet private weak var mensaCollectionView: UICollectionView!
    @IBOutlet private weak var shadowView: UIView!
    
    private let endpoint = EatAPI.canteens
    private let sessionManager = Session.defaultSession
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Cafeteria>?
    
    private enum Section: CaseIterable {
        case main
    }
    
    private var allCafs: [Cafeteria] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setupCenterMapOnUserBtn()
        setupDataSource()
        setupUI()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        fetch()
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Cafeteria>(collectionView: mensaCollectionView) {
            [weak self] (collectionView: UICollectionView, indexPath: IndexPath, cafeteria: Cafeteria) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CafeteriaCollectionViewCell.reuseIdentifier, for: indexPath) as! CafeteriaCollectionViewCell
            
            cell.configure(cafeteria: cafeteria, currentLocation: self?.locationManager.location)
            
            cell.openMenuBtn.addTarget(self, action: #selector(self!.openMenu(sender:)), for: .touchUpInside)
            cell.openMenuBtn.caf = cafeteria
                                    
            return cell
        }
    }
    
    @objc func openMenu(sender : OpenMenuBtnClass){
        guard let destination = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MealPlanTableViewController") as? MealPlanTableViewController else { return }
        destination.cafeteria = sender.caf
        navigationController?.pushViewController(destination, animated: true)
    }
    
    private func setupUI() {
        if let layout = mensaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .zero
        }
                
        mensaCollectionView.contentInsetAdjustmentBehavior = .always
        mensaCollectionView.backgroundColor = UIColor.systemGray6
        mensaCollectionView.layer.cornerRadius = 20
        
        view.bringSubviewToFront(mensaCollectionView)
        mensaCollectionView.layer.masksToBounds = true
        
        shadowView.layer.cornerRadius = 20
        
        shadowView.layer.masksToBounds = false
                
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowPath = UIBezierPath(rect: mensaCollectionView.bounds).cgPath
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowRadius = 20
        shadowView.layer.shadowOffset = CGSize(width: 20, height: 20)
        
        self.tabBarController?.tabBar.backgroundColor = .white
        
        title = "Cafeterias".localized
    }
    
    private func fetch() {
        sessionManager.request(endpoint).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { [weak self] response in
            var cafeterias: [Cafeteria] = response.value ?? []
            if let currentLocation = self?.locationManager.location {
                cafeterias.sortByDistance(to: currentLocation)
            }
            
            self?.mapView.addAnnotations(response.value ?? [])
            
            self?.allCafs = cafeterias

            var snapshot = NSDiffableDataSourceSnapshot<Section, Cafeteria>()
            snapshot.appendSections([.main])
            snapshot.appendItems(cafeterias, toSection: .main)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destination: Cafeteria = dataSource?.itemIdentifier(for: indexPath) else { return }
        let region = MKCoordinateRegion( center: destination.coordinate, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
        mapView.setRegion(region, animated: true)
        
        centerMapOnUserBtn.setImage(UIImage(systemName: "location"), for: UIControl.State.normal)
        mensaCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    //MARK: - Location & Map
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            setupMapView()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func setupMapView() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        mapView.pointOfInterestFilter = .includingAll
        mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: -30, right: 0)
        mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.75/3.0).isActive = true

        let mapPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        mapPanGesture.delegate = self
        mapView.addGestureRecognizer(mapPanGesture)
    }
    
    @objc func didDragMap(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            centerMapOnUserBtn.setImage(UIImage(systemName: "location"), for: UIControl.State.normal)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setupCenterMapOnUserBtn() {
        centerMapOnUserBtn.setTitle("", for: UIControl.State.normal)
        
        centerMapOnUserBtn.translatesAutoresizingMaskIntoConstraints = false
        
        centerMapOnUserBtn.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -25).isActive = true
        centerMapOnUserBtn.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 15).isActive = true
        centerMapOnUserBtn.widthAnchor.constraint(equalTo: centerMapOnUserBtn.imageView!.widthAnchor, constant: 7.5).isActive = true
        centerMapOnUserBtn.heightAnchor.constraint(equalTo: centerMapOnUserBtn.imageView!.heightAnchor, constant: 10).isActive = true
    }
    
    @IBAction func centerMapOnUser(_ sender: Any) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion( center: location, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
            mapView.setRegion(region, animated: true)
        }
                
        centerMapOnUserBtn.setImage(UIImage(systemName: "location.fill"), for: UIControl.State.normal)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //
    }
}
 
extension CafeteriaMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let name = view.annotation!.title
                
        for i in 0...(allCafs.count - 1) {
            let index = IndexPath(row: i, section: 0)
            let cafeteria = allCafs[i]

            if name == cafeteria.title {
                mensaCollectionView.scrollToItem(at: index, at: .top, animated: true)
            }
        }
    }
}

extension CafeteriaMapViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

