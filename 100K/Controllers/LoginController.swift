//
//  LoginController.swift
//  100K
//
//  Created by TXB4 on 18/01/2021.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
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
        button.backgroundColor = UIColor(red: 0.42, green: 0.38, blue: 1.00, alpha: 1.00)
        button.setTitleColor(UIColor(white: 1, alpha: 1),for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(authenticateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        configureUI()
    }
    
    // MARK: - Authentication
    
    
    
    // MARK: - UI

    func configureUI() {
        view.backgroundColor = .systemGray6
        view.addSubview(authenticateButton)
        view.addSubview(loginImage)
        loginImage.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 200)
//        authenticateButton.centerX(inView: view, topAnchor: loginImage.bottomAnchor, paddingTop: 70)
        authenticateButton.anchor(top:loginImage.bottomAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor,paddingTop: 120,paddingLeft: 40,paddingRight: 40)
        
    }
    
    
    // MARK: - Selectors
    
    
    @objc func authenticateButtonPressed() {
        print("DEBUG: authenticateButtonPressed")
    }

}
