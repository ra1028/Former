//
//  LabelViewFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol LabelFormableView: FormableView {
    
    func formTitleLabel() -> UILabel
}

public final class LabelViewFormer<T: UITableViewHeaderFooterView where T: LabelFormableView>: BaseViewFormer<T> {
    
    // MARK: Public
    
    public var text: String?
    
    required public init(instantiateType: Former.InstantiateType = .Class, viewSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, viewSetup: viewSetup)
    }
    
    public override func initialized() {
        super.initialized()
        viewHeight = 30
    }
    
    public override func update() {
        super.update()
        view.formTitleLabel().text = text
    }
}