//
//  EventsView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.06.23.
//

import SwiftUI

struct EventsView: View {
    @ObservedObject var model: Model
    @StateObject var viewModel = EventViewModel()
    var body: some View {
        VStack {
            ForEach(viewModel.allTalks, id: \.title) { talk in
                NavigationLink(destination: EventDetailsView(event: talk)) {
                    EventElementView(event: talk)
                }
            }
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .task {
            await talks()
        }
    }
    
    func talks() async {
        await self.viewModel.fetch()
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(model: MockModel())
    }
}
