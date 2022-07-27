//
//  ProfileView.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var model: Model
    
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
                
                ProfileMyTumSection(model: model)
                
                Section("GENERAL") {
                    NavigationLink {
                        SettingsView()
                            .navigationBarTitle("Settings")
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    NavigationLink {
                        TUMSexyView()
                            .navigationBarTitle("Useful Links")
                    } label: {
                        Label("TUM.sexy", systemImage: "heart")
                    }
                    
                    NavigationLink {
                        RoomFinderView(model: self.model)
                            .navigationTitle("Roomfinder")
                            .navigationBarTitleDisplayMode(.large)
                    } label: {
                        Label("Roomfinder", systemImage: "rectangle.portrait.arrowtriangle.2.inward")
                    }
                    
                    NavigationLink {
                        NewsView(viewModel: NewsViewModel())
                            .navigationBarTitle("News")
                            .navigationBarTitleDisplayMode(.large)
                    } label: {
                        Label("News", systemImage: "newspaper")
                    }
                    
                    NavigationLink {
                        MoviesView()
                            .navigationBarTitle("Movies")
                            .navigationBarTitleDisplayMode(.large)
                    } label: {
                        Label("Movies", systemImage: "film")
                    }
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
    
    static var previews: some View {
        ProfileView(model: Model())
        NavigationView {
            SettingsView()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
        }
        ChangeAppIconView()
    }
}

struct SettingsView: View {
    
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @AppStorage("calendarWeekDays") var calendarWeekDays: Int = 7
    @State var showActionSheet = false
    
    let appIcons = ["default", "white", "3D", "pride", "outline", "dark"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        List {
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
            
            
            
            Section("Change App Icon") {
                ChangeAppIconView().edgesIgnoringSafeArea(.leading)
            }
            
            Section() {
                HStack {
                    Spacer()
                    Text("Version 4.0").foregroundColor(Color.black)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            
        }
    }
}

struct ChangeAppIconView: View {
    
    let size = UIScreen.main.bounds.width * 0.2
    let appIcons = ["default", "white", "3D", "pride", "outline", "dark"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(appIcons) { appIcon in
                Button {
                    print(appIcon)
                    UIApplication.shared.setAlternateIconName(appIcon == "default" ? nil : appIcon)
                } label: {
                    Image(appIcon)
                        .resizable()
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .frame(width: size, height: size, alignment: .center)
                        .padding([.bottom, .top])
                }.buttonStyle(.borderless)
            }
        }
    }
}
