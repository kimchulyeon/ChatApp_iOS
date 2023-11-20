# Combine + MVVM + Chat Project

<br/>

## 구성

- 스토리보드 없이 UIKit codeUI로 작업 (SnapKit 사용)
- 오토레이아웃을 통해 SE 기기부터 MAX 시리즈까지 레이아웃에 문제가 없도록 구현
- Combine + MVVM 패턴으로 작업
- 파이어베이스 사용 (+ 애플로그인 / 구글로그인)

<br/>

## 이메일 회원가입 기능

- 파이어베이스 회원가입 : Credential 반환 
- 반환된 authResult 데이터들을 파이어베이스 DB에 저장 (DB Document명을 userID로 설정)

<br/>

## 이메일 로그인 기능

- 파이어베이스에서 자체적으로 가입한 이메일인지 체크
- 반환된 authResult 데이터에서 userID로 파이어베이스 DB에서 해당하는 사용자 데이터 가져오기
- 최소한의 필수 데이터를 UserDefaults에 저장함으로써 로그인 

<br/>


## 애플 / 구글 회원가입 + 로그인
- 애플 / 구글 Auth 진행 : Credential 반환
- 애플 / 구글 로그인은 자체적으로 기존 유저인지 체크 X
- 기존 가입 유저인지 체크를 위해 반환된 Credential의 userID로 파이어베이스 DB에 저장되어 있는지 체크
- 저장되어 있다면 해당 DB 데이터를 가져와서 UserDefaults에 저장하여 로그인
- DB에 저장되지 않은 userID이면 신규 유저이므로 파이어베이스 DB에 해당 사용자 정보를 저장하여 회원가입
- DB에 저장 후 최소한의 필수 데이터를 UserDefaults에 저장하여 로그인

<br/>

### ✅ 로그인 / 회원가입 로직, 책임 분리
> 파이어베이스 Auth 모듈 | 

> Apple Auth 모듈 | 

> Google Auth 모듈 | 

> 파이어베이스 DB 모듈 | 

> UserDefaults 모듈 | 

분리하여 모듈끼리 의존하지 않게 작업하고 뷰모델에서 플로우대로 각 모듈을 사용

<br/>

## Combine  (feat. CombineCocoa)

> 뷰컨트롤러에서는 뷰모델에 정의된 퍼블리셔와 바인딩을 해주고 비즈니스 로직은 뷰모델에서 처리하게끔 작업

**UITextField의 입력값 바인딩**
> CombineCocoa의 textPublisher로 뷰모델의 email 퍼블리셔에 assign(to:on:)으로 할당
```
emailTextField.textPublisher.compactMap { $0 }.assign(to: \.email, on: viewModel).store(in: &cancellables)
```

<br/>

**로그인 버튼 탭 바인딩**

[ 뷰컨트롤러 ]
> CombineCocoa의 tapPublisher로 탭 이벤트를 받으면 뷰모델의 loginButtonTapSubject인 PassthroughSubject에 Void를 전달

```
loginButton.tapPublisher.sink { [unowned self] _ in viewModel.loginButtonTapSubject.send() }.store(in &cancellables)

viewModel.loginResultPublisher
  .sink { [weak self] result in 
    switch result {
      case .success:
        ...로그인 성공 시 UI 작업
      case .failure(error: let error):
        ... 로그인 실패 시 UI 작업
    }
  }
  .store(in: &cancellables)
```

[ 뷰모델 ]
> 뷰컨트롤러 탭 이벤트를 통해 loginButtonTapSubject에 Void가 전달되면

> loginResultPublisher가 loginButtonTapSubject를 구독하고 있어서 탭 이벤트가 되면

> 또 다른 퍼블리셔를 반환하는 뷰모델의 handleLogin() 메소드를 호출

> 반환된 handleLogin() 메소드의 결과인 퍼블리셔를 통해 뷰컨트롤러에서 UI 작업 
```
let loginButtonTapSubject = PassthroughSubject<Void, Never>()
var loginResultPublisher: AnyPublisher<Void, Never> {
  loginButtonTapSubject
  .coolDown(for: .seconds(3), scheduler: DispatchQueue.main)
  .flatMap { [unowned self] _ in handleLogin() }
  .eraseToAnyPublisher()
}
```

<br/>

**파이어베이스 로그인 + Combine**

> AnyPublisher<로그인데이터, Error>를 반환

```
func login(email: String, password: String) -> AnyPublisher<AuthDataResult?, Error> {
   return Future<AuthDataResult?, Error> { promise in
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("🔴 Login Error >>>> \(error.localizedDescription)")
                return promise(.failure(error))
            }
                
            return promise(.success(authResult))
       }
   }
   .eraseToAnyPublisher()
}
```


