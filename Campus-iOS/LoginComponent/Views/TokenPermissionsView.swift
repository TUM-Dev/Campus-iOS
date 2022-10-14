//
//  TokenPermissionsView.swift
//  Campus-iOS
//
//  Created by David Lin on 14.10.22.
//

import SwiftUI

enum FetchState {
    case na
    case loading
    case success(data: [Any])
    case failed(error: Error)
}

struct TokenPermissionsView: View {
    
    @StateObject var viewModel: TokenPermissionsViewModel
    
    var body: some View {
        VStack {
            Button {
                Task {
                    await viewModel.checkPermissionFor(types: [.grades, .lectures, .calendar, .identification, .tuitionFees])
                }
            } label: {
                Text("Check Permissions")
            }
            
            HStack {
                Text("Calendar")
                if let currentState = viewModel.states[.calendar] {
                    check(state: currentState)
                } else {
                    Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                }
            }
            
            HStack {
                Text("Lectures")
                if let currentState = viewModel.states[.lectures] {
                    check(state: currentState)
                } else {
                    Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                }
            }
            
            HStack {
                Text("Grades")
                if let currentState = viewModel.states[.grades] {
                    check(state: currentState)
                } else {
                    Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                }
            }
            
            HStack {
                Text("Tuition Fees")
                if let currentState = viewModel.states[.tuitionFees] {
                    check(state: currentState)
                } else {
                    Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                }
            }
            
            HStack {
                Text("Identification")
                if let currentState = viewModel.states[.identification] {
                    check(state: currentState)
                } else {
                    Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                }
            }
            
        }
    }
    
    @ViewBuilder
    func check(state: TokenPermissionsViewModel.State) -> some View {
        switch state {
        case .success:
            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
        case .failed(let error):
            
            switch error {
            case CampusOnlineAPI.Error.noPermission:
                Image(systemName: "x.circle.fill").foregroundColor(.red)
            case NetworkingError.deviceIsOffline:
                Image(systemName: "wifi.slash").foregroundColor(.red)
            default:
                VStack{
                    Image(systemName: "questionmark.circle.fill").foregroundColor(.red)
                    Text(">>" + error.localizedDescription + "<<")
                }
                
            }
        case .na:
            Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
        case .loading:
            LoadingView(text: "")
        }
    }
}

struct TokenPermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        TokenPermissionsView(viewModel: TokenPermissionsViewModel(model: Model()))
    }
}
