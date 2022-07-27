//
//  CanteenView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 22.05.22.
//

import SwiftUI

struct CafeteriaView: View {
    
    @Binding var selectedCanteen: Cafeteria?
    
    var body: some View {
        if let canteen = self.selectedCanteen {
            
            VStack {
                HStack {
                    Text(canteen.name)
                        .bold()
                        .font(.title3)
                    
                    Spacer()

                    Button(action: {
                        selectedCanteen = nil
                    }, label: {
                        Text("Done")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                                .padding(.all, 5)
                                .background(Color.clear)
                                .accessibility(label:Text("Close"))
                                .accessibility(hint:Text("Tap to close the screen"))
                                .accessibility(addTraits: .isButton)
                                .accessibility(removeTraits: .isImage)
                    })
                }
                                
                HStack {
                    Text(canteen.location.address)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        let latitude = canteen.location.latitude
                        let longitude = canteen.location.longitude
                        let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
                           
                        if UIApplication.shared.canOpenURL(url!) {
                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                    }, label: {
                        Text("Show Directions")
                            .foregroundColor(Color(UIColor.tumBlue))
                            .font(.footnote)
                    })
                }
            }
            .padding(.all, 10)
        }
    }
}

struct CanteenView_Previews: PreviewProvider {
    static var previews: some View {
        CafeteriaView(selectedCanteen: .constant(nil))
    }
}
