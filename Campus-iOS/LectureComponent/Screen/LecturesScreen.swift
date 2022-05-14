//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LecturesScreen: View {
    @StateObject private var vm: LecturesViewModel
    
    init(model: Model) {
        self._vm = StateObject(wrappedValue:
            LecturesViewModel(
                model: model,
                service: LecturesService()
            )
        )
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(_):
                VStack {
                    LecturesView(model: vm.model, lecturesBySemester: vm.sortedLecturesBySemester)
                        .refreshable {
                            await vm.getLectures(
                                forcedRefresh: true
                            )
                        }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Lectures".localized)
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: self.vm.getLectures
                )
            }
        }
        .task {
            await vm.getLectures()
        }
        .alert(
            "Error while fetching Lectures",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getLectures()
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
        LecturesScreen(model: MockModel())
    }
}
