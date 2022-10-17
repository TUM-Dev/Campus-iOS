//
//  TokenPermissionsView.swift
//  Campus-iOS
//
//  Created by David Lin on 14.10.22.
//

import SwiftUI

struct TokenPermissionsView: View {
    
    @StateObject var viewModel: TokenPermissionsViewModel
    @Environment(\.dismiss) var dismiss
    @State var doneButton = false
    @State var showTUMOnline = false
    
    var dismissWhenDone: Bool = false
    
    var body: some View {
        VStack() {
            Text("You can change your permissions on TUMOnline")
                .foregroundColor(.tumBlue)
            HStack {
                VStack(alignment: .leading) {
                    Text("Calendar").padding()
                    Text("Lectures").padding()
                    Text("Grades").padding()
                    Text("Tuition fees").padding()
                    Text("Identification (TUM ID and name)").padding()
                }
                Spacer()
                VStack {
                    if let currentState = viewModel.states[.calendar] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                    
                    if let currentState = viewModel.states[.lectures] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                    
                    if let currentState = viewModel.states[.grades] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                    
                    if let currentState = viewModel.states[.tuitionFees] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                    
                    if let currentState = viewModel.states[.identification] {
                        check(state: currentState).padding()
                    } else {
                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                    }
                }
            }
            .font(.system(size: 20))
            .padding()
            
            VStack (){
                Button {
                    self.showTUMOnline = true
                } label: {
                    HStack {
                        Image(systemName: "globe")
                        Text("Open TUMOnline")
                    }
                    .lineLimit(1).font(.body)
                        .frame(width: 200, height: 48, alignment: .center)
                }
                .font(.title)
                .foregroundColor(.white)
                .background(Color(.tumBlue))
                .cornerRadius(10)
                
                Button {
                    Task {
                        await viewModel.checkPermissionFor(types: [.grades, .lectures, .calendar, .identification, .tuitionFees])
                        
                        withAnimation() {
                            doneButton = true
                        }
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
                }
                
                if doneButton {
                    Button {
                        if dismissWhenDone {
                            // Dismiss when view is opened from Profile/Settings.
                            dismiss()
                        } else {
                            // Used when shown via the login process sheet.
                            DispatchQueue.main.async {
                                self.viewModel.model.isLoginSheetPresented = false
                            }
                        }
                    } label: {
                        Text("Done")
                            .lineLimit(1)
                            .font(.body)
                            .frame(width: 200, height: 48, alignment: .center)
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(10)
                            .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showTUMOnline) {
            SFSafariViewWrapper(url: Constants.tokenManagementTUMOnlineUrl).edgesIgnoringSafeArea(.bottom)
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
    
    init(viewModel: TokenPermissionsViewModel, dismissWhenDone: Bool = false) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.dismissWhenDone = dismissWhenDone
    }
}

struct TokenPermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        TokenPermissionsView(viewModel: TokenPermissionsViewModel(model: Model()))
    }
}
