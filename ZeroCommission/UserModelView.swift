import SwiftUI

class UserViewModel: ObservableObject {
    @Published var role: String? // role 값을 저장
    
    init(role: String? = nil) {
        self.role = role
    }
    
    // 로그아웃 함수: role 값을 초기화
    func logout() {
        self.role = nil
    }
}
