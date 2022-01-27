//
//  ProfileView.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var model: Model
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    
    var body: some View {
        
        NavigationView {
            
            List {
                NavigationLink(destination: Text("Profile")) {
                    HStack(spacing: 24) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.black.opacity(0.2))
                            .frame(width: 75, height: 75)
                        
                        VStack(alignment: .leading) {
                            Text("Anton Wyrowski")
                                .font(.title2)
                            
                            Text("ab00xyz")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 6)
                }
                
                Section("MY TUM") {
                    NavigationLink(destination: Text("Studienbeiträge")) {
                        Label("Studienbeiträge", systemImage: "eurosign.circle")
                    }
                    NavigationLink(destination: Text("Person Search")) {
                        Label("Person Search", systemImage: "magnifyingglass")
                    }
                    NavigationLink(destination: Text("Lecture Search")) {
                        Label("Lecture Search", systemImage: "brain.head.profile")
                    }
                }
                
                Section("GENERAL") {
                    NavigationLink(destination: TUMSexyView().navigationBarTitle(Text("Useful Links"))) {
                        Label("TUM.sexy", image: "Tum.sexy")
                    }
                    
                    NavigationLink(destination: Text("Roomfinder")) {
                        Label("Roomfinder", image: "RoomFinder")
                    }
                    
                    NavigationLink(destination: NewsView()
                                    .navigationBarTitle(Text("News"))
                                    .navigationBarTitleDisplayMode(.large)
                    ) {
                        Label("News", systemImage: "newspaper")
                    }
                }
                
                Section() {
                    VStack {
                        Toggle("Use build-in Web View", isOn: $useBuildInWebView)
                    }
                }
                
                Section("GET IN CONTACT") {
                    Link("Werde Beta-Tester", destination: URL(string: "https://campus.tum.de")!)
                    
                    Link("TUM Dev on GitHub", destination: URL(string: "https://github.com/TUM-Dev")!)
                    
                    Link("TUM Dev Website", destination: URL(string: "https://tum.app")!)
                    
                    Button("Feedback") {
                        let mailToString = "mailto:app@tum.de?subject=[IOS]&body=Hello I have an issue...".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let mailToUrl = URL(string: mailToString!)!
                        if UIApplication.shared.canOpenURL(mailToUrl) {
                                UIApplication.shared.open(mailToUrl, options: [:])
                        }
                    }
                }
                
                Section() {
                    HStack(alignment: .bottom) {
                        Spacer()
                        if model.isUserAuthenticated {
                            Button(action: {
                                model.logout()
                            }) {
                                Text("Sign Out").foregroundColor(.red)
                            }
                        } else {
                            Button(action: {
                                model.isLoginSheetPresented = true
                            }) {
                                Text("Sign In").foregroundColor(.green)
                            }
                        }
                        Spacer()
                    }
                }
            }
            .sheet(isPresented: $model.isLoginSheetPresented) {
                NavigationView {
                    LoginView(model: model)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {model.showProfile.toggle()}) {
                    Text("Done").bold()
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static let model = MockModel()
    
    static var previews: some View {
        ProfileView(model: model)
    }
}
