//
//  ProfileView.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileModel: ProfileModel
    
    var body: some View {
        
        NavigationView {
            
            List {
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
                
                Section("MY TUM") {
                    Label("Studienbeiträge", systemImage: "eurosign.circle")
                    Label("Person Search", systemImage: "magnifyingglass")
                    Label("Lecture Search", systemImage: "brain.head.profile")
                }
                
                Section("ALLGEMEIN") {
                    Label("TUM.sexy", image: "Tum.sexy")
                    Label("Roomfinder", image: "RoomFinder")
                    Label("News", systemImage: "newspaper")
                }
                
                Section("KONTAKTIERE UNS") {
                    Button("Werde Beta-Tester") {
                        
                    }
                    Button("TUM Dev on GitHub") {
                        
                    }
                    Button("TUM Dev Website") {
                        
                    }
                    Button("Feedback") {
                        
                    }
                    Button("Logout", role: .destructive) {
                        
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {profileModel.showProfile.toggle()}) {
                    Text("Done").bold()
                }
            }
        }
    }
}
