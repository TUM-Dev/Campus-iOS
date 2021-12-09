//
//  LoginView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import SwiftUI

struct LoginView: View {
    /// The `LoginViewModel` that manages the content of the login screen
//    @ObservedObject var viewModel: LoginViewModel
    
    @State private var isContinuePressed = false
    
    @State private var firstTextField: String = ""
    @State private var numbersTextField: String = ""
    @State private var secondTextField: String = ""
    
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
                        TextField("go", text: $firstTextField)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 50)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .textContentType(.username)

                        Spacer().frame(width: 8)

                        TextField("42", text: $numbersTextField)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 50)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .textContentType(.username)
                            .keyboardType(.numberPad)

                        Spacer().frame(width: 8)

                        TextField("tum", text: $secondTextField)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 50)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .textContentType(.username)
                    }
                    
                    Spacer()
                        .frame(height: 18)
                    
                    ZStack {
                        NavigationLink(destination:
                            TokenConfirmationView().navigationBarTitle(Text("Authorize Token")), isActive: $isContinuePressed) { EmptyView() }
                        
                        Button(action: {
                            self.isContinuePressed = true
                        }) {
                            Text("Continue 🎓").lineLimit(1).font(.title2)
                                .frame(alignment: .center)
                        }
                        .frame(width: 135, height: 35)
                        .aspectRatio(contentMode: .fill)
                        .font(.title)
                        .background(Color(.secondarySystemFill))
                        .cornerRadius(10)
                    }

                    Spacer().frame(height: 20)

                    Button(action: {
                        //didSelectContinueWithoutTumID()
                    }) {
                        Text("Continue without TUM ID").lineLimit(1).font(.caption)
                            .frame(alignment: .center)
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
//        self.viewModel = LoginViewModel(model: model)
//        KeychainService.removeAuthorization()
    }
}

struct LoginView_Previews: PreviewProvider {
    static let model = MockModel()
    
    static var previews: some View {
        LoginView(model: model)
    }
}
