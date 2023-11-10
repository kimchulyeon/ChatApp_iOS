//
//  LoginViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class LoginViewController: UIViewController {
    //MARK: - properties
    private let welcomeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "HEY, WELCOME"
        lb.font = ThemeFont.bold(size: 20)
        lb.tintColor = ThemeColor.text
        return lb
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "profile")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = ThemeColor.text
        tf.placeholder = "Email"
        tf.setPlaceholder(text: "Email")
        tf.backgroundColor = .white
        tf.font = ThemeFont.regular(size: 16)
        tf.keyboardType = .emailAddress
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.autocapitalizationType = .none
        tf.snp.makeConstraints { $0.height.equalTo(50) }
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = ThemeColor.text
        tf.setPlaceholder(text: "Password")
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.font = ThemeFont.regular(size: 16)
        tf.keyboardType = .default
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = ThemeFont.bold(size: 18)
        btn.backgroundColor = ThemeColor.primary
        btn.addCornerRadius(radius: 8)
        return btn
    }()
    
    private lazy var lostPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Forget your password?", for: .normal)
        btn.setTitleColor(ThemeColor.text, for: .normal)
        btn.titleLabel?.font = ThemeFont.regular(size: 14)
        btn.contentHorizontalAlignment = .left
        btn.addCornerRadius(radius: 8)
        let action = UIAction { [unowned self] _ in
            handleForgotPassword()
        }
        btn.addAction(action, for: .touchUpInside)
        return btn
    }()
    
    private lazy var registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Go to Register", for: .normal)
        btn.setTitleColor(ThemeColor.text, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = ThemeFont.regular(size: 14)
        btn.addCornerRadius(radius: 8)
        let action = UIAction { [unowned self] _ in
            handleRegister()
        }
        btn.addAction(action, for: .touchUpInside)
        return btn
    }()
    
    private lazy var hButtonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            lostPasswordButton, registerButton
        ])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            hButtonStackView,
            loginButton,
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 24
        return sv
    }()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observePublisher()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    
    
    //MARK: - method
    private func setupUI() {
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(16)
        }
        
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
    }
    
    private func observePublisher() {
        loginButton.tapPublisher
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let weakSelf = self else { return }
                
                let email = weakSelf.emailTextField.text ?? ""
                let password = weakSelf.passwordTextField.text ?? ""
                let isEmailValid = !email.isEmpty
                let isPasswordValid = !password.isEmpty
                
                if isEmailValid == false {
                    weakSelf.emailTextField.setPlaceholder(text: "Email", color: .systemRed)
                }
                
                if isPasswordValid == false {
                    weakSelf.passwordTextField.setPlaceholder(text: "Password", color: .systemRed)
                }
                
                if isEmailValid && isPasswordValid {
                    weakSelf.resetPlaceholder()
                    weakSelf.handleLogin()
                }
            }
            .store(in: &cancellables)
    }
    
    private func resetPlaceholder() {
        emailTextField.setPlaceholder(text: "Email", color: ThemeColor.text)
        passwordTextField.setPlaceholder(text: "Password", color: ThemeColor.text)
    }
    
    private func handleRegister() {
        print("REGISTER")
    }
    
    private func handleForgotPassword() {
        print("PASSWORD")
    }
    
    private func handleLogin() {
        print("LOGIN")
    }
    
}

#if DEBUG
import SwiftUI

struct MainViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        LoginViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        MainViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif

