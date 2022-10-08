//
//  WidgetMapBackgroundView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 17.07.22.
//

import SwiftUI
import MapKit

// Sources:
// https://codakuma.com/swiftui-static-maps/
// https://stackoverflow.com/a/42773351
struct WidgetMapBackgroundView: View {
    
    let coordinate: CLLocationCoordinate2D
    let region: MKCoordinateRegion
    @State var image: UIImage?
    var size: WidgetSize
    
    private let easeInDuration: Double = 0.3 // seconds
    
    init(coordinate: CLLocationCoordinate2D, size: WidgetSize) {
        self.coordinate = coordinate
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude - 0.03
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        self.size = size
        self.image = nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image {
                    Image(uiImage: image)
                        .blur(radius: 2)
                }

                Rectangle().foregroundColor(.widget.opacity(image == nil ? 1 : 0.9))
            }
            .task {
                generateSnapshot(width: geometry.size.width, height: geometry.size.height)
            }
            .onChange(of: size) { _ in
                generateSnapshot(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
    
    func generateSnapshot(width: CGFloat, height: CGFloat) {
        
        self.image = nil
        
        let mapOptions = MKMapSnapshotter.Options()
        mapOptions.region = region
        mapOptions.size = CGSize(width: width, height: height)
        mapOptions.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(options: mapOptions)
        
        snapshotter.start { (snapshot, error) in
            
            guard let snapshot, error == nil else {
                return
            }
            
            let image = UIGraphicsImageRenderer(size: mapOptions.size).image { _ in
                snapshot.image.draw(at: .zero)
                
                let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                let pinImage = pinView.image
                
                var point = snapshot.point(for: self.coordinate)
                let rect = CGRect(origin: .zero, size: mapOptions.size)
                if rect.contains(point) {
                    point.x -= pinView.bounds.width / 2
                    point.y -= pinView.bounds.height / 2
                    point.x += pinView.centerOffset.x
                    point.y += pinView.centerOffset.y
                    pinImage?.draw(at: point)
                }
            }
            
            withAnimation(.easeIn(duration: easeInDuration)) {
                self.image = image
            }
        }
    }
}

struct WidgetMapBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetMapBackgroundView(coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42), size: .bigSquare)
    }
}
