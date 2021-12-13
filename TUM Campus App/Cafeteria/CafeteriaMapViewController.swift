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
    @IBOutlet private var shadowViewBottom: NSLayoutConstraint!
    @IBOutlet private var mensaColViewBottom: NSLayoutConstraint!
    
    private var shadowViewHighAnchor = NSLayoutConstraint()
    private var shadowViewLowAnchor = NSLayoutConstraint()
    private var mensaColViewHighAnchor = NSLayoutConstraint()
    private var mensaColViewLowAnchor = NSLayoutConstraint()
    private var mapViewHighAnchor = NSLayoutConstraint()
    private var mapViewLowAnchor = NSLayoutConstraint()
    private var startYSV = 0.0
        
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
        setupYStartValues()
        setupConstraints()
        setupUI()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        shadowViewHighAnchor.isActive = true
        shadowViewLowAnchor.isActive = false

        mensaColViewHighAnchor.isActive = true
        mensaColViewLowAnchor.isActive = false

        mapViewHighAnchor.isActive = true
        mapViewLowAnchor.isActive = false

        fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        shadowViewHighAnchor.isActive = true
        shadowViewLowAnchor.isActive = false

        mensaColViewHighAnchor.isActive = true
        mensaColViewLowAnchor.isActive = false

        mapViewHighAnchor.isActive = true
        mapViewLowAnchor.isActive = false
    }
    
    func setupConstraints() {
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowViewHighAnchor = NSLayoutConstraint(item: shadowView as Any, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: startYSV)
        shadowViewLowAnchor = NSLayoutConstraint(item: shadowView as Any, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: tabBarController?.tabBar, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -45)
        
        shadowViewBottom.constant = 15
        
        mensaCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mensaColViewHighAnchor = NSLayoutConstraint(item: mensaCollectionView as Any, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: shadowView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 45)
        mensaColViewLowAnchor = NSLayoutConstraint(item: mensaCollectionView as Any, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: tabBarController?.tabBar, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        
        mensaColViewBottom.constant = 0
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapViewHighAnchor = NSLayoutConstraint(item: mapView as Any, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -mensaCollectionView.frame.height/2)
        mapViewLowAnchor = NSLayoutConstraint(item: mapView as Any, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Cafeteria>(collectionView: mensaCollectionView) {
            [weak self] (collectionView: UICollectionView, indexPath: IndexPath, cafeteria: Cafeteria) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CafeteriaCollectionViewCell.reuseIdentifier, for: indexPath) as! CafeteriaCollectionViewCell
            
            cell.configure(cafeteria: cafeteria, currentLocation: self?.locationManager.location)
            
            cell.openMenuBtn.addTarget(self, action: #selector(self?.openMenu(sender:)), for: .touchUpInside)
            cell.openMenuBtn.caf = cafeteria
            
            cell.backgroundColor = self!.view.backgroundColor
                                                
            return cell
        }
    }
    
    @objc func openMenu(sender : OpenMenuBtnClass){
        guard let destination = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MealPlanTableViewController") as? MealPlanTableViewController else { return }
        destination.cafeteria = sender.caf
        navigationController?.pushViewController(destination, animated: true)
    }
    
    private func setupUI() {
        
        self.view.bringSubviewToFront(mensaCollectionView)
        self.view.bringSubviewToFront(shadowView)
                        
        mensaCollectionView.contentInsetAdjustmentBehavior = .always
        mensaCollectionView.backgroundColor = UIColor.systemGray6
        mensaCollectionView.layer.cornerRadius = 15
        
        mensaCollectionView.layer.masksToBounds = true
        
        view.bringSubviewToFront(mensaCollectionView)
        
        shadowView.backgroundColor = UIColor.systemGray6
        shadowView.layer.cornerRadius = 15
        
        shadowView.layer.masksToBounds = false
                
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 25
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 15)
        
        self.tabBarController?.tabBar.backgroundColor = self.view.backgroundColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController?.tabBar.isOpaque = true
        
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
        
        let config = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular, scale: .large)
        centerMapOnUserBtn.setImage(UIImage(systemName: "location", withConfiguration: config), for: UIControl.State.normal)
        mensaCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    private func colViewAutoScroll() {
        if let topIndex = mensaCollectionView.indexPathsForVisibleItems.min() {
            mensaCollectionView.scrollToItem(at: topIndex, at: .top, animated: true)
        }
    }
    
   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        colViewAutoScroll()
    }
    
   func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            colViewAutoScroll()
        }
    }
    
    //MARK: - Location & Map
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
    private func checkLocationAuthorization() {
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
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        mapView.pointOfInterestFilter = .includingAll
        mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let config = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular, scale: .large)
        centerMapOnUserBtn.setImage(UIImage(systemName: "location", withConfiguration: config), for: UIControl.State.normal)

        let mapPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        mapPanGesture.delegate = self
        mapView.addGestureRecognizer(mapPanGesture)
    }
    
    @objc func didDragMap(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            let config = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular, scale: .large)
            centerMapOnUserBtn.setImage(UIImage(systemName: "location", withConfiguration: config), for: UIControl.State.normal)
        }
    }
    
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func setupCenterMapOnUserBtn() {
        centerMapOnUserBtn.setTitle("", for: UIControl.State.normal)
        centerMapOnUserBtn.layer.cornerRadius = 5
        
        centerMapOnUserBtn.translatesAutoresizingMaskIntoConstraints = false
        
        centerMapOnUserBtn.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 7.5).isActive = true
        centerMapOnUserBtn.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 10).isActive = true
        centerMapOnUserBtn.widthAnchor.constraint(equalTo: centerMapOnUserBtn.imageView!.widthAnchor, constant: 10).isActive = true
        centerMapOnUserBtn.heightAnchor.constraint(equalTo: centerMapOnUserBtn.imageView!.heightAnchor, constant: 12.5).isActive = true
    }
    
    @IBAction func centerMapOnUser(_ sender: Any) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion( center: location, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
            mapView.setRegion(region, animated: true)
        }
        let config = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular, scale: .large)
        centerMapOnUserBtn.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: UIControl.State.normal)
    }
    
    private func setupYStartValues() {
        let h = self.view.frame.size.height
        startYSV = (h * 1.8)/3.0
    }
        
    @IBAction func panColView(_ sender: UIPanGestureRecognizer) {
        let tabBarTop: CGFloat
        
        if let tabBar = tabBarController?.tabBar {
            tabBarTop = tabBar.center.y - tabBar.frame.size.height/2
        } else { tabBarTop = self.view.frame.size.height }
        
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view)
        
            if sender.location(in: self.view).y > startYSV || sender.location(in: self.view).y == startYSV {
                if sender.location(in: self.view).y < tabBarTop {
                    mensaCollectionView.center = CGPoint(x: mensaCollectionView.center.x, y: mensaCollectionView.center.y + translation.y)
                    shadowView.center = CGPoint(x: shadowView.center.x, y: shadowView.center.y + translation.y)
                    
                    mapView.center = CGPoint(x: mapView.center.x, y: mapView.center.y + translation.y/2)
                    
                    sender.setTranslation(CGPoint.zero, in: self.view)
                }
            }
        }
        
        if sender.state == .ended || sender.state == .cancelled {
            let viewQuarter = self.view.center.y * 1.5
            let shadowViewHeight = shadowView.frame.height
            
            if sender.location(in: self.view).y < viewQuarter {
                shadowView.center = CGPoint(x: shadowView.center.x, y: startYSV + shadowViewHeight/2)
                mensaCollectionView.center = CGPoint(x: mensaCollectionView.center.x, y: shadowView.center.y + 15)
                sender.setTranslation(CGPoint.zero, in: self.view)
                
                shadowViewLowAnchor.isActive = false
                shadowViewHighAnchor.isActive = true
                shadowViewBottom.constant = 15
                shadowView.updateConstraints()
                
                mensaColViewLowAnchor.isActive = false
                mensaColViewHighAnchor.isActive = true
                mensaColViewBottom.constant = 0
                mensaCollectionView.updateConstraints()
                
                mapViewLowAnchor.isActive = false
                mapViewHighAnchor.isActive = true
                mapView.updateConstraints()
                
            } else if sender.location(in: self.view).y > viewQuarter {
                if let tabBar = tabBarController?.tabBar {
                    shadowView.center = CGPoint(x: shadowView.center.x, y: self.view.frame.size.height - tabBar.frame.size.height - 45 + shadowViewHeight/2)
                    mensaCollectionView.center = CGPoint(x: mensaCollectionView.center.x, y: shadowView.center.y + 20)
                    sender.setTranslation(CGPoint.zero, in: self.view)
                }
                
                shadowViewLowAnchor.isActive = true
                shadowViewHighAnchor.isActive = false
                shadowViewBottom.constant = startYSV*2*(1.1/3.0)
                shadowView.updateConstraints()
                
                mensaColViewLowAnchor.isActive = true
                mensaColViewHighAnchor.isActive = false
                mensaColViewBottom.constant = startYSV*2*(1.1/3.0)
                mensaCollectionView.updateConstraints()
                
                mapViewLowAnchor.isActive = true
                mapViewHighAnchor.isActive = false
                mapView.updateConstraints()
            }
        }
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
        
        let region = MKCoordinateRegion( center: view.annotation!.coordinate, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
        mapView.setRegion(region, animated: true)
        
        let config = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular, scale: .large)
        centerMapOnUserBtn.setImage(UIImage(systemName: "location", withConfiguration: config), for: UIControl.State.normal)
    }
}

extension CafeteriaMapViewController: UICollectionViewDelegateFlowLayout {

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 6, height: 80.0)
    }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
