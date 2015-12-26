//
//  UserData.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Contacts
import UIKit
class UserData: ImageDownloader, DataElement {
    
    func getCellIdentifier() -> String {
        return "person"
    }
    
    let name: String
    let picture: String
    let id: String
    init(name: String, picture: String, id: String) {
        self.name = name
        self.id = id
        self.picture = (TUMOnlineWebServices.Home.rawValue + picture).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())?.stringByReplacingOccurrencesOfString("amp;", withString: "") ?? ""
        super.init(url: self.picture)
    }
    
    var title: String?
    
    var contactInfo = [(ContactInfoType,String)]()
    
    var text: String {
        return name
    }
    
    var contactsLoaded: Bool {
        get {
            return !contactInfo.isEmpty || title != nil
        }
    }
    
    func addContact(handler: () -> ()?) {
        let contact = CNMutableContact()
        if let imageOfUser = image {
            contact.imageData = UIImagePNGRepresentation(imageOfUser)
        }
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
        contact.emailAddresses = emails.map() { (item) in
            return CNLabeledValue(label:CNLabelWork, value: item)
        }
        contact.phoneNumbers = phones.map() { (item) in
            let number = CNPhoneNumber(stringValue: item)
            return CNLabeledValue(label:CNLabelPhoneNumberMain, value: number)
        }
        contact.phoneNumbers.appendContentsOf(mobiles.map() { (item) in
            let number = CNPhoneNumber(stringValue: item)
            return CNLabeledValue(label:CNLabelPhoneNumberMobile, value: number)
        })
        contact.urlAddresses = websites.map() { (item) in
            return CNLabeledValue(label:CNLabelURLAddressHomePage, value:item)
        }
        contact.organizationName = "Technische Universität München"
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.addContact(contact, toContainerWithIdentifier:nil)
        do {
            try store.executeSaveRequest(saveRequest)
            handler()
        } catch {
            print("Error")
        }
        
    }
    
}