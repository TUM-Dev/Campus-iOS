//
//  APIConstants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

struct Grade: Decodable, Identifiable, Searchable {
    // Create own identifier as there isn't one
    public var id: String {
        date.formatted() + "-" + lvNumber
    }

    public var date: Date
    public var lvNumber: String
    public var semester: String
    public var title: String
    public var examiner: String
    public var grade: String
    public var examType: String
    public var modus: String
    public var studyID: String
    public var studyDesignation: String
    public var studyNumber: UInt64
    
    var comparisonTokens: [ComparisonToken] {
        get {
            return [
                ComparisonToken(value: title),
                ComparisonToken(value: examiner),
                ComparisonToken(value: grade, type: .raw),
                ComparisonToken(value: lvNumber),
                ComparisonToken(value: modus),
                ComparisonToken(value: semester),
                ComparisonToken(value: studyDesignation)
            ]
        }
    }
    
    var modusShort: String {
        switch self.modus {
        case "Schriftlich": return "Written".localized
        case "Beurteilt/immanenter Prüfungscharakter": return "Graded".localized
        case "Schriftlich und Mündlich": return "Written/Oral".localized
        case "Mündlich": return "Oral".localized
        default: return "Unknown".localized
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "datum"
        case lvNumber = "lv_nummer"
        case semester = "lv_semester"
        case title = "lv_titel"
        case examiner = "pruefer_nachname"
        case grade = "uninotenamekurz"
        case examType = "exam_typ_name"
        case modus = "modus"
        case studyID = "studienidentifikator"
        case studyDesignation = "studienbezeichnung"
        case studyNumber = "st_studium_nr"
    }
    
    // Need for a custom Decoder implementation as the XMLCoder library isn't able to handle missing Date properties and the entire decoding fails in case of a non-existing Date value
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Extra handelling of the date decoding
        do {
            date = try container.decode(Date.self, forKey: .date)
        } catch {
            date = .now
        }
        lvNumber = try container.decode(String.self, forKey: .lvNumber)
        semester = try container.decode(String.self, forKey: .semester)
        title = try container.decode(String.self, forKey: .title)
        examiner = try container.decode(String.self, forKey: .examiner)
        grade = try container.decode(String.self, forKey: .grade)
        examType = try container.decode(String.self, forKey: .examType)
        modus = try container.decode(String.self, forKey: .modus)
        studyID = try container.decode(String.self, forKey: .studyID)
        studyDesignation = try container.decode(String.self, forKey: .studyDesignation)
        studyNumber = try container.decode(UInt64.self, forKey: .studyNumber)
    }
    
    internal init(date: Date, lvNumber: String, semester: String, title: String, examiner: String, grade: String, examType: String, modus: String, studyID: String, studyDesignation: String, studyNumber: UInt64) {
        self.date = date
        self.lvNumber = lvNumber
        self.semester = semester
        self.title = title
        self.examiner = examiner
        self.grade = grade
        self.examType = examType
        self.modus = modus
        self.studyID = studyID
        self.studyDesignation = studyDesignation
        self.studyNumber = studyNumber
    }
}

