//
//  PersonDetailedViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.03.23.
//

import SwiftUI

@available(iOS 16.0, *)
struct PersonDetailedViewNEW: View {
    
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var personDetailedViewModel: PersonDetailedViewModel
    @State private var showImageSheet = false
    @Binding var showProfileSheet: Bool
    var studyPrograms: [String]
    
    var body: some View {
        NavigationStack {
            VStack {
                if self.profileViewModel.profileImageUI == nil { //shows default profile icon
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImageSheet = true
                        }
                } else { //show selected profile pic
                    Image(uiImage: self.profileViewModel.profileImageUI!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImageSheet = true
                        }
                }
                
                if let profile = self.profileViewModel.profile {
                    Text(profile.fullName)
                        .font(.title2)
                        .lineLimit(1)
                    ForEach(studyPrograms) { studyprogram in
                        Text(studyprogram)
                            .font(.subheadline)
                    }
                    Text(profile.tumID!)
                        .font(.subheadline)
                } else {
                    ProgressView()
                }
                
                if self.personDetailedViewModel.sections?.count ?? 0 > 1 {
                    form
                } else {
                    List {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                .padding(2)
                            Spacer()
                        }
                    }
                }
                
                Spacer()
            }
            .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.showProfileSheet.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showImageSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileViewModel.profileImageUI)
        }
        .onChange(of: self.profileViewModel.profileImageUI) { newImage in //saves ProfileImage
            if let image = newImage {
                if let fileName = self.profileViewModel.save(image: image) {
                    print("Saved Image to: \(fileName)")
                } else {
                    print("Error in saving Image")
                }
            }
        }
    }
    
    var form: some View { // from PersonDetailedView of Milen Vitanov
        Form {
            ForEach(self.personDetailedViewModel.sections?.filter({ $0.name != "Header" }) ?? []) { section in
                Section(section.name) {
                    ForEach(section.cells as? [PersonDetailsCell] ?? []) { singleCell in
                        Button(action: {
                            Self.cellActionBasedOnType(cell: singleCell)
                        }, label: { PersonDetailedCellView(cell: singleCell) })
                    }.listRowBackground(Color.secondaryBackground)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
    }
    
    static func cellActionBasedOnType(cell: PersonDetailsCell) { // from PersonDetailedView of Milen Vitanov
        switch cell.actionType {
        case .none, .showRoom:
            break
        case .call:
            let number = cell.value.replacingOccurrences(of: " ", with: "")
            if let url = URL(string: "tel://\(number)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .mail:
            if let url = URL(string: "mailto:\(cell.value)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .openURL:
            if let url = URL(string: cell.value) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
