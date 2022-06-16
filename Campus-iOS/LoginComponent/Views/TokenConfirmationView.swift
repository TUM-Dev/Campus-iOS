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
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                VStack {
                    Spacer(minLength: geo.size.height*0.15)
                    VStack {
                        switch currentStep {
                        case 1:
                            HStack() {
                                Text("1")
                                    .frame(width: 42, height: 42, alignment: .center)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(white: 1.0))
                                    .background(Color(red: 0.203649, green: 0.35383618, blue: 0.72193307))
                                    .clipShape(Circle())
                                
                                Spacer().frame(width: 20)
                                
                                Text("Check your email and click on the link to confirm your token or visit TUMonline")
                                    .font(.body)
                            }
                        case 2:
                            HStack() {
                                Text("2")
                                    .frame(width: 42, height: 42, alignment: .center)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(white: 1.0))
                                    .background(Color(red: 0.203649, green: 0.35383618, blue: 0.72193307))
                                    .clipShape(Circle())
                                
                                Spacer().frame(width: 20)
                                
                                Text("Select \"Token-Management\"")
                                    .font(.body)
                            }
                        case 3:
                            HStack() {
                                Text("3")
                                    .frame(width: 42, height: 42, alignment: .center)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(white: 1.0))
                                    .background(Color(red: 0.203649, green: 0.35383618, blue: 0.72193307))
                                    .clipShape(Circle())
                                
                                Spacer().frame(width: 20)
                                
                                Text("Click on the newly created token and enable your desired permissions")
                                    .font(.body)
                            }
                        default: EmptyView()
                        }
                    }.padding()
                    
                    VStack {
                        let videoUrl = Bundle.main
                            .url(forResource: "token-tutorial", withExtension: "mov")!
                        PlayerView(videoUrl: videoUrl)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        // Video is 2532 x 1170
                            .frame(width: geo.size.width*0.60, height: geo.size.height*0.5, alignment: .center)
                        
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
                        .background(Color(red: 0.203649, green: 0.35383618, blue: 0.72193307))
                        .cornerRadius(10)
                        .padding()
                    }
                    Spacer()
                }.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
            }
        }
        .background(Color(.systemBackground))
        ._scrollable()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            self.showBackButtonAlert = true
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
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
        .edgesIgnoringSafeArea(.top)
        .task {
            await switchSteps()
        }
        
        
    }
    
    private func switchSteps() async {
        // Delay of 5 seconds (1 second = 1_000_000_000 nanoseconds)
        switch currentStep {
        case 1:
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            withAnimation(.easeInOut) {
                currentStep = 2
            }
        case 2:
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            withAnimation(.easeInOut) {
                currentStep = 3
            }
        case 3:
            try? await Task.sleep(nanoseconds: 8_000_000_000)
            withAnimation(.easeInOut) {
                currentStep = 1
            }
        default:
            return
        }
        
        await switchSteps()
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
}

struct TokenConfirmationView_Previews: PreviewProvider {
    static let model = MockModel()
    
    static var previews: some View {
        //Text("Background2").sheet(isPresented: .constant(true)) {
            NavigationView {
                TokenConfirmationView(viewModel: LoginViewModel(model: model))
            }
        //}
    }
}

extension HorizontalAlignment {
    /// A custom alignment for image titles.
    private struct CircleTitleAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to bottom alignment if no guides are set.
            context[HorizontalAlignment.leading]
        }
    }
    
    /// A guide for aligning titles.
    static let circleTitleAlignmentGuide = HorizontalAlignment(
        CircleTitleAlignment.self
    )
}

struct EnhancedVideoPlayer<VideoOverlay: View>: View {
    @StateObject private var viewModel: ViewModel
    @ViewBuilder var videoOverlay: () -> VideoOverlay
    
    init(_ urls: [URL],
         endAction: EndAction = .none,
         @ViewBuilder videoOverlay: @escaping () -> VideoOverlay) {
        _viewModel = StateObject(wrappedValue: ViewModel(urls: urls, endAction: endAction))
        self.videoOverlay = videoOverlay
    }
    
    var body: some View {
        VideoPlayer(player: viewModel.player, videoOverlay: videoOverlay)
            .onAppear(perform: {
                viewModel.player.play()
            })
    }
    
    class ViewModel: ObservableObject {
        let player: AVQueuePlayer
        
        init(urls: [URL], endAction: EndAction) {
            let playerItems = urls.map { AVPlayerItem(url: $0) }
            player = AVQueuePlayer(items: playerItems)
            player.actionAtItemEnd = .none // we'll manually set which video comes next in playback
            if endAction != .none {
                // this notification is triggered whenever a player item finishes playing
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                       object: nil,
                                                       queue: nil) { [self] notification in
                    let currentItem = notification.object as? AVPlayerItem
                    if endAction == .loop,
                       let currentItem = currentItem {
                        player.seek(to: .zero) // set the current player item to beginning
                        player.advanceToNextItem() // move to next video manually
                        player.insert(currentItem, after: nil) // add it to the end of the queue
                    }
                }
            }
        }
    }
    
    enum EndAction: Equatable {
        case none,
             loop
    }
}

extension EnhancedVideoPlayer where VideoOverlay == EmptyView {
    init(_ urls: [URL], endAction: EndAction) {
        self.init(urls, endAction: endAction) {
            EmptyView()
        }
    }
}

struct LoopingVideoPlayer: View {
    private var playerLooper: AVPlayerLooper
    private let controller = AVPlayerViewController()
    
    init(videoUrl: URL) {
        let asset = AVAsset(url: videoUrl)
        let item = AVPlayerItem(asset: asset)
        
        let player = AVQueuePlayer()
        controller.player = player
        controller.showsPlaybackControls = false
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        
        player.play()
    }
    
    var body: some View {
        VideoPlayer(player: controller.player)
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
        backgroundColor = UIColor.red
        
        player.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //2532 x 1170
        if let playerFrameWidth = playerFrameWidth, let playerFrameHeight = playerFrameHeight {
            let playerFrame = CGRect(origin: CGPoint(x: 0, y: -30), size: CGSize(width: 1170*0.2, height: 2532*0.2))
            playerLayer.frame = playerFrame
        }
        
        //playerLayer.frame = bounds
    }
    
}
