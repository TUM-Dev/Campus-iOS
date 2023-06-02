//
//  ProfileView.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel
    
    @State var showActionSheet = false
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @AppStorage("calendarWeekDays") var calendarWeekDays: Int = 7
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var isWebViewShowed = false
    @State private var showSheet: Bool = false
    @State private var url: URL?
    
    init(model: Model) {
        self._vm = StateObject(wrappedValue: ProfileViewModel(model: model, service: ProfileService()))
        self.url = .init(string: "https://google.com")
    }
    
    var body: some View {
        NavigationView {
            List {
                if case .success(let profile) = vm.profileState {
                    NavigationLink(destination: PersonDetailedScreenSearch(model: self.vm.model, profile: profile)) {
                        
                        ProfileCell(model: self.vm.model, profile: profile)
                    }.disabled(!self.vm.model.isUserAuthenticated)
                } else {
                    ProfileCell(model: self.vm.model, profile: ProfileViewModel.defaultProfile)
                }
                
                Section("MY TUM") {
                    NavigationLink(destination: PersonSearchScreen(model: self.vm.model).navigationBarTitle(Text("Person Search")).navigationBarTitleDisplayMode(.large)) {
                        Label("Person Search", systemImage: "magnifyingglass")
                    }
                    .disabled(!self.vm.model.isUserAuthenticated)
                    
                    NavigationLink(destination: LectureSearchScreen(model: vm.model).navigationBarTitle(Text("Lecture Search")).navigationBarTitleDisplayMode(.large)) {
                        Label("Lecture Search", systemImage: "brain.head.profile")
                    }
                    .disabled(!self.vm.model.isUserAuthenticated)
                }
                .listRowBackground(Color.secondaryBackground)
                
                Section("GENERAL") {
                    NavigationLink(destination: TUMSexyScreen().navigationBarTitle(Text("Useful Links"))) {
                        Label("TUM.sexy", systemImage: "heart")
                    }
                    
                    NavigationLink(
                        destination: NavigaTumView(model: self.vm.model)
                            .navigationTitle(Text("Roomfinder"))
                            .navigationBarTitleDisplayMode(.large)
                    ) {
                        Label("Roomfinder", systemImage: "rectangle.portrait.arrowtriangle.2.inward")
                    }
                    
                    NavigationLink(destination: NewsScreen(isWidget: false)
                        .navigationBarTitle(Text("News"))
                        .navigationBarTitleDisplayMode(.large)
                    ) {
                        Label("News", systemImage: "newspaper")
                    }
                    
                    NavigationLink(destination: MoviesScreen(isWidget: false)
                        .navigationBarTitle(Text("Movies"))
                        .navigationBarTitleDisplayMode(.large)
                    ) {
                        Label("Movies", systemImage: "film")
                    }
                    
                    NavigationLink(destination: TokenPermissionsView(viewModel: TokenPermissionsViewModel(model: self.vm.model), dismissWhenDone: true).navigationBarTitle("Check Permissions")) {
                        if self.vm.model.isUserAuthenticated {
                            Label("Token Permissions", systemImage: "key")
                        } else {
                            Label("Token Permissions (You are logged out)", systemImage: "key")
                        }
                        
                    }.disabled(!self.vm.model.isUserAuthenticated)
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
                    .listRowBackground(Color.secondaryBackground)
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(.black)
                }
                
                Section("GET IN CONTACT") {
                    if self.useBuildInWebView {
                        Button("Join Beta") {
                            self.url = URL(string: "https://testflight.apple.com/join/4Ddi6f2f")!
                            showSheet = true
                        }
                        
                        Button("TUM Dev on Github") {
                            self.url = URL(string: "https://github.com/TUM-Dev")!
                            showSheet = true
                        }
                        
                        Button("TUM Dev Website") {
                            self.url = URL(string: "https://tum.app")!
                            showSheet = true
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
                        if vm.model.isUserAuthenticated {
                            Button(action: {
                                vm.model.logout()
                            }) {
                                Text("Sign Out").foregroundColor(.red)
                            }
                        } else {
                            Button(action: {
                                vm.model.isLoginSheetPresented = true
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
            .sheet(isPresented: $vm.model.isLoginSheetPresented) {
                NavigationView {
                    LoginView(model: vm.model)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("Done").bold()
                }
                
            }
            .sheet(item: $selectedLink) { selectedLink in
                // This if clause is needed since after logout via the ProfileView an issue occured. This fixes the weird behaviour.
                SFSafariViewWrapper(url: selectedLink)
            }
        }.task {
            await vm.getProfile(forcedRefresh: false)
        }
    }
}

struct ProfileCell: View {
    @StateObject var model: Model
    let profile: Profile
    
    var body: some View {
        HStack(spacing: 24) {
            if let image = profile.image {
                image
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                    .foregroundColor(Color(.secondaryLabel))
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            VStack(alignment: .leading) {
                if self.model.isUserAuthenticated {
                    Text(profile.fullName)
                        .font(.title2)
                    Text(profile.tumID ?? "TUM ID")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("Not logged in")
                        .font(.title2)
                }
                
                
            }
        }
        .padding(.vertical, 6)
    }
}
