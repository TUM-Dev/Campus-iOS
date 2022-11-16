//
//  NewsItemSourceView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.11.22.
//

import Foundation
import SwiftUI
import CoreData

struct NewsItemSourceView: View {
    @StateObject var vm: NewsViewModelCD
    
    init(context: NSManagedObjectContext, model: Model) {
        self._vm = StateObject(wrappedValue:
                NewsViewModelCD(
                context: context,
                model: model
            )
        )
    }
    
    var body: some View {
        VStack {
            Button("Load Sources") {
                Task {
                    await vm.getNewsItemSources()
                }
            }
            List(vm.newsItemSources) { source in
                Text(source.title ?? "NO TITLE")
            }
        }
    }
}
