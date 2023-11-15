//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import PhotosUI
import SnapKit
import Combine
import CombineCocoa

class RegisterViewController: UIViewController {
    //MARK: - properties
    private lazy var addImageButton: UIButton = {
        let btn = UIButton()
        let action = UIAction { [unowned self] _ in handleAddImageButton() }
        btn.addAction(action, for: .touchUpInside)
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.addCornerRadius(radius: 30)
        return btn
    }()
    
    private lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = ThemeColor.text
        tf.setPlaceholder(text: "이름")
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
    
    private lazy var checkPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = ThemeColor.text
        tf.setPlaceholder(text: "비밀번호 확인")
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.font = ThemeFont.regular(size: 16)
        tf.keyboardType = .default
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    private lazy var registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("회원가입", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = ThemeFont.bold(size: 18)
        btn.backgroundColor = ThemeColor.secondary
        btn.addCornerRadius(radius: 8)
        return btn
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            usernameTextField,
            emailTextField,
            passwordTextField,
            checkPasswordTextField,
            registerButton,
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 12
        return sv
    }()
    
    private lazy var termsTextView: TermsTextView = {
        let tv = TermsTextView()
        tv.delegate = self
        return tv
    }()

    private let viewModel: RegisterViewModel
    private var cancellables = Set<AnyCancellable>()
    



    //MARK: - lifecycle
    init(viewModel: RegisterViewModel) {
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
        view.backgroundColor = ThemeColor.bg
        
        view.addSubview(addImageButton)
        addImageButton.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        addImageButton.snp.makeConstraints { make in
            make.height.equalTo(addImageButton.snp.width)
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(vStackView)
        vStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        vStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        vStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(addImageButton.snp.bottom).offset(16)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(30)
        }

        view.addSubview(termsTextView)
        termsTextView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        termsTextView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.centerX.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(16)
            make.top.greaterThanOrEqualTo(vStackView.snp.bottom).offset(16)
        }
    }
    
    private func bind() {
        viewModel.$image
            .filter { $0 != nil }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.addImageButton.setImage(image, for: .normal)
                self?.addImageButton.addCornerRadius(radius: 30)
            }
            .store(in: &cancellables)
        
        usernameTextField.textPublisher.compactMap { $0 }.assign(to: \.name, on: viewModel).store(in: &cancellables)
        emailTextField.textPublisher.compactMap { $0 }.assign(to: \.email, on: viewModel).store(in: &cancellables)
        passwordTextField.textPublisher.compactMap { $0 }.assign(to: \.password, on: viewModel).store(in: &cancellables)
        checkPasswordTextField.textPublisher.compactMap { $0 }.assign(to: \.passwordCheck, on: viewModel).store(in: &cancellables)
        
        registerButton.tapPublisher
            .coolDown(for: .seconds(3), scheduler: DispatchQueue.main)
            .flatMap { [unowned self] _ in
                viewModel.handleRegister()
            }
            .sink { [weak self] result in
                switch result {
                case .success:
                    print("회원 가입 성공 >>>> ")
                case .failure(error: let error):
                    print("회원 가입 실패 >>>> with \(error)")
                    switch error {
                    case .unknown:
                        break
                    case .textFieldEmpty:
                        self?.setErrorPlaceholder()
                    case .passwordDiff:
                        print("입력한 비밀번호가 다릅니다")
                    }
                }
            }
            .store(in: &cancellables)
            
    }
    
    private func handleAddImageButton() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func setErrorPlaceholder() {
        usernameTextField.setPlaceholder(text: "이름을 입력해주세요", color: .systemRed)
        emailTextField.setPlaceholder(text: "이메일을 입력해주세요", color: .systemRed)
        passwordTextField.setPlaceholder(text: "비밀번호를 입력해주세요", color: .systemRed)
        checkPasswordTextField.setPlaceholder(text: "비밀번호를 입력해주세요", color: .systemRed)
    }
}





//MARK: - UITextViewDelegate
extension RegisterViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "termsOfService" {
            print("이용약관")
        } else if URL.absoluteString == "privacyPolicy" {
            print("개인정보처리약관")
        }
        return false
    }
}




//MARK: - PHPickerViewControllerDelegate
extension RegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        Just(results).assign(to: \.pickerResults, on: viewModel).store(in: &cancellables)
        dismiss(animated: true)
    }
}
