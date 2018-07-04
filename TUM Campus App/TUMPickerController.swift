//
//  TUMPickerController.swift
//  Campus
//
//  Created by Tim Gymnich on 28.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

protocol TUMPickerControllerDelegateProtocol: class {
    func didSelectOption(_ element: DataElement)
}

protocol TUMPickerControllerDelegate: TUMPickerControllerDelegateProtocol {
    associatedtype Element: DataElement
    func didSelect(element: Element)
}

extension TUMPickerControllerDelegate {
    
    func didSelectOption(_ element: DataElement) {
        guard let element = element as? Element else { return }
        didSelect(element: element)
    }
    
}

class TUMPickerController<Element: DataElement>: UIAlertController {
    
    weak var delegate: TUMPickerControllerDelegateProtocol?
    
    let elements: [Element]
    
    init(elements: [Element], selectedIndex: Int? = nil, delegate: TUMPickerControllerDelegateProtocol? = nil) {
        self.delegate = delegate
        self.elements = elements
        super.init(nibName: nil, bundle: nil)
        let actions = elements.enumerated().map { $0.element.action(for: self,
                                                                    isSelected: $0.offset == selectedIndex) }
        actions.forEach(addAction)
        addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func handle(selection element: Element) {
        delegate?.didSelectOption(element)
    }
    
}

extension TUMPickerController where Element: AnyObject {
    
    convenience init(elements: [Element], selected: Element?, delegate: TUMPickerControllerDelegateProtocol? = nil) {
        
        self.init(elements: elements,
                  selectedIndex: elements.index { $0 === selected },
                  delegate: delegate)
    }
    
}

fileprivate extension DataElement {
    
    func action(for picker: TUMPickerController<Self>, isSelected: Bool = false) -> UIAlertAction {
        let action = UIAlertAction(title: text, style: .default ) { [weak picker] _ in
            picker?.handle(selection: self)
        }
        action.setValue(isSelected, forKey: "checked")
        return action
    }
    
}
