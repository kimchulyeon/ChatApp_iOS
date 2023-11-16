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
import AuthenticationServices

class LoginViewController: UIViewController {
    //MARK: - properties
    private let welcomeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "환영합니다"
        lb.font = ThemeFont.bold(size: 20)
        lb.tintColor = ThemeColor.text
        return lb
    }()

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "chat_logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = ThemeColor.text
        tf.setPlaceholder(text: "이메일")
        tf.backgroundColor = .white
        tf.font = ThemeFont.regular(size: 16)
        tf.keyboardType = .emailAddress
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .whileEditing
        tf.snp.makeConstraints { $0.height.equalTo(50) }
        return tf
    }()

    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = ThemeColor.text
        tf.setPlaceholder(text: "비밀번호")
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.font = ThemeFont.regular(size: 16)
        tf.keyboardType = .default
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("로그인", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = ThemeFont.bold(size: 18)
        btn.backgroundColor = ThemeColor.secondary
        btn.addCornerRadius(radius: 8)
        return btn
    }()

    private lazy var lostPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("비밀번호를 잃어버렸나요?", for: .normal)
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
        btn.setTitle("가입하러가기", for: .normal)
        btn.setTitleColor(ThemeColor.primary, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = ThemeFont.demiBold(size: 14)
        btn.addCornerRadius(radius: 8)
        let action = UIAction { [unowned self] _ in
            handleRegister()
        }
        btn.addAction(action, for: .touchUpInside)
        return btn
    }()

    private lazy var hButtonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [lostPasswordButton, registerButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()

    private lazy var dividerView = DividerView()

    private let appleButton: ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let googleButton = GoogleButton()

    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            hButtonStackView,
            loginButton,
            dividerView,
            appleButton,
            googleButton
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 12
        return sv
    }()
    
    lazy var loadingSpinner: JGProgressHUD = {
        let loader = JGProgressHUD(style: .dark)
        loader.textLabel.text = "Loading"
        return loader
    }()


    private var cancellables = Set<AnyCancellable>()
    private let viewModel: LoginViewModel



    //MARK: - lifecycle
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        view.endEditing(true)
    }



    //MARK: - method
    private func setupUI() {
        view.addSubview(welcomeLabel)
        welcomeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }

        view.addSubview(logoImageView)
        logoImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        logoImageView.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(150)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(16)
        }

        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(30)
            make.bottom.lessThanOrEqualTo(view.snp.bottomMargin).offset(-24)
        }
    }

    private func bind() {
        bindLoadingState()
        bindTextFields()
        bindLoginButtonAction()
    }

    private func handleRegister() {
        let registVM = RegisterViewModel()
        let registerVC = RegisterViewController(viewModel: registVM)
        navigationController?.pushViewController(registerVC, animated: true)
    }

    private func handleForgotPassword() {
        print("PASSWORD")
    }
    
    private func resetPlaceholder() {
        emailTextField.setPlaceholder(text: "이메일", color: ThemeColor.text)
        passwordTextField.setPlaceholder(text: "비밀번호", color: ThemeColor.text)
    }
    
    private func setErrorPlaceholder() {
        emailTextField.setPlaceholder(text: "이메일을 입력해주세요", color: .systemRed)
        passwordTextField.setPlaceholder(text: "비밀번호를 입력해주세요", color: .systemRed)
    }
    
    private func bindLoadingState() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let weakSelf = self else { return }
                if isLoading {
                    weakSelf.loadingSpinner.show(in: weakSelf.view, animated: true)
                } else {
                    weakSelf.loadingSpinner.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindTextFields() {
        emailTextField.textPublisher.compactMap { $0 }.assign(to: \.email, on: viewModel).store(in: &cancellables)
        passwordTextField.textPublisher.compactMap { $0 }.assign(to: \.password, on: viewModel).store(in: &cancellables)
    }

    private func bindLoginButtonAction() {
        loginButton.tapPublisher
            .coolDown(for: .seconds(3), scheduler: DispatchQueue.main)
            .flatMap { [unowned self] _ in
                return viewModel.handleLogin()
            }
            .sink { [weak self] result in
                switch result {
                case .success:
                    print("성공 >>>> ")
                    let vc = UIViewController()
                    CommonUtil.ch
                    
                case .failure(error: let error):
                    print("실패 >>>> ")
                    if error == .textFieldEmpty {
                        self?.setErrorPlaceholder()
                    }
                    self?.view.showAlert(content: "로그인에 실패하였습니다")

                }
            }
            .store(in: &cancellables)
    }
}




#if DEBUG
    import SwiftUI
import JGProgressHUD

    struct MainViewControllerPresentable: UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
        func makeUIViewController(context: Context) -> some UIViewController {
            LoginViewController(viewModel: LoginViewModel())
        }
    }

    struct ViewControllerPrepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            MainViewControllerPresentable()
                .ignoresSafeArea()
        }
    }

#endif

