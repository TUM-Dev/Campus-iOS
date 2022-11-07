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
    @State var notAllPermissionsGranted = false
    @State var permissionsWarning = ""
    @State var showHelp = false
    
    var dismissWhenDone: Bool = false
    
    let permissionTypes: [TokenPermissionsViewModel.PermissionType]  = [.calendar, .lectures, .grades, .tuitionFees, .identification]
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer(minLength: 10)
                Text("You can change your permissions on TUMOnline")
                    .foregroundColor(.tumBlue)
                    .multilineTextAlignment(.center)
                Spacer(minLength: 10)
            }
            
            VStack {
                ForEach(permissionTypes, id: \.self) { permissionType in
                    HStack {
                        Text(permissionType.rawValue)
                        Spacer()
                        if let currentState = viewModel.states[permissionType] {
                            check(state: currentState).padding()
                        } else {
                            Image(systemName: "questionmark.circle.fill").foregroundColor(.gray).padding()
                        }
                    }
                }
                
                HStack {
                    if showHelp {
                        VStack {
                            Image(uiImage: UIImage(named: "set-permissions.png")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                                .cornerRadius(5)
                                .overlay (
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.red, style: StrokeStyle(lineWidth: 1))
                                )
                        }
                    }
                    Spacer()
                    Button {
                        showHelp = !showHelp
                    } label: {
                        Text("Need Help?")
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(4)
                            .overlay (
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.red, style: StrokeStyle(lineWidth: 1))
                            )
                    }
                }
            }
            .font(.system(size: 20))
            .padding()
            
            VStack {
                HStack (){
                    Button {
                        self.showTUMOnline = true
                        self.doneButton = false
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                            Text("Open TUMOnline")
                        }
                        .lineLimit(1)
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 150, height: 48, alignment: .center)
                    }
                    .foregroundColor(.white)
                    .background(Color(.tumBlue))
                    .cornerRadius(10)
                    .padding()
                    
                    Spacer()
                    
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
                            .font(.system(size: 14, weight: .bold))
                            .frame(width: 150, height: 48, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color(.tumBlue))
                            .cornerRadius(10)
                            .buttonStyle(.plain)
                    }
                    .padding()
                }
                
                if doneButton {
                    // Insert the warning string and switch bool
                    
                    Button {
                        if allPermissionsAreGranted() {
                            if dismissWhenDone {
                                // Dismiss when view is opened from Profile/Settings.
                                dismiss()
                            } else {
                                // Used when shown via the login process sheet.
                                self.viewModel.model.isLoginSheetPresented = false
                            }
                        } else {
                            // Not all permissions were granted
                            
                            permissionsWarning = "You have not granted the following permissions: \n\n"
                            for permission in notGrantedPermissions() {
                                self.permissionsWarning.append("\(permission.rawValue)\n ")
                            }
                            permissionsWarning.append("\nJust be aware that the app will not fully work without all permissions. You can change the permissions every time in TUMOnline.")
                            
                            notAllPermissionsGranted = true
                        }
                    } label: {
                        Text("Done")
                            .lineLimit(1)
                            .font(.system(size: 17, weight: .bold))
                            .frame(width: 200, height: 48, alignment: .center)
                            .foregroundColor(.white)
                            .background(allPermissionsAreGranted() ? .green : .tumBlue)
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
        .alert(isPresented: $notAllPermissionsGranted) {
            Alert(title: Text("Permissions Warning"), message: Text(permissionsWarning), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.destructive(Text("Continue anyways"), action: {
                if dismissWhenDone {
                    // Dismiss when view is opened from Profile/Settings.
                    dismiss()
                } else {
                    // Used when shown via the login process sheet.
                    self.viewModel.model.isLoginSheetPresented = false
                }
            }))
        }
    }
    
    func notGrantedPermissions() -> [TokenPermissionsViewModel.PermissionType] {
        return permissionTypes.filter { permissionType in
            if case .success = viewModel.states[permissionType] {
                return false
            } else {
                return true
            }
        }
    }
    
    func allPermissionsAreGranted() -> Bool {
        for permissionType in permissionTypes {
            if case .success = viewModel.states[permissionType] {} else {
                return false
            }
        }
        return true
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
