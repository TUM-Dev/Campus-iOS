//
//  AnalyticsOptInView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 06.09.22.
//

import SwiftUI
import MapKit

struct AnalyticsOptInView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("didShowAnalyticsOptIn") private var didShowAnalyticsOptIn: Bool = false
    @AppStorage("analyticsOptIn") private var analyticsOptIn: Bool = false
    @State private var showMore: Bool
    private var locationManager = CLLocationManager()
    
    init(showMore: Bool = false) {
        self._showMore = State(initialValue: showMore)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("🚀 Support my Bachelor's Thesis")
                        .bold()
                        .font(.largeTitle)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.top, .bottom]) // Top padding because this view is meant to be shown as a sheet.
                    
                    Text("If you let us temporarily store some anonymized usage data, we can make your TUM Campus App experience even better.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom)
                    
                    if (!showMore) {
                        Button {
                            withAnimation {
                                showMore.toggle()
                            }
                        } label: {
                            Text("Read more")
                        }
                    } else {
                      AnalyticsDetailsView()
                    }
                    
                    Spacer()
                    
                    Group {
                        
                        Text("Please allow location access while using the app for this to work.")
                            .bold()
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Button {
                            dismiss(didAccept: true)
                        } label: {
                            Text("Yes, I'm in!")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding([.top, .bottom])
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("No, thanks")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: geometry.size.height, alignment: .leading)
            }
        }
        .interactiveDismissDisabled()
    }
    
    private func dismiss(didAccept: Bool = false) {
        analyticsOptIn = didAccept
        didShowAnalyticsOptIn = true // Dismisses the sheet shown at the initial app launch.
        presentationMode.wrappedValue.dismiss() // Dismisses the view when coming from the profile screen.
        self.locationManager.requestWhenInUseAuthorization()
    }
}

struct AnalyticsDetailsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            Divider()
                .padding(.bottom)
            
            Text("For some selected views, we would like to collect")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom)
            
            AnalyticsDetailView(
                symbol: "📱",
                heading: "The View",
                details: "The view you are looking at. We cannot see any of the content. For example, we can store that you are viewing the Grades screen, but we can never see your grades."
            )
                .padding(.bottom)
            
            AnalyticsDetailView(
                symbol: "📍",
                heading: "The Location",
                details: "Your device location when you are looking at the respective view."
            )
                .padding(.bottom)
            
            AnalyticsDetailView(
                symbol: "⏱",
                heading: "The Time",
                details: "The date and time when you look at the view."
            )
                .padding(.bottom)
            
            AnalyticsDetailView(
                symbol: "🔣",
                heading: "An Anonymous Identifier",
                details: "An anonymized identifier. We compute a one-way hash value of your device identifier - your actual device identifier will never leave your device."
            )
                .padding(.bottom)
            
            AnalyticsDetailView(
                symbol: "❓",
                heading: "Why?",
                details: "In the context of my Bachelor's thesis, I aim to implement intelligent widget views that display to you the content you most likely want to see at any given time and location. Ideally, you will see the content you are interested in at one glance - without having to press any buttons."
            )
                .padding(.bottom)
            
            Text("Sounds good?")
                .frame(maxWidth: .infinity)
                .padding(.bottom)
        }
    }
}

struct AnalyticsDetailView: View {
    
    let symbol: String
    let heading: LocalizedStringKey
    let details: LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(symbol)
                    .frame(width: 30, height: 30)
                
                Text(heading)
                    .bold()
            }
            .font(.title2)
            .padding(.bottom, 2)
            
            Text(details)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct AnalyticsOptInView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsOptInView()
        AnalyticsOptInView()
            .environment(\.locale, .init(identifier: "de"))
        AnalyticsOptInView()
            .preferredColorScheme(.dark)
    }
}
