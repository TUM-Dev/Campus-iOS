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
    
    let x = ["hello", "hey", "Hallo"]
    
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
                NavigationLink(source.title ?? "NO NEWSITEMSOURCE TITLE") {
                    VStack {
                        Button("Load NewsItems") {
                            Task {
                                await vm.getNewsItems(for: source)
                                print("loaded")
                            }
                        }
                        List((source.newsItems?.allObjects as? [NewsItem]) ?? [], id: \.title) { newsItem in
                            Text(newsItem.title ?? "NO NEWSITEM TITLE")
                        }
                    }
                }
                
            }
        }
    }
}
