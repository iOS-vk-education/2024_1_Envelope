//
//  ProfileSetupView.swift
//  TwiX
//
//  Created by Alexander on 20.12.2024.
//

import SwiftUI

struct ProfileSetupView: View {
    @State private var name: String = ""
    @State private var userName: String = ""
    @State private var avatarUrl: String = ""
    
    // TODO: - Data validation
    @State private var isDataInvalid = false
    
    var onSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile Setup")
                .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.Header.FontSizes.title))
                .foregroundStyle(.text)
                .padding(.top, 40)
            
            // TextField for Name
            TextField("Name", text: $name)
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .padding()
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            // TextField for UserName
            TextField("UserName", text: $userName)
                .padding()
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            // TextField for AvatarUrl
            TextField("Avatar URL", text: $avatarUrl)
                .padding()
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            // Save Button
            Button(action: saveProfile) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.text)
                    .frame(width: 200, height: 50)
                    .background(Color.orangeButton)
                    .cornerRadius(25)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.background)
    }
    
    // Save profile action
    func saveProfile() {
        if (isDataInvalid) {
            AlertHelper.showAlert(title: "Error", message: "Invalid Fields")
        } else {
            guard let currUser = UserSessionManager.shared.currentUser else {
                AlertHelper.showAlert(title: "User not logged in", message: "User not logged in")
                return
            }
            UserSessionManager.shared.updateUserToDatabase(uid: currUser.uid, authorName: name, authorUsername: userName, authorAvatarURL: URL(string: avatarUrl))
            print("Profile updated!")
            onSuccess()
        }
    }
}

//
//struct ProfileSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSetupView(onSuccess: {})
//    }
//}
