//
//  ProfileView.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileView: View {
    @State var showActionSheet = false
    @ObservedObject var model: Model
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @AppStorage("calendarWeekDays") var calendarWeekDays: Int = 7

    var body: some View {
        
        NavigationView {
            
            List {
                NavigationLink(destination: PersonDetailedView(withProfile: self.model.profile.profile ?? ProfileViewModel.defaultProfile)) {
                    HStack(spacing: 24) {
                        self.model.profile.profileImage
                            .resizable()
                            .foregroundColor(Color(.secondaryLabel))
                            .frame(width: 75, height: 75)
                        
                        VStack(alignment: .leading) {
                            Text(self.model.profile.profile?.fullName ?? "Not logged in")
                                .font(.title2)
                            
                            Text(self.model.profile.profile?.tumID ?? "TUM ID")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 6)
                }.disabled(!self.model.isUserAuthenticated)
                
                ProfileMyTumSection()
                
                Section("GENERAL") {
                    NavigationLink(destination: TUMSexyView().navigationBarTitle(Text("Useful Links"))) {
                        Label("TUM.sexy", systemImage: "heart")
                    }
                    
                    NavigationLink(
                        destination: RoomFinderView(model: self.model)
                            .navigationTitle(Text("Roomfinder"))
                            .navigationBarTitleDisplayMode(.large)
                    ) {
                        Label("Roomfinder", systemImage: "rectangle.portrait.arrowtriangle.2.inward")
                    }
                    
                    NavigationLink(destination: NewsView()
                                    .navigationBarTitle(Text("News"))
                                    .navigationBarTitleDisplayMode(.large)
                    ) {
                        Label("News", systemImage: "newspaper")
                    }
                    
                    NavigationLink(destination: MoviesView()
                                    .navigationBarTitle(Text("Movies"))
                                    .navigationBarTitleDisplayMode(.large)
                    ) {
                        Label("Movies", systemImage: "film")
                    }
                }
                
                Section() {
                    VStack {
                        Toggle("Use build-in Web View", isOn: $useBuildInWebView)
                    }
                }
                
                Section() {
                    HStack {
                        
                        Text("Calendar days in week mode")
                        Spacer()
                        Picker(selection: $calendarWeekDays, label: Text("Calendar days in week mode")) {
                            ForEach(2..<8) { number in
                                Text("\(number)")
                                    .tag(number)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(.black)
                }
                
                Section("GET IN CONTACT") {
                    Link(LocalizedStringKey("Join Beta"), destination: URL(string: "https://testflight.apple.com/join/4Ddi6f2f")!)
                    
                    Link(LocalizedStringKey("TUM Dev on Github"), destination: URL(string: "https://github.com/TUM-Dev")!)
                    
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
                
                Section() {
                    var i = 0
                    Button(action: {
                        i += 1
                        if i == 5 {
                            i = 0
                            self.showActionSheet = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Image("3D")
                                .resizable()
                                .frame(width: 10, height: 10)
                            Text("ABC").foregroundColor(Color.black)
                            Spacer()
                        }
                    }
                }
                .actionSheet(isPresented: self.$showActionSheet) {
                    //ActionSheet(title: Text("Choose Speaker"), buttons: self.actionSheetButtons)
                    ActionSheet(title: Text("Change background"), message: Text("Select a new color"), buttons: [
                        .default(Text("Red") + Text(Image("3D").resizable()), action: { print("Pressed Red") }),
                        .default(Text("Green")) { background(Color.green) },
                        .default(Text("Blue")) { background(Color.blue) },
                        .cancel()
                    ])
                }
                .listRowBackground(Color.clear)
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
