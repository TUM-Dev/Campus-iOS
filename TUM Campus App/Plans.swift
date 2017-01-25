//
//  Plans.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 11.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation

class Plans {
    private(set) var plans = [Plan]()
    static var shared = Plans()
    
    init(){
        plans.append(Plan(title: "MVV Gesamtnetz", type: .pdf, fileUrl: "Schnellbahnnetz.pdf", url: "http://www.mvv-muenchen.de/fileadmin/media/Dateien/plaene/pdf/Netz_2017_Version_A4.pdf", address: "", icon: "plan_mvv_icon"))
        plans.append(Plan(title: "MVV Nachtliniennetz", type: .pdf, fileUrl: "Nachtliniennetz.pdf", url: "http://www.mvv-muenchen.de/fileadmin/media/Dateien/plaene/pdf/Nachtnetz_2017.pdf", address: "", icon: "plan_mvv_night_icon"))
        plans.append(Plan(title: "MVV Tramnetz", type: .pdf, fileUrl: "Tramnetz.pdf", url: "http://www.mvv-muenchen.de/fileadmin/media/Dateien/plaene/pdf/Tramnetz_2017.pdf", address: "", icon: "plan_tram_icon"))
        plans.append(Plan(title: "MVV Tarifplan", type: .pdf, fileUrl: "Tarifplan.pdf", url: "http://www.mvv-muenchen.de/fileadmin/media/Dateien/3_Tickets_Preise/dokumente/TARIFPLAN_2017-Innenraum.PDF", address: "", icon: "plan_mvv_entire_net_icon"))
        plans.append(Plan(title: "Campus Garching", type: .image, fileUrl: "plan_campus_garching", url: "", address: "Walter-Meißner-Straße 3, 85748 Garching", icon: "plan_campus_garching_icon"))
        plans.append(Plan(title: "Campus Klinikum", type: .image, fileUrl: "plan_campus_klinikum", url: "", address: "Ismaninger Straße 22, 81675 München", icon: "plan_campus_klinikum_icon"))
        plans.append(Plan(title: "Campus Olympiapark", type: .image, fileUrl: "plan_campus_olympiapark", url: "", address: "Connollystraße 32, 80809 München", icon: "plan_campus_olympiapark_icon"))
        plans.append(Plan(title: "Campus Olympiapark Hallenplan", type: .image, fileUrl: "plan_campus_olympiapark_hallenplan", url: "", address: "Connollystraße 32, 80809 München", icon: "plan_campus_olympiapark_hallenplan_icon"))
        plans.append(Plan(title: "Stammgelände", type: .image, fileUrl: "plan_campus_stammgelaende", url: "", address: "Arcisstraße 21, 80333 München", icon: "plan_campus_stammgelaende_icon"))
        plans.append(Plan(title: "Campus Weihenstephan", type: .image, fileUrl: "plan_campus_weihenstephan", url: "", address: "Liesel-Beckmann-Straße 6, 85354 Freising", icon: "plan_campus_weihenstephan_icon"))
    }
}
