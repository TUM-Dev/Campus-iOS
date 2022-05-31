//
//  TokenConfirmationView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import SwiftUI

struct TokenConfirmationView: View {
    /// Used for the customized back button
    @Environment(\.presentationMode) var presentationMode
    @State var showBackButtonAlert: Bool = false
    /// The `LoginViewModel` that manages the content of the login screen
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack() {
            GeometryReader { geo in
                VStack(alignment: .center) {
                    HStack() {
                        VStack(alignment: .leading) {
                            ZStack(content: {})
                                .frame(width: 42, height: 50)
                                .background(Color(.systemBackground))
                            
                            Spacer().frame(height: 5)
                            
                            Text("1")
                                .frame(width: 42, height: 42, alignment: .center)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(white: 1.0))
                                .background(Color(red: 0.203649, green: 0.35383618, blue: 0.72193307))
                                .clipShape(Circle())
                            
                            Spacer().frame(height: 0)
                            
                            ZStack(content: {})
                                .frame(width: 42, height: 50)
                                .background(Color(.systemBackground))
                        }
                        .frame(width: 42, height: 142)
                        
                        Spacer().frame(width: 20)
                        
                        Text("Check your email and click on the link to confirm your token or visit TUMonline")
                            .font(.body)
                    }
                    .frame(width: 0.9 * geo.size.width, height: geo.size.height / 5, alignment: .leading)
                    .offset(y: 30)
                    
                    HStack() {
                        VStack() {
                            ZStack(content: {})
                                .frame(width: 42, height: 50)
                                .background(Color(.systemBackground))
                            
                            Spacer().frame(height: 0)
                            
                            Text("2")
                                .frame(width: 42, height: 42, alignment: .center)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(white: 1.0))
                                .background(Color(red: 0.203649, green: 0.35383618, blue: 0.72193307))
                                .clipShape(Circle())
                            
                            Spacer().frame(height: 0)
                            
                            ZStack(content: {})
                                .frame(width: 42, height: 50)
                                .background(Color(.systemBackground))
                        }
                        .frame(width: 42, height: 142)
                        
                        Spacer().frame(width: 20)
                        
                        Text("Select \"Token-Management\"")
                            .font(.body)
                    }
                    .frame(width: 0.9 * geo.size.width, height: geo.size.height / 5, alignment: .leading)
                    .offset(y: 15)
                    
                    HStack() {
                        VStack(alignment: .leading) {
                            ZStack(content: {})
                                .frame(width: 42, height: 50)
                                .background(Color(.systemBackground))
                            
                            Spacer().frame(height: 0)
                            
                            Text("3")
                                .frame(width: 42, height: 42, alignment: .center)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(white: 1.0))
                                .background(Color(red: 0.203649, green: 0.35383618, blue: 0.72193307))
                                .clipShape(Circle())
                            
                            Spacer().frame(height: 0)
                            
                            ZStack(content: {})
                                .frame(width: 42, height: 50)
                                .background(Color(.systemBackground))
                        }
                        
                        Spacer().frame(width: 20)
                        
                        Text("Click on the newly created token and enable your desired permissions")
                            .font(.body)
                    }
                    .frame(width: 0.9 * geo.size.width, height: geo.size.height / 5, alignment: .leading)
                    
                }
                .frame(width: geo.size.width, height: 4 * geo.size.height / 5)
                .offset(y: 50)
                
                
                VStack() {
                    NavigationLink(destination: TokenActivationTutorialView()) {
                        Text("I need help").lineLimit(1).font(.subheadline)
                            .frame(width: 200, height: 27, alignment: .center)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer().frame(height: 16)
                    
                    Button(action: {
                        self.viewModel.checkAuthorizzation()
                    }) {
                        Text("Check Authorization").lineLimit(1).font(.body)
                            .frame(width: 200, height: 48, alignment: .center)
                    }
                    .alert("Authorization Error", isPresented: self.$viewModel.showTokenAlert) {
                        Button("OK", role: .cancel) {}
                    }
                    .aspectRatio(contentMode: .fill)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color(red: 0.203649, green: 0.35383618, blue: 0.72193307))
                    .cornerRadius(10)
                }
                .frame(width: geo.size.width, height: geo.size.height / 5)
                .offset(x: 0, y: 3.85 * geo.size.height / 5)
            }
        }
        .background(Color(.systemBackground))
        ._scrollable()
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                self.showBackButtonAlert = true
          }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
          }
        )
        .alert(isPresented: $showBackButtonAlert) {
              Alert(
                title: Text("Are you sure?"),
                message: Text("Leaving now will invalidate the current token and create a new one!"),
                primaryButton: .default(Text("Leave")) {
                  self.presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
              )
        }
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
}

struct TokenConfirmationView_Previews: PreviewProvider {
    static let model = MockModel()
    
    static var previews: some View {
        TokenConfirmationView(viewModel: LoginViewModel(model: model))
            .previewDevice("iPod touch (7th generation)")
    }
}
