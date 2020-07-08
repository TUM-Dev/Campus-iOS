//
//  CalendarEventViewModel.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 11.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import CalendarKit
import UIKit

final class CalendarEventViewModel: EventDescriptor {
    var startDate: Date
    var endDate: Date
    var isAllDay = false
    var text: String
    var attributedText: NSAttributedString?
    var color = UIColor.systemBlue {
        didSet {
            updateColors()
        }
    }
    var backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
    var textColor = UIColor.label
    var font = UIFont.boldSystemFont(ofSize: 12)
    var userInfo: Any?
    weak var editedEvent: EventDescriptor? {
        didSet {
            updateColors()
        }
    }

    init(startDate: Date, endDate: Date, text: String, attributedText: NSAttributedString? = nil, userInfo: Any? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.text = text
        self.attributedText = attributedText
        self.userInfo = userInfo
    }

    init?(event: CalendarEvent) {
        guard let startDate = event.startDate, let endDate = event.endDate, let title = event.title else { return nil }
        self.startDate = startDate
        self.endDate = endDate
        self.text = title
        let attributedTitle = NSMutableAttributedString(string: title).font(.systemFont(ofSize: 12, weight: .semibold)).color(.label)
        if let location = event.location {
            let attributedLocation = NSMutableAttributedString(string: location).font(.systemFont(ofSize: 12, weight: .light)).color(.label)
            attributedTitle.append(NSAttributedString(string: "\n"))
            attributedTitle.append(attributedLocation)
        }
        if let description = event.descriptionText {
            let attributedLocation = NSMutableAttributedString(string: description).font(.systemFont(ofSize: 12, weight: .light)).color(.secondaryLabel)
            attributedTitle.append(NSAttributedString(string: "\n\n"))
            attributedTitle.append(attributedLocation)
        }
        self.attributedText = attributedTitle
    }

    func makeEditable() -> CalendarEventViewModel {
        return CalendarEventViewModel(startDate: startDate, endDate: endDate, text: text, attributedText: attributedText, userInfo: userInfo)
    }

    func commitEditing() {
        guard let edited = editedEvent else {return}
        edited.startDate = startDate
        edited.endDate = endDate
    }

    private func updateColors() {
        (editedEvent != nil) ? applyEditingColors() : applyStandardColors()
    }

    private func applyStandardColors() {
        backgroundColor = color.withAlphaComponent(0.3)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        textColor = UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a)
    }

    private func applyEditingColors() {
        backgroundColor = color
        textColor = .white
    }

}
