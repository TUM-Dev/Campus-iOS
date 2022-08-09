//
//  Spinner.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import Foundation
import SwiftUI

public struct RingProgressViewStyle: ProgressViewStyle {
  private let defaultSize: CGFloat = 65
  private let lineWidth: CGFloat = 7
  private let defaultProgress = 0.2

  @State private var fillRotationAngle = Angle.degrees(-90)

  public func makeBody(configuration: ProgressViewStyleConfiguration) -> some View {
    VStack {
      configuration.label
      progressCircleView(fractionCompleted: configuration.fractionCompleted ?? defaultProgress,
               isIndefinite: configuration.fractionCompleted == nil) // UPDATE
      configuration.currentValueLabel
    }
  }

  private func progressCircleView(fractionCompleted: Double,
                              isIndefinite: Bool) -> some View {
    Circle()
      .strokeBorder(Color.gray.opacity(0.5), lineWidth: lineWidth, antialiased: true)
      .overlay(fillView(fractionCompleted: fractionCompleted, isIndefinite: isIndefinite))
      .frame(width: defaultSize, height: defaultSize)
  }

  private func fillView(fractionCompleted: Double,
                              isIndefinite: Bool) -> some View {
    Circle()
      .trim(from: 0, to: CGFloat(fractionCompleted))
      .stroke(Color.blue, lineWidth: lineWidth)
      .frame(width: defaultSize - lineWidth, height: defaultSize - lineWidth)
      .rotationEffect(fillRotationAngle)
      .onAppear {
        if isIndefinite {
            withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: false)) {
            fillRotationAngle = .degrees(270)
          }
        }
      }
  }
}
