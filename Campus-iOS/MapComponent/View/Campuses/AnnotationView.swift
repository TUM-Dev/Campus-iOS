//
//  PlaceAnnotationView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 03.06.23.
//

import SwiftUI
import MapKit

struct AnnotationView: View {
    
    @State var isSelected = false
    var location: TUMLocation
    @StateObject var vm: AnnotatedMapViewModel
    
    var body: some View {
        ZStack {
            if isSelected {
                Group {
                    NavigationLink (destination: LocationView(location: location)) {
                        HStack {
                            Text(location.name)
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                                .frame(maxWidth: 200)
                                .lineLimit(1)
                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                                .font(.footnote)
                        }
                        .fixedSize()
                        .padding(7)
                        .background(Color.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                    }
                }
                .offset(x: 0, y: 30)
            }
            
            VStack(spacing: 0) {
                location.symbol
                    .resizable()
                    .foregroundColor(Color.highlightText)
                    .frame(width: isSelected ? 50 : 20, height: isSelected ? 50 : 20)
                    .background(.white)
                    .clipShape(Circle())
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(Color.highlightText)
                    .offset(x: 0, y: isSelected ? -2 : -5)
            }
            .transition(.scale)
            .offset(x: 0, y: isSelected ? -18 : 0)
            .onTapGesture {
                vm.openAnnotation = location.id
                withAnimation {
                    isSelected.toggle()
                }
            }.onChange(of: vm.openAnnotation) { newValue in
                if vm.openAnnotation != self.location.id {
                    withAnimation {
                        isSelected = false
                    }
                }
            }
        }
    }
}
