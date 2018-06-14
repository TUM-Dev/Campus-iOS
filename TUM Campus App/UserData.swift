//
//  UserData.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
    
    init(name: String, picture: String?, id: String, maxCache: CacheTime) {
        self.name = name
        self.id = id
        self.avatar = .init(url: picture, maxCache: maxCache)
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
    
    func addContact(_ handler: (() -> ())?) {
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
        
        avatar.fetch().onResult(in: .main) { result in
            contact.imageData = result.value?
                .flatMap { $0 }
                .flatMap { UIImagePNGRepresentation($0) }
            
            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier:nil)
            do {
                try store.execute(saveRequest)
                handler?()
            } catch {
                print("Error")
            }
        }
    }
    
}

extension UserData: XMLDeserializable {
    
    convenience init?(from xml: XMLIndexer, api: TUMOnlineAPI, maxCache: CacheTime) {
        guard let name = xml["vorname"].element?.text,
            let lastname = xml["familienname"].element?.text,
            let id = xml["obfuscated_id"].element?.text else {
            
            return nil
        }
        
        let key = CurrentAccountType.value.key
        let path = ["obfuscated_ids", key]
        
        let url = xml.get(at: path)?.element?.text.imageURL(in: api) ??
            xml["bild_url"].element.map { "\(api.baseURL)/\($0.text)" }
        
        self.init(name: "\(name) \(lastname)", picture: url, id: id, maxCache: maxCache)
    }
    
}

fileprivate extension String {
    
    func imageURL(in api: TUMOnlineAPI) -> String? {
        
        let split = self.components(separatedBy: "*")
        guard split.count == 2 else { return nil }
        
        return api.base
            .appendingPathComponent("visitenkarte.showImage")
            .appendingQuery(key: "pPersonenGruppe", value: split[0])
            .appendingQuery(key: "pPersonenId", value: split[1])
            .absoluteString
    }
    
}
