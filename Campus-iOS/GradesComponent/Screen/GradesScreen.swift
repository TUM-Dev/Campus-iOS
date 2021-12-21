//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct GradesScreen: View {
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    @StateObject private var vm = GradesViewModel(
        serivce: GradesService()
    )
    
    var body: some View {
        Group {
            if vm.grades.isEmpty {
                LoadingView(text: "Fetching Grades")
            } else {
                List {
                    ForEach(vm.grades) { item in
                        GradeView(grade: item)
                    }
                }
            }
        }
        .task {
            await vm.getGrades(token: environmentValues.user.token)
        }
    }
}

struct GradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesScreen()
    }
}
