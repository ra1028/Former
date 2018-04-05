//
//  LoginViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 11/8/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class LoginViewController: UIViewController {
    
    // MARK: Public

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    class func present(viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: nil)
        let loginVC = storyboard.instantiateInitialViewController() as! LoginViewController
        viewController.present(loginVC, animated: true, completion: nil)
    }
    
    // MARK: Private
    
    private lazy var former: Former = Former(tableView: self.tableView)
    private var idRow: TextFieldRowFormer<FormTextFieldCell>?
    private var passwordRow: TextFieldRowFormer<FormTextFieldCell>?
    private var loginRow: LabelRowFormer<CenterLabelCell>?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dimmingView: UIControl!
    
    private func configure() {
        tableView.backgroundColor = .formerColor()
        tableView.layer.cornerRadius = 5
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        
        // Create RowFormers
        
        let idRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .systemFont(ofSize: 15)
            }.configure {
                $0.placeholder = "User name"
                $0.text = Login.sharedInstance.username
            }.onTextChanged { [weak self] in
                Login.sharedInstance.username = $0
                self?.switchLoginRow()
        }
        let passwordRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .systemFont(ofSize: 15)
            $0.textField.keyboardType = .decimalPad
            $0.textField.isSecureTextEntry = true
            }.configure {
                $0.placeholder = "Password"
                $0.text = Login.sharedInstance.password
            }.onTextChanged { [weak self] in
                Login.sharedInstance.password = $0
                self?.switchLoginRow()
        }
        
        let loginRow = LabelRowFormer<CenterLabelCell>()
            .configure {
                $0.text = "Login"
            }.onSelected { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
        }
        
        self.idRow = idRow
        self.passwordRow = passwordRow
        self.loginRow = loginRow
        
        switchLoginRow()
        
        // Create Headers
        
        let descriptionHeader = LabelViewFormer<FormLabelHeaderView>() {
            $0.contentView.backgroundColor = .clear
            $0.titleLabel.textColor = .white
            }.configure {
                $0.viewHeight = 80
                $0.text = "Welcome to the Former demo app\nPlease login"
        }
        let createSpaceHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>() {
                $0.contentView.backgroundColor = .clear
                }.configure {
                    $0.viewHeight = 30
            }
        }
        
        // Create SectionFormers
        
        let idSection = SectionFormer(rowFormer: idRow)
            .set(headerViewFormer: descriptionHeader)
        let passwordSection = SectionFormer(rowFormer: passwordRow)
            .set(headerViewFormer: createSpaceHeader())
        let loginSection = SectionFormer(rowFormer: loginRow)
            .set(headerViewFormer: createSpaceHeader())
        
        former.append(sectionFormer: idSection, passwordSection, loginSection)
    }
    
    private func switchLoginRow() {
        let enabled = !(idRow?.text?.isEmpty ?? true) &&
            !(passwordRow?.text?.isEmpty ?? true)
        loginRow?.enabled = enabled
    }
    
    @IBAction func tapBackground(sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator(forwardTransition: false)
    }
}

private final class FadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var forwardTransition = true
    
    init(forwardTransition: Bool = true) {
        super.init()
        self.forwardTransition = forwardTransition
    }
    
    @objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        #if swift(>=2.3)
            let containerView = transitionContext.containerView
        #else
            let containerView = transitionContext.containerView!
        #endif
        
        let duration = transitionDuration(using: transitionContext)
        
        if forwardTransition {
            containerView.addSubview(toVC.view)
            UIView.animate(withDuration: duration, delay: 0,
                usingSpringWithDamping: 1, initialSpringVelocity: 0,
                options: .beginFromCurrentState,
                animations: {
                    toVC.view.alpha = 0
                    toVC.view.alpha = 1
                }) { _ in
                    transitionContext.completeTransition(true)
            }
        } else {
            UIView.animate(withDuration: duration, delay: 0,
                usingSpringWithDamping: 1, initialSpringVelocity: 0,
                options: .beginFromCurrentState,
                animations: {
                    fromVC.view.alpha = 0
                }) { _ in
                    transitionContext.completeTransition(true)
            }
        }
    }
}
