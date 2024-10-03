import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel // 전역 ViewModel
    
    var body: some View {
        NavigationView {  // NavigationView 추가
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Text("Current Role: \(userViewModel.role ?? "nologin")")
                    .padding()
                NavigationLink(destination: LoginView()) {  // LoginView로 이동하는 버튼 추가
                    Text("Go to Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
