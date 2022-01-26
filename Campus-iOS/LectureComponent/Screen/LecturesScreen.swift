//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LecturesScreen: View {
    @EnvironmentObject private var model: Model
    
    @StateObject private var vm = LecturesViewModel(
        serivce: LecturesService()
    )
    
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
            if let token = self.token {
                switch vm.state {
                case .success(_):
                    VStack {
                        LecturesView(lecturesBySemester: vm.sortedLecturesBySemester)
                            .refreshable {
                                await vm.getLectures(
                                    token: token,
                                    forcedRefresh: true
                                )
                            }
                    }
                case .loading, .na:
                    LoadingView(text: "Fetching Lectures")
                case .failed(let error):
                    FailedView(errorDescription: error.localizedDescription)
                }
            } else {
                FailedView(errorDescription: "Please log in first")
            }
        }
        .task {
            guard let token = self.token else {
                return
            }
            
            await vm.getLectures(token: token)
        }
        .alert(
            "Error while fetching Lectures",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        guard let token = self.token else {
                            return
                        }
                        
                        await vm.getLectures(token: token)
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

struct LecturesScreen_Previews: PreviewProvider {
    static var previews: some View {
        LecturesScreen()
    }
}
