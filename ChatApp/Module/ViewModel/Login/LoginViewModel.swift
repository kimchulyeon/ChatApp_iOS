//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import Combine
import CombineCocoa

class LoginViewModel: ViewModelType {
    //MARK: - properties
    struct Input {
        let emailPublisher: AnyPublisher<String, Never>
        let passwordPublisher: AnyPublisher<String, Never>
        let forgotPasswordTapPublisher: AnyPublisher<Void, Never>
        let registerTapPublisher: AnyPublisher<Void, Never>
        let loginTapPublisher: AnyPublisher<Void, Never>
    }
    
    //MARK: - lifecycle
    
    
    //MARK: - method
    func bind(input: Input) {
        
    }
}
