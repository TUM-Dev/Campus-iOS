//
//  LectureDetailsScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import SwiftUI

struct LectureDetailsScreen: View {
    @EnvironmentObject private var model: Model
    
    @StateObject var vm: LectureDetailsViewModel = LectureDetailsViewModel(
        serivce: LectureDetailsService()
    )
    
    var lecture: Lecture
    
    private var token: String? {
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
        Group {
            switch vm.state {
            case .success(let data):
                LecturesDetailView(lectureDetails: data)
            case .loading, .na:
                LoadingView(text: "Fetching details of lecture")
            case .failed(let error):
                FailedView(errorDescription: error.localizedDescription)
            }
        }
        .task {
            guard let token = self.token else {
                return
            }
            
            await vm.getLectureDetails(
                token: token,
                lvNr: lecture.lvNumber
            )
        }
        .alert(
            "Error while fetching details of lecture",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        guard let token = self.token else {
                            return
                        }
                        
                        await vm.getLectureDetails(
                            token: token,
                            lvNr: lecture.lvNumber
                        )
                    }
                }
        
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    Text(error.localizedDescription)
                }
            }
    }
}

struct LectureDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsScreen(
            vm: LectureDetailsViewModel(serivce: LectureDetailsService()),
            lecture: Lecture.dummyData.first!
        )
    }
}
