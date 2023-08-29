//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LecturesScreen: View {
    @StateObject var vm: LecturesViewModel
    @Binding var refresh: Bool
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(_):
                VStack {
                    LecturesView(model: vm.model, lecturesBySemester: vm.sortedLecturesBySemester)
                        .padding(.top, 50)
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
        // Refresh whenever user authentication status changes
        .onChange(of: self.refresh) { _ in
            Task {
                await vm.getLectures()
            }
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
        LecturesScreen(
            vm: LecturesViewModel(
                model: MockModel(),
                service: LecturesService()
            ),
            refresh: .constant(false))
    }
}
