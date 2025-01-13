import SwiftUI
import FirebaseFirestore

struct ProfileSetupView: View {
    @State private var name: String = ""
    @State private var userName: String = ""
    @State private var userBio: String = ""
    @State private var avatarUrl: String = ""
    
    @State private var isDataInvalid = false
    @State private var isUsernameTaken = false
    
    var onSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile Setup")
                .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.Header.FontSizes.title))
                .foregroundStyle(.text)
                .padding(.top, 40)
            
            TextField("Name", text: $name)
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .padding()
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("UserName", text: $userName)
                .padding()
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
                .onChange(of: userName) { newValue in
                    checkUsernameAvailability(username: newValue)
                }
            
            TextField("Bio (Status)", text: $userBio)
                .padding()
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Avatar URL", text: $avatarUrl)
                .padding()
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: saveProfile) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.text)
                    .frame(width: 200, height: 50)
                    .background(Color.orangeButton)
                    .cornerRadius(25)
                    .padding(.top, 20)
            }
            .disabled(isUsernameTaken)
            
            if isUsernameTaken {
                Text("Username is already taken")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.background)
    }
    
    func checkUsernameAvailability(username: String) {
        if UserSessionManager.shared.currentProfile?.authorUsername == username {
            isUsernameTaken = false
        }
        else {
            Firestore.firestore().collection("users").whereField("authorUsername", isEqualTo: username).getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking username: \(error)")
                    return
                }
                if let snapshot = snapshot, !snapshot.isEmpty {
                    isUsernameTaken = true
                } else {
                    isUsernameTaken = false
                }
            }
        }
    }
    
    func saveProfile() {
        guard let currUser = UserSessionManager.shared.currentUser else {
            AlertHelper.showAlert(title: "User not logged in", message: "User not logged in")
            return
        }
        
        let currentProfile = UserSessionManager.shared.currentProfile
        let updatedName = name.isEmpty ? currentProfile?.authorName ?? "" : name
        let updatedUserName = userName.isEmpty ? currentProfile?.authorUsername ?? "" : userName
        let updatedAvatarUrl = avatarUrl.isEmpty ? currentProfile?.authorAvatarURL?.absoluteString ?? "" : avatarUrl
        
        if isDataInvalid {
            AlertHelper.showAlert(title: "Error", message: "Invalid Fields")
        } else if isUsernameTaken {
            AlertHelper.showAlert(title: "Error", message: "Username is already taken")
        } else {
            UserSessionManager.shared.updateUserToDatabase(uid: currUser.uid, authorName: updatedName, authorUsername: updatedUserName, authorBio: userBio, authorAvatarURL: URL(string: updatedAvatarUrl))
            print("Profile updated!")
            onSuccess()
        }
    }
}

