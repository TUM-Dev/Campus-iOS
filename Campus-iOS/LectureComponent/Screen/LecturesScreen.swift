//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LecturesScreen: View {
    @EnvironmentObject private var environmentValues: CustomEnvironmentValues
    
    @StateObject private var vm = LecturesViewModel(
        serivce: LecturesService()
    )
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(_):
                ScrollView {
                    LecturesView(lecturesBySemester: vm.sortedLecturesBySemester)
                }
            case .loading, .na:
                LoadingView(text: "Fetching Lectures")
            case .failed(let error):
                FailedView(errorDescription: error.localizedDescription)
            }
        }
        .task {
            await vm.getLectures(token: environmentValues.user.token)
        }
        .alert(
            "Error while fetching Lectures",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getLectures(token: environmentValues.user.token)
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
