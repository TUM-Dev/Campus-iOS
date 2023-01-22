//
//  ProfileView.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileView2: View {
    @StateObject var vm: ProfileViewModel2
    
    @State var showActionSheet = false
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @AppStorage("calendarWeekDays") var calendarWeekDays: Int = 7
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var isWebViewShowed = false
    @State var selectedLink: URL? = nil
    
    init(model: Model) {
        self._vm = StateObject(wrappedValue: ProfileViewModel2(model: model, service: ProfileService()))
    }
    
    var body: some View {
        NavigationView {
            List {
                if case .success(let profile) = vm.profileState {
                    NavigationLink(destination: PersonDetailedScreen(model: self.vm.model, profile: profile)) {
                        
                        ProfileCell(model: self.vm.model, profile: profile)
                    }.disabled(!self.vm.model.isUserAuthenticated)
                } else {
                    ProfileCell(model: self.vm.model, profile: ProfileViewModel2.defaultProfile)
                }
                
                Section("MY TUM") {
                    TuitionScreen(vm: self.vm)
                    
                    NavigationLink(destination: PersonSearchScreen(model: self.vm.model).navigationBarTitle(Text("Person Search")).navigationBarTitleDisplayMode(.large)) {
                        Label("Person Search", systemImage: "magnifyingglass")
                    }
                    .disabled(!self.vm.model.isUserAuthenticated)
                    
                    NavigationLink(destination: LectureSearchScreen(model: vm.model).navigationBarTitle(Text("Lecture Search")).navigationBarTitleDisplayMode(.large)) {
                        Label("Lecture Search", systemImage: "brain.head.profile")
                    }
                    .disabled(!self.vm.model.isUserAuthenticated)
                }
                
                Section("GENERAL") {
                    NavigationLink(destination: TUMSexyView().navigationBarTitle(Text("Useful Links"))) {
                        Label("TUM.sexy", systemImage: "heart")
                    }
                    
                    NavigationLink(
                        destination: RoomFinderView(model: self.vm.model)
                            .navigationTitle(Text("Roomfinder"))
                            .navigationBarTitleDisplayMode(.large)
                    ) {
                        Label("Roomfinder", systemImage: "rectangle.portrait.arrowtriangle.2.inward")
                    }
                    
                    NavigationLink(destination: NewsView(viewModel: NewsViewModel())
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
                    
                    NavigationLink(destination: TokenPermissionsView(viewModel: TokenPermissionsViewModel(model: self.vm.model), dismissWhenDone: true).navigationBarTitle("Check Permissions")) {
                        if self.vm.model.isUserAuthenticated {
                            Label("Token Permissions", systemImage: "key")
                        } else {
                            Label("Token Permissions (You are logged out)", systemImage: "key")
                        }
                        
                    }.disabled(!self.vm.model.isUserAuthenticated)
                }
                
                Section() {
                    VStack {
                        Toggle("Use build-in Web View", isOn: $useBuildInWebView)
                    }
                }
                
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
            .sheet(isPresented: $vm.model.isLoginSheetPresented) {
                NavigationView {
                    LoginView(model: vm.model)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("Done").bold()
                }

            }
            .sheet(item: $selectedLink) { selectedLink in
                if let link = selectedLink {
                    SFSafariViewWrapper(url: link)
                }
            }
        }.onAppear {
            Task {
                await vm.getProfile(forcedRefresh: false)
                print("getProfile")
            }
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

//struct ProfileView: View {
//    @State var showActionSheet = false
//    @ObservedObject var model: Model
//    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
//    @AppStorage("calendarWeekDays") var calendarWeekDays: Int = 7
//    @Environment(\.colorScheme) var colorScheme
//    @State var isWebViewShowed = false
//    @State var selectedLink: URL? = nil
//
//    var body: some View {
//
//        NavigationView {
//
//            List {
//                NavigationLink(destination: PersonDetailedScreen(model: self.model, profile: self.model.profile.profile ?? ProfileViewModel.defaultProfile)) {
//                    HStack(spacing: 24) {
//                        self.model.profile.profileImage
//                            .resizable()
//                            .clipShape(Circle())
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 75, height: 75)
//                            .foregroundColor(Color(.secondaryLabel))
//
//                        VStack(alignment: .leading) {
//                            if self.model.isUserAuthenticated {
//                                Text(self.model.profile.profile?.fullName ?? "TUM Student")
//                                    .font(.title2)
//                            } else {
//                                Text("Not logged in")
//                                    .font(.title2)
//                            }
//
//                            Text(self.model.profile.profile?.tumID ?? "TUM ID")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding(.vertical, 6)
//                }.disabled(!self.model.isUserAuthenticated)
//
//                ProfileMyTumSection()
//
//                Section("GENERAL") {
//                    NavigationLink(destination: TUMSexyView().navigationBarTitle(Text("Useful Links"))) {
//                        Label("TUM.sexy", systemImage: "heart")
//                    }
//
//                    NavigationLink(
//                        destination: RoomFinderView(model: self.model)
//                            .navigationTitle(Text("Roomfinder"))
//                            .navigationBarTitleDisplayMode(.large)
//                    ) {
//                        Label("Roomfinder", systemImage: "rectangle.portrait.arrowtriangle.2.inward")
//                    }
//
//                    NavigationLink(destination: NewsView(viewModel: NewsViewModel())
//                                    .navigationBarTitle(Text("News"))
//                                    .navigationBarTitleDisplayMode(.large)
//                    ) {
//                        Label("News", systemImage: "newspaper")
//                    }
//
//                    NavigationLink(destination: MoviesView()
//                                    .navigationBarTitle(Text("Movies"))
//                                    .navigationBarTitleDisplayMode(.large)
//                    ) {
//                        Label("Movies", systemImage: "film")
//                    }
//
//                    NavigationLink(destination: TokenPermissionsView(viewModel: TokenPermissionsViewModel(model: self.model), dismissWhenDone: true).navigationBarTitle("Check Permissions")) {
//                        if self.model.isUserAuthenticated {
//                            Label("Token Permissions", systemImage: "key")
//                        } else {
//                            Label("Token Permissions (You are logged out)", systemImage: "key")
//                        }
//
//                    }.disabled(!self.model.isUserAuthenticated)
//                }
//
//                Section() {
//                    VStack {
//                        Toggle("Use build-in Web View", isOn: $useBuildInWebView)
//                    }
//                }
//
//                Section() {
//                    HStack {
//
//                        if #unavailable(iOS 16.0) {
//                            Text("Calendar days in week mode")
//                                .foregroundColor(Color(.label))
//                            Spacer()
//                        }
//                        Picker(selection: $calendarWeekDays, label: Text("Calendar days in week mode").foregroundColor(Color(.label))) {
//                            ForEach(2..<8) { number in
//                                Text("\(number)")
//                                    .tag(number)
//                            }
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                    .foregroundColor(.black)
//                }
//
//                Section("GET IN CONTACT") {
//                    if self.useBuildInWebView {
//                        Button("Join Beta") {
//                            self.selectedLink = URL(string: "https://testflight.apple.com/join/4Ddi6f2f")
//                        }
//
//                        Button("TUM Dev on Github") {
//                            self.selectedLink = URL(string: "https://github.com/TUM-Dev")
//                        }
//
//                        Button("TUM Dev Website") {
//                            self.selectedLink = URL(string: "https://tum.app")
//                        }
//                    } else {
//                        Link(LocalizedStringKey("Join Beta"), destination: URL(string: "https://testflight.apple.com/join/4Ddi6f2f")!)
//
//                        Link(LocalizedStringKey("TUM Dev on Github"), destination: URL(string: "https://github.com/TUM-Dev")!)
//
//                        Link("TUM Dev Website", destination: URL(string: "https://tum.app")!)
//                    }
//
//                    Button("Feedback") {
//                        let mailToString = "mailto:app@tum.de?subject=[IOS]&body=Hello I have an issue...".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                        let mailToUrl = URL(string: mailToString!)!
//                        if UIApplication.shared.canOpenURL(mailToUrl) {
//                                UIApplication.shared.open(mailToUrl, options: [:])
//                        }
//                    }
//                }
//
//                Section() {
//                    HStack(alignment: .bottom) {
//                        Spacer()
//                        if model.isUserAuthenticated {
//                            Button(action: {
//                                model.logout()
//                            }) {
//                                Text("Sign Out").foregroundColor(.red)
//                            }
//                        } else {
//                            Button(action: {
//                                model.isLoginSheetPresented = true
//                            }) {
//                                Text("Sign In").foregroundColor(.green)
//                            }
//                        }
//                        Spacer()
//                    }
//                }
//
//                Section() {
//                    var i = 0
//                    Button(action: {
//                        i += 1
//                        if i == 5 {
//                            i = 0
//                            self.showActionSheet = true
//                        }
//                    }) {
//                        HStack {
//                            Spacer()
//                            Text("Version 4.1").foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .init(UIColor.darkGray))
//                            Spacer()
//                        }
//                    }
//                }
//                .actionSheet(isPresented: self.$showActionSheet) {
//                    //ActionSheet(title: Text("Choose Speaker"), buttons: self.actionSheetButtons)
//                    ActionSheet(title: Text("Change App icon"), message: Text("Select a new design"), buttons: [
//                        .default(Text("Default 🎓")) { UIApplication.shared.setAlternateIconName(nil) },
//                        .default(Text("Inverted 🔄")) { UIApplication.shared.setAlternateIconName("inverted") },
//                        .default(Text("Pride 🏳️‍🌈")) { UIApplication.shared.setAlternateIconName("pride") },
//                        .default(Text("3D 📐")) { UIApplication.shared.setAlternateIconName("3D") },
//                        .default(Text("Outline 🖍")) { UIApplication.shared.setAlternateIconName("outline") },
//                        .cancel()
//                    ])
//                }
//                .listRowBackground(Color.clear)
//            }
//            .sheet(isPresented: $model.isLoginSheetPresented) {
//                NavigationView {
//                    LoginView(model: model)
//                }
//            }
//            .navigationTitle("Profile")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                Button(action: {model.showProfile.toggle()}) {
//                    Text("Done").bold()
//                }
//            }
//            .sheet(item: $selectedLink) { selectedLink in
//                if let link = selectedLink {
//                    SFSafariViewWrapper(url: link)
//                }
//            }
//        }
//    }
//}

//struct ProfileView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ProfileView(model: MockModel()).environmentObject(MockModel())
//    }
//}
