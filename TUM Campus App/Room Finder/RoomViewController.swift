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
    private var maps: [RoomMap]?
    var room: Room? {
        didSet {
            fetch()
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

    private func fetch() {
        guard let room = room else { return }
        let mapsEndpoint = TUMCabeAPI.roomMaps(room: room.id)
        sessionManager.request(mapsEndpoint).responseDecodable(of: [RoomMap].self, decoder: JSONDecoder()) { [weak self] response in
            guard let value = response.value else {
                self?.collectionView.reloadData()
                return
            }
            self?.maps = value
            self?.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch maps?.count {
        case let .some(count) where count == 0:
            collectionView.setBackgroundLabel(withText: "Missing Map".localized)
        case let .some(count) where count > 0:
            collectionView.removeBackgroundLabel()
        default:
            collectionView.setBackgroundLabel(withText: "Missing Map".localized)
        }

        return maps?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseIdentifier, for: indexPath) as! MapCell
        guard let map = maps?[indexPath.row], let room = room else { return cell }
        let mapImageEndpoint = TUMCabeAPI.mapImage(room: room.id, id: map.id)
        guard let mapURL = mapImageEndpoint.urlRequest?.url else { return cell }
        cell.imageView.kf.setImage(with: mapURL, options: [.transition(.fade(0.2))])
        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destination = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        destination.room = room
        destination.map = maps?[indexPath.row]
        present(destination, animated: true)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }

}
