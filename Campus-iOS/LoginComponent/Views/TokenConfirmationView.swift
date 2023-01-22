//
//  TokenConfirmationView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import SwiftUI
import AVKit
import AVFoundation

struct TokenConfirmationView: View {
    /// Used for the customized back button
    @Environment(\.presentationMode) var presentationMode
    @State var showTokenAlert: Bool = false
    @State var showTokenHelp: Bool = false
    @State var tokenPermissionButton: Bool = false
    @State var tokenState: LoginViewModel.TokenState = .notChecked
    @State var buttonBackgroundColor: Color = .tumBlue
    @State var showBackButtonAlert: Bool = false
    @State var showCheckTokenButton: Bool = true
    @State var showTUMOnline = false
    @State var currentStep: Int = 1
    @State var isActive = true

    /// The `LoginViewModel` that manages the content of the login screen
    @ObservedObject var viewModel: LoginViewModel
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                VStack {
                    switch currentStep {
                    case 1:
                        HStack() {
                            Text("1")
                                .frame(width: 42, height: 42, alignment: .center)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(white: 1.0))
                                .background(Color(.tumBlue))
                                .clipShape(Circle())
                            
                            Spacer().frame(width: 20)
                            
                            HStack(spacing: 5) {
                                HStack(spacing: 0) {
                                    Text("Log in on ")
                                    Text("TUMonline").foregroundColor(.tumBlue)
                                        .onTapGesture {
                                            showTUMOnline = true
                                        }
                                }
                                .font(.body)
                            }
                            
                        }
                    case 2:
                        HStack() {
                            Text("2")
                                .frame(width: 42, height: 42, alignment: .center)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(white: 1.0))
                                .background(Color(.tumBlue))
                                .clipShape(Circle())
                            
                            Spacer().frame(width: 20)
                            
                            Text("Select **Token-Management**")
                                .font(.body)
                        }
                    case 3:
                        HStack() {
                            Text("3")
                                .frame(width: 42, height: 42, alignment: .center)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(white: 1.0))
                                .background(Color(.tumBlue))
                                .clipShape(Circle())
                            
                            Spacer().frame(width: 20)
                            
                            Text("Activate the newly created token and enable your desired permissions")
                                .font(.body)
                                .minimumScaleFactor(0.2)

                        }
                    default: EmptyView()
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.11, alignment: .center)
                
                
                
                    
                let videoUrl = Bundle.main
                    .url(forResource: "token-tutorial", withExtension: "mov")!
                PlayerView(videoUrl: videoUrl)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                // Video is 2532 x 1170
                    .frame(width: screenWidth*0.109*5, height: screenWidth*0.185*5, alignment: .center)
                
            
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button {
                            self.showTUMOnline = true
                        } label: {
                            HStack {
                                Image(systemName: "globe")
                                Text("TUMOnline")
                            }
                            .lineLimit(1)
                            .font(.system(size: 15, weight: .bold))
                            .frame(width: 150, height: 48, alignment: .center)
                        }
                        .foregroundColor(.white)
                        .background(Color(.tumBlue))
                        .cornerRadius(10)
                        .padding()
                        
                        Spacer()
                        
                        if !tokenPermissionButton {
                            Button(action: {
                                Task {
                                    await  self.viewModel.checkAuthorization() { result in
                                        switch result {
                                        case .success:
                                            withAnimation {
                                                tokenState = .active
                                                buttonBackgroundColor = .green
                                                showTokenHelp = false
                                            }
                                        case .failure(_):
                                            withAnimation {
                                                tokenState = .inactive
                                                buttonBackgroundColor = .red
                                                showTokenHelp = true
                                            }
                                        }
                                    }
                                }
                            }) {
                                switch tokenState {
                                case .notChecked:
                                    HStack {
                                        Text("Check Token")
                                            .lineLimit(1)
                                            .font(.system(size: 15, weight: .bold))
                                        Image(systemName: "arrow.right")
                                    }
                                    
                                case .inactive:
                                    VStack {
                                        HStack {
                                            Text("Token inactive")
                                                .lineLimit(1)
                                                .font(.system(size: 14, weight: .bold))
                                        }
                                    }
                                    .padding()
                                    .onAppear() {
                                        Task {
                                            try? await Task.sleep(nanoseconds: 1_500_000_000)
                                            withAnimation(.easeInOut) {
                                                tokenState = .notChecked
                                                buttonBackgroundColor = .tumBlue
                                            }
                                        }
                                    }
                                case .active:
                                    if let model = self.viewModel.model {
                                        NavigationLink(destination: TokenPermissionsView(viewModel: TokenPermissionsViewModel(model: model)).navigationTitle("Check Permissions"), isActive: $isActive) {
                                            Text("Next")
                                                .lineLimit(1)
                                                .font(.body)
                                                .frame(width: 200, height: 48, alignment: .center)
                                                .foregroundColor(.white)
                                                .background(.green)
                                                .cornerRadius(10)
                                                .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                            .frame(width: 150, height: 48, alignment: .center)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .background(buttonBackgroundColor)
                            .cornerRadius(10)
                            .buttonStyle(.plain)
                            .padding()
                        }
                        Spacer()
                    }
                    
                    if showTokenHelp {
                        Spacer()
                        Text("Please activate the latest token on TUMOnline").foregroundColor(.red)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    let mailToString = "mailto:app@tum.de?subject=[IOS - Token]&body=Hello, I have an issue activating the token of Campus Online in the TCA version \(Bundle.main.appVersionShort) on \(ProcessInfo().operatingSystemVersion.fullVersion). My token state is currently: \(tokenState). Please describe the problem in more detail.".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let mailToUrl = URL(string: mailToString!)!
                    Link(destination: mailToUrl) {
                        Text("Contact Support").foregroundColor(Color(.tumBlue))
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitle("Check Token", displayMode: .automatic)
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            self.showBackButtonAlert = true
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(Color(.tumBlue))
          }
        )
        .alert(isPresented: $showBackButtonAlert) {
              Alert(
                title: Text("Are you sure?"),
                message: Text("Leaving now will invalidate the current token!"),
                primaryButton: .default(Text("Leave")) {
                  self.presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
              )
        }
        .task {
            await switchSteps()
        }
        .sheet(isPresented: $showTUMOnline) {
            SFSafariViewWrapper(url: Constants.tokenManagementTUMOnlineUrl).edgesIgnoringSafeArea(.bottom)
         }
        
        
    }
    
    private func switchSteps() async {
        // Delay of 5 seconds (1 second = 1_000_000_000 nanoseconds)
        while (!self.viewModel.model.isUserAuthenticated) {
            switch currentStep {
            case 1:
                try? await Task.sleep(nanoseconds: 5_160_000_000)
                withAnimation(.easeInOut) {
                    currentStep = 2
                }
            case 2:
                try? await Task.sleep(nanoseconds: 3_870_000_000)
                withAnimation(.easeInOut) {
                    currentStep = 3
                }
            case 3:
                try? await Task.sleep(nanoseconds: 7_210_000_000)
                withAnimation(.easeInOut) {
                    currentStep = 1
                }
            default:
                return
            }
        }
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
}

struct TokenConfirmationView_Previews: PreviewProvider {
    static let model = MockModel()
    
    static var previews: some View {
        Text("Background2").sheet(isPresented: .constant(true)) {
            NavigationView {
                TokenConfirmationView(viewModel: LoginViewModel(model: model))
            }
        }//.previewDevice("iPod touch (7th generation)")
            //.previewDevice("iPhone SE (3rd generation)")
        .previewDevice("iPhone 12")
        
        Text("Background2").sheet(isPresented: .constant(true)) {
            NavigationView {
                TokenConfirmationView(viewModel: LoginViewModel(model: model))
            }
        }.previewDevice("iPod touch (7th generation)")
            //.previewDevice("iPhone SE (3rd generation)")
        //.previewDevice("iPhone 12")
    }
}

struct PlayerView: UIViewRepresentable {
    let videoUrl: URL
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoUrl: videoUrl)
    }
    
}

class PlayerUIView: UIView {
    
    private var playerLooper: AVPlayerLooper
    private let playerLayer = AVPlayerLayer()
    
    private let playerFrameWidth: CGFloat?
    private let playerFrameHeight: CGFloat?
    
    init(videoUrl: URL) {
        let asset = AVAsset(url: videoUrl)
        let item = AVPlayerItem(asset: asset)
        playerFrameWidth = asset.tracks.first?.naturalSize.width
        playerFrameHeight = asset.tracks.first?.naturalSize.height
        
        let player = AVQueuePlayer(playerItem: item)
        self.playerLayer.player = player
        
        self.playerLooper = AVPlayerLooper(player: player, templateItem: item)
        
        super.init(frame: .zero)
        layer.addSublayer(playerLayer)
        backgroundColor = UIColor.tumBlue
        
        player.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //2532 x 1170
        let screenWidth = UIScreen.main.bounds.size.width
        //let screenHeight = UIScreen.main.bounds.size.height
        
        let playerFrame = CGRect(origin: CGPoint(x: -screenWidth*0.08, y: -screenWidth*0.07), size: CGSize(width: screenWidth*0.1170*6, height: screenWidth*0.1993*6))
        playerLayer.frame = playerFrame
    }
    
}

extension OperatingSystemVersion {
    var fullVersion: String {
        "\(majorVersion).\(minorVersion).\(patchVersion)"
    }
}

extension Bundle {
    var appVersionShort: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            return "⚠️"
        }
    }
}
