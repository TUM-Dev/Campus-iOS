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
        VStack() {
            Text("Permissions granted for:").padding().font(.system(size: 25)).foregroundColor(.tumBlue)
            HStack {
                VStack(alignment: .leading) {
                    Text("Calendar").padding()
                    Text("Lectures").padding()
                    Text("Grades").padding()
                    Text("Tuition Fees").padding()
                    Text("Identification").padding()
                }
                Spacer()
                VStack {
                    //Calendar
                    if let currentState = viewModel.states[.calendar] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                    //Lectures
                    if let currentState = viewModel.states[.lectures] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                    //Grades
                    if let currentState = viewModel.states[.grades] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                    //Tuition Fees
                    if let currentState = viewModel.states[.tuitionFees] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                    //Identification
                    if let currentState = viewModel.states[.identification] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                }
            }
            .font(.system(size: 20))
            .padding()
            
            Button {
                Task {
                    await viewModel.checkPermissionFor(types: [.grades, .lectures, .calendar, .identification, .tuitionFees])
                }
            } label: {
                Text("Check Permissions")
                    .lineLimit(1)
                    .font(.body)
                    .frame(width: 200, height: 48, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color(.tumBlue))
                    .cornerRadius(10)
                    .buttonStyle(.plain)
            }.padding()
            
            Text("You can change your permissions in TUMOnline")
                .foregroundColor(.tumBlue)
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
