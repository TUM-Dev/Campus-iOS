//
//  AddToContactsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.02.22.
//

import Foundation
import SwiftUI
import ContactsUI

struct AddToContactsView: UIViewControllerRepresentable {
    class Coordinator: NSObject, CNContactViewControllerDelegate, UINavigationControllerDelegate {
        private func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNMutableContact?) {
            if let c = contact {
                self.parent.contact = c
            }

            viewController.dismiss(animated: true)
        }

        var parent: AddToContactsView

        init(_ parent: AddToContactsView) {
            self.parent = parent
        }
    }

    @State var contact: CNMutableContact

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<AddToContactsView>) -> CNContactViewController {
        guard self.contact.identifier.count != 0 else {
            let vc = CNContactViewController(forNewContact: CNContact())
            vc.delegate = context.coordinator
            return vc
        }
            
        let vc = CNContactViewController(forNewContact: contact)
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: CNContactViewController, context: UIViewControllerRepresentableContext<AddToContactsView>) {

    }
}
