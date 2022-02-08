//
//  PersonDetailedView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.02.22.
//

import SwiftUI

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
                    image
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(Circle())
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
            if(self.viewModel.sections?.count ?? 0 > 1) {
                form
            } else {
                List {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .padding(2)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {

                }) {
                    Image(systemName: "person.crop.circle.badge.plus")
                }.disabled(true)
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
                        VStack(alignment: .leading) {
                            Text(singleCell.key)
                            Text(singleCell.value).foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
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
