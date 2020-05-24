//
//  RoomViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 24.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

final class RoomViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var purposeLabel: UILabel!
    private let sessionManager: Session = Session.defaultSession
    private var maps: [UIImage] = []
    private var coordinates: CLLocationCoordinate2D?
    var room: Room? {
        didSet {
            fetchMapImages()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.delegate = self
        collectionView.dataSource = self
        title = room?.roomCode
        nameLabel.text = room?.info
        purposeLabel.text = room?.purpose
        addressLabel.text = room?.address
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func fetchMapImages() {
        guard let room = room else { return }
        maps = []
        let mapsEndpoint = TUMCabeAPI.roomMaps(room: room.id)
        sessionManager.request(mapsEndpoint).responseDecodable(of: [RoomMap].self, decoder: JSONDecoder()) { [weak self] response in
            response.value?.forEach {
                let mapImageEndpoint = TUMCabeAPI.mapImage(room: room.id, id: $0.id)
                self?.sessionManager.request(mapImageEndpoint).responseData { [weak self] in
                    guard let imageData = $0.value, let image = UIImage(data: imageData) else { return }
                    self?.maps.append(image)
                    self?.collectionView.reloadData()
                }
            }
        }
        // TODO: rename function and fetch cords
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch maps.count {
        case 0:
            collectionView.setBackgroundLabel(with: "Missing Map".localized)
        default:
            collectionView.backgroundView = nil
        }

        return maps.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseIdentifier, for: indexPath) as! MapCell
        let mapImage = maps[indexPath.row]
        cell.imageView.image = mapImage
        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let destination = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
//        destination.cafeteria = dataSource?.itemIdentifier(for: indexPath)
//        navigationController?.pushViewController(destination, animated: true)
        // TODO
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }

    @IBAction private func showInMaps(_ sender: Any) {
        // TODO
    }

}
