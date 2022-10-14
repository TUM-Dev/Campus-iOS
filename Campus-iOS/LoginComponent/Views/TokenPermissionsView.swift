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
    
    @State var gradesPermission = false
    
    var body: some View {
        VStack {
            Button {
                Task {
                    await viewModel.checkPermissionFor(type: .grades)
                }
            } label: {
                Text("Check Permissions")
            }
            HStack {
                Text("Grades")
                switch viewModel.state {
                case .success:
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                case .failed(let error):
                    switch error {
                    case CampusOnlineAPI.Error.noPermission:
                        Image(systemName: "x.circle.fill").foregroundColor(.red)
                    case NetworkingError.deviceIsOffline:
                        Image(systemName: "wifi.slash").foregroundColor(.red)
                    default:
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.red)
                    }
                case .na:
                    Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                case .loading:
                    LoadingView(text: "")
                }
                
            }
        }
    }
}

struct TokenPermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        TokenPermissionsView(viewModel: TokenPermissionsViewModel(model: Model()))
    }
}
