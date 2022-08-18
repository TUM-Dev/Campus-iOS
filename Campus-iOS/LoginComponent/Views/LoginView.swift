//
//  LoginView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import SwiftUI
import Combine

private enum Field: Int, Equatable {
  case firstTextField, numbersTextField, secondTextField
}


struct LoginView: View {
    /// The `LoginViewModel` that manages the content of the login screen
    @ObservedObject var viewModel: LoginViewModel
    @FocusState private var focusedField: Field?
    
    var body: some View {
            GeometryReader { geo in
                VStack {
                    VStack(alignment: .center) {
                        Image("logo-blue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width * 0.4, height: geo.size.height / 8)
                        
                        Text("Welcome to TUM Campus App")
                            .frame(alignment: .center)
                            .font(.title3 .bold())
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 4 )
                    
                    Spacer()
                    VStack(alignment: .center) {
                        Text("Enter your TUM ID to get started")
                            .font(.headline .bold())

                        HStack() {
                            TextField("go", text: $viewModel.firstTextField)
                                .textFieldStyle(CustomRoundedTextFieldStyle())
                                .frame(width: 50)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .disableAutocorrection(true)
                                .textContentType(.username)
                                .textInputAutocapitalization(.never)
                                .textCase(.lowercase)
                                .focused($focusedField, equals: .firstTextField)
                                .onChange(of: viewModel.firstTextField) {
                                    viewModel.firstTextField = String($0.prefix(2))
                                    if $0.count == 2 { focusedField = .numbersTextField }
                                }

                            Spacer().frame(width: 8)

                            TextField("42", text: $viewModel.numbersTextField)
                                .textFieldStyle(CustomRoundedTextFieldStyle())
                                .frame(width: 50)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .disableAutocorrection(true)
                                .textContentType(.username)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .numbersTextField)
                                .onChange(of: viewModel.numbersTextField) {
                                    viewModel.numbersTextField = String($0.prefix(2))
                                    if $0.count == 2 { focusedField = .secondTextField }
                                    if $0.count == 0 { focusedField = .firstTextField }
                                }


                            Spacer().frame(width: 8)

                            TextField("tum", text: $viewModel.secondTextField)
                                .textFieldStyle(CustomRoundedTextFieldStyle())
                                .frame(width: 50)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .disableAutocorrection(true)
                                .textContentType(.username)
                                .textInputAutocapitalization(.never)
                                .textCase(.lowercase)
                                .focused($focusedField, equals: .secondTextField)
                                .onChange(of: viewModel.secondTextField) {
                                    viewModel.secondTextField = String($0.prefix(3))
                                    if $0.count == 3 { focusedField = nil }
                                    if $0.count == 0 { focusedField = .numbersTextField }
                                }
                                
                        }
                        
                        Spacer()
                            .frame(height: 18)
                        
                        ZStack {
                            NavigationLink(destination:
                                            TokenConfirmationView(viewModel: self.viewModel).navigationBarTitle(Text("Authorize Token")), isActive: self.$viewModel.isContinuePressed) { EmptyView() }
                            
                            Button(action: {
                                self.viewModel.loginWithContinue()
                            }) {
                                Text("Continue 🎓")
                                    .lineLimit(1)
                                    .font(.title3)
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
                    
                    Spacer()
                        
                    Image("tower")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                        
                    
                    Spacer()
                    
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard)
    }
    
    init(model: Model) {
        self.viewModel = LoginViewModel(model: model)
//        KeychainService.removeAuthorization()
    }
}

struct LoginView_Previews: PreviewProvider {
    static let model = MockModel()
    
    static var previews: some View {
        Text("Background").sheet(isPresented: .constant(true)) {
            NavigationView {
                LoginView(model: model).navigationBarHidden(true)
            }
        }
//        .previewDevice("iPad Pro (12.9 inch) (5th generation)")
//        .previewInterfaceOrientation(.landscapeRight)
//        .previewDevice("iPod touch (7th generation)")
        .previewDevice("iPhone 12")
        .previewInterfaceOrientation(.portrait)
        
        LoginView(model: model)
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}
