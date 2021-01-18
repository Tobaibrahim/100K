//
//  LoginController.swift
//  100K
//
//  Created by TXB4 on 18/01/2021.
//

import UIKit
import LocalAuthentication


class LoginController: UIViewController {
    
    // MARK: - Properties
    
    
    var context  = LAContext()

    let loginImage: UIImageView = {
       let image = UIImageView()
        image.setDimensions(width: 217, height: 130)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "undraw_Fingerprint_re_uf3f")
        return image
    }()
    
    
    let authenticateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Authenticate", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 17
        button.backgroundColor = .appPurple
        button.setTitleColor(UIColor(white: 1, alpha: 1),for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(authenticateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    
    
    
    var state = AuthenticationState.loggedout {

        // Update the UI on a change.
        didSet {
            
            authenticateButton.isHighlighted = state == .loggedin  // The button text changes on highlight.
            if state == .loggedin {
                configureViewControllers()
            }
        }
    }
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        configureUI()
    }
    
    // MARK: - ConfigureVCS
    
    func configureViewControllers() {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
        guard let tab = window.rootViewController as? MainNavigationController else {return}
        tab.configureViewControllers()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UI

    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
        view.backgroundColor = .systemGray6
        view.addSubview(authenticateButton)
        view.addSubview(loginImage)
        loginImage.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 240)
//        authenticateButton.centerX(inView: view, topAnchor: loginImage.bottomAnchor, paddingTop: 70)
        authenticateButton.anchor(top:loginImage.bottomAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor,paddingTop: 120,paddingLeft: 40,paddingRight: 40)
        
    }
    
    
    // MARK: - Selectors
    
    
    @objc func authenticateButtonPressed() {
        print("DEBUG: authenticateButtonPressed")
        
        
        
        if state == .loggedin {

            // Log out immediately.
            state = .loggedout

        } else {

            // Get a fresh context for each login. If you use the same context on multiple attempts
            //  (by commenting out the next line), then a previously successful authentication
            //  causes the next policy evaluation to succeed without testing biometry again.
            //  That's usually not what you want.
            context = LAContext()

            context.localizedCancelTitle = "Enter Passcode"

            // First check if we have the needed hardware support.
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                    if success {

                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                        }

                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")

                        // Fall back to a asking for username and password.
                        // ...
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")

                // Fall back to a asking for username and password.
                // ...
            }
        }
    
    }

}
