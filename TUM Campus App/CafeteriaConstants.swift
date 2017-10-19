//
//  CafeteriaConstants.swift
//  Campus
//
//  Created by Mathias Quintero on 10/19/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation

enum CafeteriaConstants {
    
    
    static let priceList = [
        "Tagesgericht 1" : Price(student: 1.00, employee: 1.90, guest: 2.40),
        "Tagesgericht 2" : Price(student: 1.55, employee: 2.25, guest: 2.75),
        "Tagesgericht 3" : Price(student: 1.90, employee: 2.60, guest: 3.10),
        "Tagesgericht 4" : Price(student: 2.40, employee: 2.95, guest: 3.45),
        "Aktionsessen 1" : Price(student: 1.55, employee: 2.25, guest: 2.75),
        "Aktionsessen 2" : Price(student: 1.90, employee: 2.60, guest: 3.10),
        "Aktionsessen 3" : Price(student: 2.40, employee: 2.95, guest: 3.45),
        "Aktionsessen 4" : Price(student: 2.60, employee: 3.30, guest: 3.80),
        "Aktionsessen 5" : Price(student: 2.80, employee: 3.65, guest: 4.15),
        "Aktionsessen 6" : Price(student: 3.00, employee: 4.00, guest: 4.50),
        "Aktionsessen 7" : Price(student: 3.20, employee: 4.35, guest: 4.85),
        "Aktionsessen 8" : Price(student: 3.50, employee: 4.70, guest: 4.85),
        "Aktionsessen 9" : Price(student: 4.00, employee: 5.05, guest: 5.55),
        "Aktionsessen 10" : Price(student: 4.50, employee: 5.40, guest: 5.90),
        "Biogericht 1" : Price(student: 1.55, employee: 2.25, guest: 2.75),
        "Biogericht 2" : Price(student: 1.90, employee: 2.60, guest: 3.10),
        "Biogericht 3" : Price(student: 2.40, employee: 2.95, guest: 3.45),
        "Biogericht 4" : Price(student: 2.60, employee: 3.30, guest: 3.80),
        "Biogericht 5" : Price(student: 2.80, employee: 3.65, guest: 4.15),
        "Biogericht 6" : Price(student: 3.00, employee: 4.00, guest: 4.50),
        "Biogericht 7" : Price(student: 3.20, employee: 4.35, guest: 4.85),
        "Biogericht 8" : Price(student: 3.50, employee: 4.70, guest: 5.20),
        "Biogericht 9" : Price(student: 4.00, employee: 5.05, guest: 5.55),
        "Biogericht 10" : Price(student: 4.50, employee: 5.40, guest: 5.90),
        "Self-Service" : Price(student: 0.00, employee: 0.00, guest: 0.00)
    ]
    
    static let mensaAnnotationsEmoji = [
        "v" : "🌱",
        "f" : "🥕",
        "Kr" : "🦀",
        "99" : "🍷",
        "S" : "🐖",
        "R" : "🐄",
        "Fi" : "🐟",
        "En" : "🥜",
        "Gl" : "🌾"
    ]
    
    static let mensaAnnotationsDescription = [
        "1" : "mit Farbstoff",
        "2" : "mit Konservierungsstoff",
        "3" : "mit Antioxidationsmittel",
        "4" : "mit Geschmacksverstärker",
        "5" : "geschwefelt",
        "6" : "geschwärzt (Oliven)",
        "7" : "unbekannt",
        "8" : "mit Phosphat",
        "9" : "mit Süßungsmitteln",
        "10" : "enthält eine Phenylalaninquelle",
        "11" : "mit einer Zuckerart und Süßungsmitteln",
        "99" : "mit Alkohol",
        "f" : "fleischloses Gericht",
        "v" : "veganes Gericht",
        "GQB" : "Geprüfte Qualität - Bayern",
        "S" : "mit Schweinefleisch",
        "R" : "mit Rindfleisch",
        "K" : "mit Kalbfleisch",
        "MSC" : "Marine Stewardship Council",
        "Kn" : "Knoblauch",
        "13" : "kakaohaltige Fettglasur",
        "14" : "Gelatine",
        "Ei" : "Hühnerei",
        "En" : "Erdnuss",
        "Fi" : "Fisch",
        "Gl" : "Glutenhaltiges Getreide",
        "GlW" : "Weizen",
        "GlR" : "Roggen",
        "GlG" : "Gerste",
        "GlH" : "Hafer",
        "GlD" : "Dinkel",
        "Kr" : "Krebstiere",
        "Lu" : "Lupinen",
        "Mi" : "Milch und Laktose",
        "Sc" : "Schalenfrüchte",
        "ScM" : "Mandeln",
        "ScH" : "Haselnüsse",
        "ScW" : "Walnüsse",
        "ScC" : "Cashewnüssen",
        "ScP" : "Pistazien",
        "Se" : "Sesamsamen",
        "Sf" : "Senf",
        "Sl" : "Sellerie",
        "So" : "Soja",
        "Sw" : "Schwefeloxid und Sulfite",
        "Wt" : "Weichtiere"
    ]
    
    static func parseMensaMenu(_ name: String) -> MenuDetail {
        
        let pattern = "(?:(?<=\\((?:[[a-z][A-Z][0-9]]{1,3},)?)|(?<=,(?:[[a-z][A-Z][0-9]]{1,3},)?))([[a-z][A-Z][0-9]]{1,3})(?=(?:,[[a-z][A-Z][0-9]]{1,3})*\\))"
        var notMatchedEmoji: [String] = []
        var matchedAnnotations: [String] = []
        var matchedEmoji: [String] = []
        var matchedDescriptions: [String] = []
        let output = NSMutableString(string: name)
        var startPoint = output.length
        var withoutAnnotations = String(output)
        var withEmojiWithoutAnnotations = String(output)
        
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            
            let matches = regex.matches(in: output as String, options: [], range: NSMakeRange(0, output.length))
            
            matchedAnnotations = matches.flatMap { output.substring(with: $0.range) }
            
            for match in matches {
                
                let matchedString = output.substring(with: match.range)
                
                startPoint = min(max(match.range.location - 1,0), startPoint)
                
                if let emoji = mensaAnnotationsEmoji[matchedString] {
                    matchedEmoji.append(emoji)
                    
                } else {
                    notMatchedEmoji.append("(\(matchedString))")
                }
                
                if let matchedDescription = mensaAnnotationsDescription[matchedString] {
                    matchedDescriptions.append(matchedDescription)
                }
            }
            
            regex.replaceMatches(in: output, options: [], range: NSMakeRange(0, output.length), withTemplate: "")
            
            let range = NSMakeRange(startPoint, output.length - startPoint)
            
            output.deleteCharacters(in: range)
            withoutAnnotations = String(output)
            matchedEmoji.forEach({output.append($0)})
            withEmojiWithoutAnnotations = String(output)
            notMatchedEmoji.forEach({output.append($0)})
        }
        return MenuDetail(name: String(output),
                          nameWithoutAnnotations: withoutAnnotations,
                          nameWithEmojiWithoutAnnotations: withEmojiWithoutAnnotations,
                          annotations: matchedAnnotations,
                          annotationDescriptions: matchedDescriptions)
    }
    
}
