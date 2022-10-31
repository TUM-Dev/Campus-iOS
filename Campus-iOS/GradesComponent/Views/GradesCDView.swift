//
//  GradeCDView.swift
//  Campus-iOS
//
//  Created by David Lin on 24.10.22.
//

import SwiftUI
import XMLCoder

struct GradesCDView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var gradesCD: FetchedResults<GradeCD>
    
//    @StateObject var vm: GradesCDViewModel
    var model: Model
    
    var token: String? {
        switch self.model.loginController.credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
    var body: some View {
        VStack {
            Button("Fetch and add grades to CoreData") {
                Task {
                    // Very Important: Add moc to the CodingUserInfoKey to make an initialization of Grade-Objects possible via the init(from:)-Initializer (i.e. via the Decoder)
//                    CampusOnlineAPI.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = moc
                    
                    
                    var data: Data
                    do {
                        data = try await Constants.API.CampusOnline.personalGrades.asRequest(token: token).serializingData().value
                    } catch {
                        print(error)
                        throw NetworkingError.deviceIsOffline
                    }
                    
//                    // Check this first cause otherwise no error is thrown by the XMLDecoder
//                    if let error = try? Self.decoder.decode(Error.self, from: data) {
//                        print(error)
//                        throw error
//                    }
                    
                    do {
                        Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = moc
                        let newGradeSet = try Self.decoder.decode(GradeSet.self, from: data)
                        
                        let newGrades = newGradeSet.row

                        for grade in newGrades {
                            print(grade.title)
                        }
                        
//                        let newGrade = GradeCD(context: moc)
//                        newGrade.title = "Title"
//                        newGrade.id = UUID().uuidString
//                        newGrade.date = Date()
//                        newGrade.examType = "Standard"
//                        newGrade.grade = String(1.7)
//                        newGrade.examiner = "Prof. XY"
//                        newGrade.lvNumber = "IN0000"
//                        newGrade.modus = ""
//                        newGrade.semester = "1"
//                        newGrade.studyDesignation = ""
//                        newGrade.studyID = "go42tum"
//                        newGrade.studyNumber = Int64(UInt64(123456))
                        
                        try moc.save()
                        print("Saved")

                        print("Count: \(newGrades.count)")
                    } catch {
                        print(error)
//                        throw Error.unknown(error.localizedDescription)
                    }
                    
                    
//                    do {
//                        let newGradeSet: GradeSet = try await CampusOnlineAPI.makeRequest(endpoint: Constants.API.CampusOnline.personalGrades, token: self.token, forcedRefresh: true)
    //                    let newGradeSet = try Self.decoder.decode(GradeSet.self, from: data2)
                        //print(newGrades)
//                        print("GRADESET: \(newGradeSet)")
                        
                        
                        
                        
//                        let newGrades = newGradeSet.row

//                        for grade in newGrades {
//                            print(grade.title)
//                        }
//
//                        try moc.save()
//                        print("Saved")
//
//                        print("Count: \(newGrades.count)")
//                    } catch {
//                        print(error)
//                    }
                }
            }
            List {
                ForEach(gradesCD, id: \.self) { grade in
                    HStack{
                        Text(grade.title ?? "NO TITLE")
                        Text(grade.grade ?? "NO GRADE")
                    }
                }.onDelete(perform: deleteGrades)
            }
        }
    }
    
    func deleteGrades(at offsets: IndexSet) {
        for offset in offsets {
            let grade = gradesCD[offset]
            moc.delete(grade)
        }
        
        try? moc.save()
    }
    
//    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [Grade] {
//        let response: GradeSet =
//        try await
//        CampusOnlineAPI
//            .makeRequest(
//                endpoint: Constants.API.CampusOnline.personalGrades,
//                token: token,
//                forcedRefresh: forcedRefresh
//            )
//
//        return response.row
//    }
    
    static let decoder: XMLDecoder = {
        let decoder = XMLDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
         
        return decoder
    }()
}

struct GradeCDView_Previews: PreviewProvider {
    static var previews: some View {
        GradesCDView(model: Model())
    }
}
