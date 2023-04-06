//
//  StudyRoomApiResponse.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation

struct StudyRoomApiRespose: Decodable, Equatable {
    static func == (lhs: StudyRoomApiRespose, rhs: StudyRoomApiRespose) -> Bool {
        lhs.groups?.map({$0.id}) == rhs.groups?.map({$0.id}) &&
        lhs.rooms?.map({$0.id}) == rhs.rooms?.map({$0.id})
    }
    
    var rooms: [StudyRoom]?
    var groups: [StudyRoomGroup]?
    
    enum CodingKeys: String, CodingKey {
        case rooms = "raeume"
        case groups = "gruppen"
    }
    
    init() {
        self.rooms = nil
        self.groups = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rooms = try container.decode([StudyRoom].self, forKey: .rooms)
        let groups = try container.decode([StudyRoomGroup].self, forKey: .groups)
        
        self.rooms = rooms
        self.groups = groups
    }
    
    init(rooms: [StudyRoom]?, groups: [StudyRoomGroup]?) {
        self.rooms = rooms
        self.groups = groups
    }
}

extension StudyRoomApiRespose {
    private static let json = """
    {
        "raeume":[
            {"raum_nr":49770,"raum_code":"01.03.010","raum_nummer":"010","raum_nr_architekt":"01.03.010@5603","belegung_bis":"","belegung_fuer":0,"belegung_ab":"","belegung_in":0,"belegung_durch":"","raum_name":"Windfang","gebaeude_nr":832,"gebaeude_code":"5603","gebaeude_name":"FMI/ Bibliothek","status":"frei","res_nr":27052,"attribute":[]},
            {"raum_nr":58380,"raum_code":"01.03.043B","raum_nummer":"043B","raum_nr_architekt":"01.03.043B@5603","belegung_bis":"","belegung_fuer":0,"belegung_ab":"","belegung_in":0,"belegung_durch":"","raum_name":"Einzelarbeitsraum","gebaeude_nr":832,"gebaeude_code":"5603","gebaeude_name":"FMI/ Bibliothek","status":"frei","res_nr":26714,"attribute":[]}
        ],
        "gruppen":[
            {"nr":46,"sortierung":1,"name":"Fachschaftsräume Mathe/Informatik","detail":"","raeume":[49770,58380,58372,58363,58354,58346,58227,58217,58211,58203,58195,58187,58068,58059,58050,58041],"regionen":["gar_f"]}
        ]
    }
    """
    
    static let jsonData = json.data(using: .utf8)!
    static let previewData: StudyRoomApiRespose = try! JSONDecoder().decode(StudyRoomApiRespose.self, from: jsonData)
}

/*
 {"nr":46,"sortierung":1,"name":"Fachschaftsr\u00e4ume Mathe\/Informatik","detail":"","raeume":[49770,58380,58372,58363,58354,58346,58227,58217,58211,58203,58195,58187,58068,58059,58050,58041],"regionen":["gar_f"]}
 */

/*
 {"raum_nr":49770,"raum_code":"01.03.010","raum_nummer":"010","raum_nr_architekt":"01.03.010@5603","belegung_bis":"","belegung_fuer":0,"belegung_ab":"","belegung_in":0,"belegung_durch":"","raum_name":"Windfang","gebaeude_nr":832,"gebaeude_code":"5603","gebaeude_name":"FMI\/ Bibliothek","status":"frei","res_nr":27052,"attribute":[]},
 "raum_nr":58380,"raum_code":"01.03.043B","raum_nummer":"043B","raum_nr_architekt":"01.03.043B@5603","belegung_bis":"","belegung_fuer":0,"belegung_ab":"","belegung_in":0,"belegung_durch":"","raum_name":"Einzelarbeitsraum","gebaeude_nr":832,"gebaeude_code":"5603","gebaeude_name":"FMI\/ Bibliothek","status":"frei","res_nr":26714,"attribute":[]}
 */
