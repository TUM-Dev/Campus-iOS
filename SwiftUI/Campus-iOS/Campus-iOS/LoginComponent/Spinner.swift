//
//  Spinner.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import Foundation
import SwiftUI

struct Spinner: View {
    let rotationTime: Double = 0.75
    let animationTime: Double = 1.9 // Sum of all animation times
    let fullRotation: Angle = .degrees(360)
    static let initialDegree: Angle = .degrees(270)

    @State var spinnerStart: CGFloat = 0.0
    @State var spinnerEndS1: CGFloat = 0.03
    @State var spinnerEndS2S3: CGFloat = 0.03

    @State var rotationDegreeS1 = initialDegree
    @State var rotationDegreeS2 = initialDegree
    @State var rotationDegreeS3 = initialDegree

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("logo-blue")
                    .resizable()
                    .frame(width: 175, height: 100, alignment: .center)
                Spacer().frame(height: 100)
                ZStack {
                    // S3
                    SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS3, color: Color.blue)

                    // S2
                    SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS2, color: Color.white)

                    // S1
                    SpinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1, color: Color.blue)
                }.frame(width: 150, height: 150)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { _ in
                self.animateSpinner()
            }
        }
    }

    // MARK: Animation methods
    func animateSpinner(with duration: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: self.rotationTime)) {
                completion()
            }
        }
    }

    func animateSpinner() {
        animateSpinner(with: rotationTime) { self.spinnerEndS1 = 1.0 }

        animateSpinner(with: (rotationTime * 2) - 0.025) {
            self.rotationDegreeS1 += fullRotation
            self.spinnerEndS2S3 = 0.8
        }

        animateSpinner(with: (rotationTime * 2)) {
            self.spinnerEndS1 = 0.03
            self.spinnerEndS2S3 = 0.03
        }

        animateSpinner(with: (rotationTime * 2) + 0.0525) { self.rotationDegreeS2 += fullRotation }

        animateSpinner(with: (rotationTime * 2) + 0.225) { self.rotationDegreeS3 += fullRotation }
    }
}

// MARK: SpinnerCircle
struct SpinnerCircle: View {
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    var color: Color

    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Spinner()
        }
    }
}
