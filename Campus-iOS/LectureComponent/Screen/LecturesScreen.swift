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
            case .success(let lectures):
                if (lectures.count == 0) {
                    NoDataView(description: "You seem to not have any lectures yet!\n Happy Studying! 🙌")
                } else {
                    VStack {
                        LecturesView(model: vm.model, lecturesBySemester: vm.sortedLecturesBySemester)
                            .padding(.top, 50)
                            .refreshable {
                                await vm.getLectures(
                                    forcedRefresh: true
                                )
                            }
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
