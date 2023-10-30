//
//  LectureDetailsScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import SwiftUI

struct LectureDetailsScreen: View {
    @StateObject var vm: LectureDetailsViewModel
    
    init(model: Model, lecture: Lecture) {
        self._vm = StateObject(wrappedValue:
            LectureDetailsViewModel(
                model: model,
                service: LectureDetailsService(),
                lecture: lecture
            )
        )
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                LecturesDetailView(viewModel: vm, lectureDetails: data)
            case .loading, .na:
                LoadingView(text: "Fetching details of lecture".localized)
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getLectureDetails
                )
            }
        }
        .task {
            await vm.getLectureDetails()
        }
    }
}

struct LectureDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsScreen(
            model: MockModel(), lecture: Lecture.dummyData.first!
        )
    }
}
