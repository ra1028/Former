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

public protocol ConfigurableInlineForm: InlineForm {
    
    typealias InlineCellType: UITableViewCell
    func inlineCellSetup(handler: (InlineCellType -> Void)) -> Self
    func inlineCellUpdate(@noescape update: (InlineCellType -> Void)) -> Self
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

public protocol UpdatableSelectorForm: SelectorForm {
    
    typealias SelectorViewType: UIView
    var selectorView: SelectorViewType { get }
    func selectorViewUpdate(@noescape update: (SelectorViewType -> Void)) -> Self
}

extension UpdatableSelectorForm where Self: RowFormer {
    
    public func selectorViewUpdate(@noescape update: (SelectorViewType -> Void)) -> Self {
        update(selectorView)
        return self
    }
}

// MARK: RowFormer

public protocol ConfigurableForm: class {
    
    func configure(@noescape handler: (Self -> Void)) -> Self
}

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