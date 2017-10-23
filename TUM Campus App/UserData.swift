//
//  UserData.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import Contacts
import UIKit
import SWXMLHash

final class UserData: DataElement {
    
    func getCellIdentifier() -> String {
        return "person"
    }
    
    let name: String
    let id: String
    let avatar: Image
    
    init(name: String, picture: String?, id: String) {
        self.name = name
        self.id = id
        self.avatar = .init(url: picture)
    }
    
    var title: String?
    
    var contactInfo = [(ContactInfoType, String)]()
    
    var text: String {
        return name
    }
    
    var contactsLoaded: Bool {
        get {
            return !contactInfo.isEmpty || title != nil
        }
    }
    
    typealias LabeledValueInit<V: NSCopying & NSSecureCoding> = (V) -> CNLabeledValue<V>
    
    private func getLabeledFunc<V>(label: String) -> LabeledValueInit<V> {
        return { value in
            CNLabeledValue(label: label, value: value)
        }
    }
    
    func getPhoneNumbers(_ phones: [String]) -> [CNLabeledValue<CNPhoneNumber>] {
        return phones => CNPhoneNumber.init >>> getLabeledFunc(label: CNLabelPhoneNumberMain)
    }
    
    func addContact(_ handler: () -> ()?) {
        let contact = CNMutableContact()
        contact.givenName = name
        var phones = [String]()
        var mobiles = [String]()
        var emails = [String]()
        var websites = [String]()
        var fax = [String]()
        for item in contactInfo {
            switch item.0 {
            case .Email: emails.append(item.1)
            case .Fax: fax.append(item.1)
            case .Mobile: mobiles.append(item.1)
            case .Phone: phones.append(item.1)
            case .Web: websites.append(item.1)
            }
        }
        
        contact.emailAddresses = emails => { $0 as NSString } >>> getLabeledFunc(label: CNLabelWork)
        contact.phoneNumbers = getPhoneNumbers(phones)
        
        contact.phoneNumbers.append(contentsOf: getPhoneNumbers(mobiles))
        contact.urlAddresses = websites => { $0 as NSString } >>> getLabeledFunc(label: CNLabelURLAddressHomePage)
            
        contact.organizationName = "Technische Universität München"
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        do {
            try store.execute(saveRequest)
            handler()
        } catch {
            print("Error")
        }
        
    }
    
}

extension UserData {
    
    convenience init?(from xml: XMLIndexer, api: TUMOnlineAPI) {
        guard let name = xml["vorname"].element?.text,
            let lastname = xml["familienname"].element?.text,
            let id = xml["obfuscated_id"].element?.text else {
            
            return nil
        }
        let url = xml["bild_url"].element.map { "\(api.baseURL)/\($0.text)" }
        self.init(name: "\(name) \(lastname)", picture: url, id: id)
    }
    
}
