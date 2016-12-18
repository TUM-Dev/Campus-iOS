//
//  Plans.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 11.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation

class Plans {
    private var plans = [Plan]()
    
    init(){
        plans.append(Plan(title: "MVV Schnellbahnnetz", type: "pdf", url: "http://www.mvv-muenchen.de/fileadmin/media/Dateien/plaene/pdf/Netz_2016_Version_MVG.PDF", address: "", icon: "plan_mvv_icon"))
        plans.append(Plan(title: "MVV Nachtliniennetz", type: "pdf", url: "http://www.mvv-muenchen.de/fileadmin/media/Dateien/plaene/pdf/Nachtnetz_2016.pdf", address: "", icon: "plan_mvv_night_icon"))
        plans.append(Plan(title: "MVV Tramnetz", type: "pdf", url: "http://www.mvv-muenchen.de/fileadmin/media/Dateien/plaene/pdf/Tramnetz_2016.pdf", address: "", icon: "plan_tram_icon"))
        plans.append(Plan(title: "MVV Gesamtnetz", type: "pdf", url: "http://www.mvv-muenchen.de/fileadmin/media/Dateien/3_Tickets_Preise/dokumente/TARIFPLAN_2016-Innenraum.pdf", address: "", icon: "plan_mvv_entire_net_icon"))
        plans.append(Plan(title: "Campus Garching", type: "image", url: "plan_campus_garching", address: "Walter-Meißner-Straße 3, 85748 Garching", icon: "plan_campus_garching_icon"))
        plans.append(Plan(title: "Campus Klinikum", type: "image", url: "plan_campus_klinikum", address: "Ismaninger Straße 22, 81675 München", icon: "plan_campus_klinikum_icon"))
        plans.append(Plan(title: "Campus Olympiapark", type: "image", url: "plan_campus_olympiapark", address: "Connollystraße 32, 80809 München", icon: "plan_campus_olympiapark_icon"))
        plans.append(Plan(title: "Campus Olympiapark Hallenplan", type: "image", url: "plan_campus_olympiapark_hallenplan", address: "Connollystraße 32, 80809 München", icon: "plan_campus_olympiapark_hallenplan_icon"))
        plans.append(Plan(title: "Stammgelände", type: "image", url: "plan_campus_stammgelaende", address: "Arcisstraße 21, 80333 München", icon: "plan_campus_stammgelaende_icon"))
        plans.append(Plan(title: "Campus Weihenstephan", type: "image", url: "plan_campus_weihenstephan", address: "Liesel-Beckmann-Straße 6, 85354 Freising", icon: "plan_campus_weihenstephan_icon"))
    }
    
    func getPlans() -> [Plan]{
        return plans
    }
    
    func getPlan(forIndex index:Int) -> Plan {
        return plans[index]
    }
}
