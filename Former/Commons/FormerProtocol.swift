//
//  FormerProtocols.swift
//  Former
//
//  Created by Ryo Aoyama on 10/22/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

// MARK: Inline RowFormer

public protocol InlineForm: class {
    
    var inlineRowFormer: RowFormer { get }
    func editingDidBegin()
    func editingDidEnd()
}

public protocol ConfigurableInlineForm: class, InlineForm {
    
    associatedtype InlineCellType: UITableViewCell
}

extension ConfigurableInlineForm where Self: RowFormer {
    
    public func inlineCellSetup(handler: (InlineCellType -> Void)) -> Self {
        inlineRowFormer.cellSetup { handler($0 as! InlineCellType) }
        return self
    }
    
    public final func inlineCellUpdate(@noescape update: (InlineCellType -> Void)) -> Self {
        update(inlineRowFormer.cellInstance as! InlineCellType)
        return self
    }
}

// MARK: Selector RowFormer

public protocol SelectorForm: class {
    
    func editingDidBegin()
    func editingDidEnd()
}

public protocol UpdatableSelectorForm: class, SelectorForm {
    
    associatedtype SelectorViewType: UIView
    var selectorView: SelectorViewType { get }
}

extension UpdatableSelectorForm where Self: RowFormer {
    
    public func selectorViewUpdate(@noescape update: (SelectorViewType -> Void)) -> Self {
        update(selectorView)
        return self
    }
}

// MARK: RowFormer

public protocol Formable: class, SelectableForm, UpdatableForm, ConfigurableForm {}

public protocol SelectableForm: class {}

public extension SelectableForm where Self: RowFormer {
    
    func onSelected(handler: (Self -> Void)) -> Self {
        onSelected = {
            handler($0 as! Self)
        }
        return self
    }
}

public protocol UpdatableForm: class {}

public extension UpdatableForm where Self: RowFormer {
    
    func update(@noescape handler: (Self -> Void)) -> Self {
        handler(self)
        update()
        return self
    }
    
    func onUpdate(handler: (Self -> Void)) -> Self {
        onUpdate = {
            handler($0 as! Self)
        }
        return self
    }
}

public protocol ConfigurableForm: class {}

public extension ConfigurableForm where Self: RowFormer {
    
    func configure(@noescape handler: (Self -> Void)) -> Self {
        handler(self)
        return self
    }
}

public extension ConfigurableForm where Self: ViewFormer {
    
    func configure(@noescape handler: (Self -> Void)) -> Self {
        handler(self)
        return self
    }
}