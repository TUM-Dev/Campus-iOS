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


class UserData: ImageDownloader, DataElement {
    
    func getCellIdentifier() -> String {
        return "person"
    }
    
    func getCloseCellHeight() -> CGFloat {
        return 112
    }
    
    func getOpenCellHeight() -> CGFloat {
        return 412
    }
    
    let name: String
    let picture: String
    let id: String
    init(name: String, picture: String, id: String) {
        self.name = name
        self.id = id
        self.picture = (TUMOnlineWebServices.Home.rawValue + picture).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)?.replacingOccurrences(of: "amp;", with: "") ?? ""
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
    
    typealias LabeledValueInit<V: NSCopying & NSSecureCoding> = (V) -> CNLabeledValue<V>
    
    private func getLabeledFunc<V>(label: String) -> LabeledValueInit<V> {
        return { value in
            CNLabeledValue(label: label, value: value)
        }
    }
    
    func getPhoneNumbers(_ phones: [String]) -> [CNLabeledValue<CNPhoneNumber>] {
        return phones => firstArgument
            >>> CNPhoneNumber.init
            >>> getLabeledFunc(label: CNLabelPhoneNumberMain)
    }
    
    func addContact(_ handler: () -> ()?) {
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
        
        contact.emailAddresses = emails => { $0.0 as NSString } >>> getLabeledFunc(label: CNLabelWork)
        contact.phoneNumbers = getPhoneNumbers(phones)
        
        contact.phoneNumbers.append(contentsOf: getPhoneNumbers(mobiles))
        contact.urlAddresses = websites => { $0.0 as NSString } >>> getLabeledFunc(label: CNLabelURLAddressHomePage)
            
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
