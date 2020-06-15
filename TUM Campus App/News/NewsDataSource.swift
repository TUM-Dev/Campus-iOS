//
//  NewsDataSource.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 13.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

final class NewsDataSource: NSObject, UICollectionViewDataSource {
    typealias ImporterType = Importer<NewsSource,[NewsSource],JSONDecoder>

    private let endpoint: URLRequestConvertible
    private weak var collectionView: UICollectionView?
    lazy var importer = ImporterType(endpoint: endpoint, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))

    init(newsSourceID id: String, collectionView: UICollectionView? = nil) {
        self.endpoint = TUMCabeAPI.news(source: id)
        self.collectionView = collectionView
        super.init()
        fetch()
    }

    func fetch() {
        importer.performFetch(success: { [weak self] in
            self?.collectionView?.reloadData()
        })
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.reuseIdentifier, for: indexPath)

        return cell
    }

}
