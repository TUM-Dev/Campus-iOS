//
//  StudyCollectionViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import XMLParsing


class StudyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    typealias LectureImporter = Importer<Lecture, LectureAPIResponse, XMLDecoder>
    typealias TuitionImporter = Importer<Tuition,TuitionAPIResponse,XMLDecoder>
    typealias GradeImporter = Importer<Grade,GradeAPIResponse,XMLDecoder>
    typealias GradeAPIResponse = APIResponse<GradesAPIResponse, TUMOnlineAPIError>

    let lectureSortDescriptor = NSSortDescriptor(key: "semesterID", ascending: false)
    lazy var lectureImporter = LectureImporter(endpoint: TUMOnlineAPI.personalLectures, sortDescriptor: lectureSortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    
    let tuitionSortDescriptor = NSSortDescriptor(keyPath: \Tuition.semesterID, ascending: false)
    lazy var tuitionImporter = TuitionImporter(endpoint: TUMOnlineAPI.tuitionStatus, sortDescriptor: tuitionSortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))

    let gradeSortDescriptor = NSSortDescriptor(keyPath: \Grade.semester, ascending: false)
    lazy var gradeImporter = GradeImporter(endpoint: TUMOnlineAPI.personalGrades, sortDescriptor: gradeSortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lectureImporter.fetchedResultsControllerDelegate = self
        tuitionImporter.fetchedResultsControllerDelegate = self
        gradeImporter.fetchedResultsControllerDelegate = self
        lectureImporter.performFetch()
        tuitionImporter.performFetch()
        gradeImporter.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! lectureImporter.fetchedResultsController.performFetch()
        try! tuitionImporter.fetchedResultsController.performFetch()
        try! gradeImporter.fetchedResultsController.performFetch()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return tuitionImporter.fetchedResultsController.fetchedObjects?.count ?? 0
        case 1: return gradeImporter.fetchedResultsController.fetchedObjects?.count ?? 0
        case 2: return lectureImporter.fetchedResultsController.fetchedObjects?.count ?? 0
        default: fatalError("Invalid Section")
        }
    }
}
