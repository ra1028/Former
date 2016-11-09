//
//  FomerViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormViewController: UIViewController {
    
    // MARK: Public
    
    public let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.contentInset.bottom = 10
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    public private(set) lazy var former: Former = Former(tableView: self.tableView)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Private
    
    private final func setup() {
        view.backgroundColor = .groupTableViewBackground
        view.insertSubview(tableView, at: 0)
        let tableConstraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[table]-0-|",
                options: [],
                metrics: nil,
                views: ["table": tableView]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[table]-0-|",
                options: [],
                metrics: nil,
                views: ["table": tableView]
            )
            ].flatMap { $0 }
        view.addConstraints(tableConstraints)
    }
}
