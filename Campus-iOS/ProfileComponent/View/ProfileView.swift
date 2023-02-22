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
    @Environment(\.colorScheme) var colorScheme
    @State var isWebViewShowed = false
    @State var selectedLink: URL? = nil

    var body: some View {
        
        NavigationView {
            if #available(iOS 16.0, *) {
                List {
                    NavigationLink(destination: PersonDetailedView(withProfile: self.model.profile.profile ?? ProfileViewModel.defaultProfile)) {
                        HStack(spacing: 24) {
                            self.model.profile.profileImage
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .foregroundColor(Color(.secondaryLabel))
                            
                            VStack(alignment: .leading) {
                                if self.model.isUserAuthenticated {
                                    Text(self.model.profile.profile?.fullName ?? "TUM Student")
                                        .font(.title2)
                                } else {
                                    Text("Not logged in")
                                        .font(.title2)
                                }
                                
                                Text(self.model.profile.profile?.tumID ?? "TUM ID")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .listRowBackground(Color.secondaryBackground)
                    .disabled(!self.model.isUserAuthenticated)
                    
                    ProfileMyTumSection()
                        .listRowBackground(Color.secondaryBackground)
                    
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
                        
                        NavigationLink(destination: NewsView(viewModel: NewsViewModel())
                            .navigationBarTitle(Text("Aktuelles"))
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
                        
                        NavigationLink(destination: TokenPermissionsView(viewModel: TokenPermissionsViewModel(model: self.model), dismissWhenDone: true).navigationBarTitle("Check Permissions")) {
                            if self.model.isUserAuthenticated {
                                Label("Token Permissions", systemImage: "key")
                            } else {
                                Label("Token Permissions (You are logged out)", systemImage: "key")
                            }
                            
                        }.disabled(!self.model.isUserAuthenticated)
                    }
                    .listRowBackground(Color.secondaryBackground)
                    
                    Section() {
                        VStack {
                            Toggle("Use build-in Web View", isOn: $useBuildInWebView)
                        }
                    }
                    .listRowBackground(Color.secondaryBackground)
                    
                    Section() {
                        HStack {
                            
                            if #unavailable(iOS 16.0) {
                                Text("Calendar days in week mode")
                                    .foregroundColor(Color(.label))
                                Spacer()
                            }
                            Picker(selection: $calendarWeekDays, label: Text("Calendar days in week mode").foregroundColor(Color(.label))) {
                                ForEach(2..<8) { number in
                                    Text("\(number)")
                                        .tag(number)
                                }
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.black)
                    }
                    .listRowBackground(Color.secondaryBackground)
                    
                    Section("GET IN CONTACT") {
                        if self.useBuildInWebView {
                            Button("Join Beta") {
                                self.selectedLink = URL(string: "https://testflight.apple.com/join/4Ddi6f2f")
                            }
                            
                            Button("TUM Dev on Github") {
                                self.selectedLink = URL(string: "https://github.com/TUM-Dev")
                            }
                            
                            Button("TUM Dev Website") {
                                self.selectedLink = URL(string: "https://tum.app")
                            }
                        } else {
                            Link(LocalizedStringKey("Join Beta"), destination: URL(string: "https://testflight.apple.com/join/4Ddi6f2f")!)
                            
                            Link(LocalizedStringKey("TUM Dev on Github"), destination: URL(string: "https://github.com/TUM-Dev")!)
                            
                            Link("TUM Dev Website", destination: URL(string: "https://tum.app")!)
                        }
                        
                        Button("Feedback") {
                            let mailToString = "mailto:app@tum.de?subject=[IOS]&body=Hello I have an issue...".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            let mailToUrl = URL(string: mailToString!)!
                            if UIApplication.shared.canOpenURL(mailToUrl) {
                                UIApplication.shared.open(mailToUrl, options: [:])
                            }
                        }
                    }
                    .listRowBackground(Color.secondaryBackground)
                    
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
                    .listRowBackground(Color.secondaryBackground)
                    
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
                                Text("Version 4.1").foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .init(UIColor.darkGray))
                                Spacer()
                            }
                        }
                    }
                    .listRowBackground(Color.secondaryBackground)
                    .actionSheet(isPresented: self.$showActionSheet) {
                        //ActionSheet(title: Text("Choose Speaker"), buttons: self.actionSheetButtons)
                        ActionSheet(title: Text("Change App icon"), message: Text("Select a new design"), buttons: [
                            .default(Text("Default 🎓")) { UIApplication.shared.setAlternateIconName(nil) },
                            .default(Text("Inverted 🔄")) { UIApplication.shared.setAlternateIconName("inverted") },
                            .default(Text("Pride 🏳️‍🌈")) { UIApplication.shared.setAlternateIconName("pride") },
                            .default(Text("3D 📐")) { UIApplication.shared.setAlternateIconName("3D") },
                            .default(Text("Outline 🖍")) { UIApplication.shared.setAlternateIconName("outline") },
                            .cancel()
                        ])
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .background(Color.primaryBackground)
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
                .sheet(item: $selectedLink) { selectedLink in
                    if let link = selectedLink {
                        SFSafariViewWrapper(url: link)
                    }
                }
                .background(Color.primaryBackground)
            } else {
                Text("This content is only available on iOS 16 or higher 🫠").padding(.horizontal)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProfileView(model: MockModel()).environmentObject(MockModel())
    }
}
