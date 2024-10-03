import SwiftUI
// iOS SDK
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct ZeroCommissionApp: App {
    @StateObject var userViewModel = UserViewModel() // ViewModel을 앱 전역에서 사용
    
    init() {
            // Kakao SDK 초기화
            KakaoSDK.initSDK(appKey:"e95dba54a1f1675bea1ad321c57a46b3")
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel) // ViewModel을 하위 뷰에 전달
        }
    }
}
