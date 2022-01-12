//
//  LoginView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import SwiftUI
import Combine

struct LoginView: View {
    /// The `LoginViewModel` that manages the content of the login screen
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geo in
                VStack(alignment: .center) {
                    Image("logo-blue")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width * 0.4)
                        .frame(width: geo.size.width, height: geo.size.height / 8)
                    
                    Text("Welcome to TUM Campus App")
                        .frame(alignment: .center)
                        .font(.title3 .bold())
                        .multilineTextAlignment(.center)
                }
                .frame(width: geo.size.width, height: geo.size.height / 4 )
                .offset(x: 0, y: 20)
                
                VStack(alignment: .center) {
                    Text("Enter your TUM ID to get started")
                        .font(.headline .bold())

                    HStack() {
                        TextField("go", text: $viewModel.firstTextField)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 50)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .textContentType(.username)
                            .textInputAutocapitalization(.never)
//                            .onReceive(Just(viewModel.firstTextField)) { (newValue: String) in
//                                viewModel.firstTextField = newValue.prefix(2).lowercased()
//                            }

                        Spacer().frame(width: 8)

                        TextField("42", text: $viewModel.numbersTextField)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 50)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .textContentType(.username)
                            .keyboardType(.numberPad)
//                            .onReceive(Just(viewModel.numbersTextField)) { (newValue: String) in
//                                viewModel.numbersTextField = String(newValue.prefix(2))
//                            }

                        Spacer().frame(width: 8)

                        TextField("tum", text: $viewModel.secondTextField)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 50)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .textContentType(.username)
                            .textInputAutocapitalization(.never)
//                            .onReceive(Just(viewModel.secondTextField)) { (newValue: String) in
//                                viewModel.secondTextField = newValue.prefix(3).lowercased()
//                            }
                    }
                    
                    Spacer()
                        .frame(height: 18)
                    
                    ZStack {
                        NavigationLink(destination:
                                        TokenConfirmationView(viewModel: self.viewModel).navigationBarTitle(Text("Authorize Token")), isActive: self.$viewModel.isContinuePressed) { EmptyView() }
                        
                        Button(action: {
                            self.viewModel.loginWithContinue()
                        }) {
                            Text("Continue 🎓").lineLimit(1).font(.title2)
                                .frame(alignment: .center)
                        }
                        .alert("Login Error", isPresented: self.$viewModel.showLoginAlert) {
                            Button("OK", role: .cancel) {}
                        }
                        .disabled(!viewModel.isContinueEnabled)
                        .frame(width: 135, height: 35)
                        .aspectRatio(contentMode: .fill)
                        .font(.title)
                        .background(Color(.secondarySystemFill))
                        .cornerRadius(10)
                    }

                    Spacer().frame(height: 20)

                    Button(action: {
                        self.viewModel.loginWithContinueWithoutTumID()
                        self.viewModel.model?.isLoginSheetPresented = false
                    }) {
                        Text("Continue without TUM ID").lineLimit(1).font(.caption)
                            .frame(alignment: .center)
                    }
                    .alert("Login Error", isPresented: self.$viewModel.showLoginAlert) {
                        Button("OK", role: .cancel) {}
                    }
                    .aspectRatio(contentMode: .fill)
                    .font(.subheadline)
                }
                .frame(width: geo.size.width, height: geo.size.height / 4 )
                .offset(x: 0, y: 1 * geo.size.height / 3)

                Image("tower")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width * 0.7)
                    .frame(width: geo.size.width, height: geo.size.height / 4)
                    .offset(x: 0, y: 2 * geo.size.height / 3)
            }
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
    
    init(model: Model) {
        self.viewModel = LoginViewModel(model: model)
//        KeychainService.removeAuthorization()
    }
}

struct LoginView_Previews: PreviewProvider {
    static let model = MockModel()
    
    static var previews: some View {
        LoginView(model: model)
    }
}
