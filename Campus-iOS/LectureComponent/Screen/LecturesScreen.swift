//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LecturesScreen: View {
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    @StateObject private var vm = LecturesViewModel(
        serivce: LecturesService()
    )
    
    var body: some View {
        Group {
            if vm.lectures.isEmpty {
                LoadingView(text: "Fetching Lectures")
            } else {
                List {
                    ForEach(vm.lectures) { item in
                        LectureView(lecture: item)
                    }
                }
            }
        }
        .task {
            await vm.getLectures(token: environmentValues.user.token)
        }
    }
}

struct LecturesScreen_Previews: PreviewProvider {
    static var previews: some View {
        LecturesScreen()
    }
}
