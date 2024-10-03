import SwiftUI
import KakaoSDKUser
import Alamofire

// 서버 응답에 맞는 구조체 정의
struct LoginResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: LoginData?
}

struct LoginData: Codable {
    let role: String
    let tokens: Token
}

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel // 전역 ViewModel
    @Environment(\.presentationMode) var presentationMode // 현재 View의 PresentationMode를 가져옴
    
    var body: some View {
        VStack {
            Button {
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                        if let token = oauthToken {
                            print("OAuthToken: \(token.accessToken)")
                            // 로그인 성공 후 API 호출
                            sendAccessTokenToServer(accessToken: token.accessToken)
                        } else if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                        if let token = oauthToken {
                            print("OAuthToken: \(token.accessToken)")
                            // 로그인 성공 후 API 호출
                            sendAccessTokenToServer(accessToken: token.accessToken)
                        } else if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            } label: {
                Image("KakaoLogin") // 카카오 로그인 이미지 버튼
            }
        }
        .padding()
        .navigationTitle("Login")
    }
    
    // POST 요청을 Alamofire를 사용하여 보내는 함수
    func sendAccessTokenToServer(accessToken: String) {
        let url = "https://zerocommission.o-r.kr/api/v1/member/login"
        
        // 요청에 사용할 JSON 데이터
        let parameters: [String: String] = [
            "accessToken": accessToken
        ]
        
        // Alamofire로 POST 요청 (responseDecodable 사용)
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    // 서버 응답 처리
                    print("Response: \(loginResponse)")
                    
                    if loginResponse.status == 200 && loginResponse.success {
                        print("\(loginResponse.message)")
//                        if let tokens = loginResponse.data?.tokens {
//                            print("Access Token: \(tokens.accessToken)")
//                            print("Refresh Token: \(tokens.refreshToken)")
//                        }
                        if let role = loginResponse.data?.role {
                            // 로그인 성공 후 role 값을 ViewModel에 저장
                            DispatchQueue.main.async {
                                userViewModel.role = role
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } else {
                        print("\(loginResponse.message)")
                    }
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

#Preview {
    LoginView()
}
