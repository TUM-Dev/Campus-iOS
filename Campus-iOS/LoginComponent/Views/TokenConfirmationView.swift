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
    @State var showBackButtonAlert: Bool = false
    @State var currentStep: Int = 1
    /// The `LoginViewModel` that manages the content of the login screen
    @ObservedObject var viewModel: LoginViewModel
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10){
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
                                Text("Log in on [TUMonline](https://campus.tum.de)")
                                    .font(.body)
                                    .tint(Color(.tumBlue))
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
            
            
                Spacer()
                
                Button(action: {
                    self.viewModel.checkAuthorizzation()
                }) {
                    Text("Check Authorization").lineLimit(1).font(.body)
                        .frame(width: 200, height: 48, alignment: .center)
                }
                .alert("Authorization Error", isPresented: self.$viewModel.showTokenAlert) {
                    Button("OK", role: .cancel) {}
                }
                .font(.title)
                .foregroundColor(.white)
                .background(Color(.tumBlue))
                .cornerRadius(10)
                
                Spacer()
                
                let mailToString = "mailto:app@tum.de?subject=[IOS - Token]&body=Hello I have an issue activating the token...".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let mailToUrl = URL(string: mailToString!)!
                Link(destination: mailToUrl) {
                    Text("Contact Support").foregroundColor(Color(.tumBlue))
                }
                
                Spacer()
                
                
            }
        }
        .navigationBarTitle("Authorize Token", displayMode: .automatic)
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            self.showBackButtonAlert = true
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }.foregroundColor(Color(.tumBlue))
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
        
        
    }
    
    private func switchSteps() async {
        // Delay of 5 seconds (1 second = 1_000_000_000 nanoseconds)
        guard let model = self.viewModel.model else {
            return
        }
        
        while (!model.isUserAuthenticated) {
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
