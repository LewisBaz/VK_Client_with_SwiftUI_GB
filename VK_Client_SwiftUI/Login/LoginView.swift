//
//  LoginView.swift
//  VK App
//
//  Created by Lewis on 28.11.2021.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @State private var login = ""
    @State private var password = ""
    @State private var shouldShowLogo: Bool = true
    @State private var shouldShowErrorAlert: Bool = false
    
    @ObservedObject var viewModel: LoginViewModel
    let appCoordinator: AppFlowCoordinator
    
    private let keyboardIsOnPublisher = Publishers.Merge(
           NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
               .map { _ in true },
           NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
               .map { _ in false }
       )
           .removeDuplicates()
    
    var body: some View {
        ScrollView {
            Text("VK App")
                .padding(.top, 50)
                .font(.largeTitle)
                .padding(.bottom, 20)
            VStack {
                HStack {
                    Text(Image(systemName: "person.crop.square"))
                        .padding(.leading, 15)
                    Text("Login")
                    Spacer()
                    TextField("Enter Login", text: $login)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing, 20)
                        .frame(maxWidth: 200)
                        .colorMultiply(Color(red: 168.0 / 255.0, green: 249.0 / 255.0, blue: 255.0 / 255.0, opacity: 1.0))
                }
                HStack {
                    Text(Image(systemName: "key.fill"))
                        .padding(.leading, 15)
                    Text("Password")
                    Spacer()
                    SecureField("Enter Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing, 20)
                        .frame(maxWidth: 200)
                        .colorMultiply(Color(red: 168.0 / 255.0, green: 249.0 / 255.0, blue: 255.0 / 255.0, opacity: 1.0))
                }
                Button(action: {
                    onButtonTapped()
                    print("Button tapped")
                }, label: {
                    Text("Log In")
                        .frame(width: 100, height: 50, alignment: .center)
                        .foregroundColor(Color.black)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 168.0 / 255.0, green: 249.0 / 255.0, blue: 255.0 / 255.0, opacity: 1.0)))
                })
                //.disabled(login.isEmpty || password.isEmpty)
                .padding(.top, 30)
                .onReceive(keyboardIsOnPublisher) { isKeyboardOn in
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                    self.shouldShowLogo = !isKeyboardOn
                }
                }.onTapGesture {
                    UIApplication.shared.endEditing()
                }.alert(isPresented: $shouldShowErrorAlert, content: {
                    Alert(title: Text("Error"),
                          message: Text("Incorrect login or password"))
                })
            }
        }
        .navigationBarHidden(true)
        .background(Color(red: 99.0 / 255.0, green: 229.0 / 255.0, blue: 230.0 / 255.0, opacity: 1.0))
    }
    
    private func onButtonTapped() {
        if login == "" && password == "" {
            self.viewModel.isUserLoggedIn = true
            print("Login success")
        } else {
            print("Login error")
            shouldShowErrorAlert = true
        }
        login = ""
        password = ""
    }
}

//struct LoginView_Provider: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}

extension UIApplication {
   func endEditing() {
       sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
}
