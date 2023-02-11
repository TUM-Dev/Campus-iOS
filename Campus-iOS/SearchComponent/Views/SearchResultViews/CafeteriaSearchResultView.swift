//
//  CafeteriaSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct CafeteriasSearchResultView: View {
    
    @StateObject var vm: CafeteriasSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    @State var cafeteriaMealPlan: Cafeteria? = nil
    
    var results: [(cafeteria: Cafeteria, distances: Distances)] {
        switch size {
        case .small:
            return Array(vm.results.prefix(3))
        case .big:
            return Array(vm.results.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            switch size {
                            case .big:
                                withAnimation {
                                    self.size = .small
                                }
                            case .small:
                                withAnimation {
                                    self.size = .big
                                }
                            }
                        } label: {
                            if self.size == .small {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .padding()
                            } else {
                                Image(systemName: "arrow.down.right.and.arrow.up.left")
                                    .padding()
                            }
                            
                        }
                    }
                }
                
                Spacer()
                ScrollView {
                    ForEach(self.results, id: \.0) { result in
                        CafeteriaRowView(cafeteria: .constant(result.cafeteria))
                            .padding([.leading, .trailing])
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.1)) {
                                    cafeteriaMealPlan = cafeteriaMealPlan == result.cafeteria ? nil : result.cafeteria
                                }
                            }
                    }
                }
                
            }
        }.sheet(item: $cafeteriaMealPlan, content: { cafeteria in
            NavigationView {
                VStack(alignment: .leading) {
                    MealPlanView(viewModel: MealPlanViewModel(cafeteria: cafeteria))
                }
                .navigationBarTitle(Text(cafeteria.title ?? "Current Cafeteria"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                     cafeteriaMealPlan = nil
                }) {
                    Text("Done").bold()
                })
            }
        })
        .onChange(of: query) { newQuery in
            print(query)
            Task {
                await vm.cafeteriasSearch(for: newQuery)
            }
        }.onAppear() {
            Task {
                await vm.cafeteriasSearch(for: query)
            }
        }
    }
}

struct CafeteriasSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        CafeteriasSearchResultView(vm: CafeteriasSearchResultViewModel(service: CafeteriasService_Preview()), query: .constant("Garching"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct CafeteriasService_Preview: CafeteriasServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Cafeteria] {
        return Cafeteria.previewData
    }
}
