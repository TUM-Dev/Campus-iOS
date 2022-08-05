//
//  PersonDetailedView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.02.22.
//

import SwiftUI
import ContactsUI

struct PersonDetailedView: View {
    let imageSize: CGFloat = 125.0
    
    @ObservedObject var viewModel: PersonDetailedViewModel
    
    init(withPerson person: Person) {
        self.viewModel = PersonDetailedViewModel(withPerson: person)
    }
    
    init(withProfile profile: Profile) {
        self.viewModel = PersonDetailedViewModel(withProfile: profile)
    }
    
    var body: some View {
        VStack {
            Spacer()
            if let header = viewModel.sections?.first(where: { $0.name == "Header" })?.cells.first, let cell = header as? PersonDetailsHeader {
                if let image = cell.image {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize, height: imageSize)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(Color(.secondaryLabel))
                        .frame(width: imageSize, height: imageSize)
                }
                Spacer().frame(height: 10)
                Text("\(cell.name)").font(.system(size: 18))
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .padding(2)
            }
            if self.viewModel.sections?.count ?? 0 > 1 {
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
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: AddToContactsView(contact: self.viewModel.cnContact)
                        .navigationBarTitleDisplayMode(.inline)
                ) {
                    Label("", systemImage: "person.crop.circle.badge.plus")
                }.disabled(self.viewModel.sections?.count ?? 0 < 2)
            }
        }
        .onAppear {
            self.viewModel.fetch()
        }
    }

    var form: some View {
        Form {
            ForEach(self.viewModel.sections?.filter({ $0.name != "Header" }) ?? []) { section in
                Section(section.name) {
                    ForEach(section.cells as? [PersonDetailsCell] ?? []) { singleCell in
                        Button(action: {
                            Self.cellActionBasedOnType(cell: singleCell)
                        }, label: { PersonDetailedCellView(cell: singleCell) })
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    static func cellActionBasedOnType(cell: PersonDetailsCell) {
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

struct PersonDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonDetailedView(withPerson: Person(firstName: "Milen", lastName: "Vitanov", title: nil, nr: "12654465", obfuscatedId: "445555dd4", gender: Gender.male))
                .preferredColorScheme(.light)
                .previewInterfaceOrientation(.portrait)
            PersonDetailedView(withPerson: Person(firstName: "Milen", lastName: "Vitanov", title: nil, nr: "12654465", obfuscatedId: "445555dd4", gender: Gender.male))
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portrait)
        }
    }
}
