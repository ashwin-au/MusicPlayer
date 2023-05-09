//
//  PlayerDetailView.swift
//  TrainingSwift
//
//  Created by Ashwin A U on 05/05/23.
//

import SwiftUI

struct PlayerDetailView: View {
    var namespace: Namespace.ID
    @EnvironmentObject var viewModel: PlayerViewModel

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(maxHeight: .infinity)
            Image(viewModel.selectedSong.image)
                .resizable()
                .cornerRadius(12)
                .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                .aspectRatio(contentMode: .fill)
                .padding(.horizontal, 20)
                .matchedGeometryEffect(id: "trackImage", in: namespace)
                .padding(.bottom, 16)
            PlayerDetailTitle(namespace: namespace).environmentObject(viewModel)

//            PlayerDetailControlView(isPlaying: $viewModel.isPlaying, namespace: namespace).padding(.top, 20)

            controlsView
                .matchedGeometryEffect(id: "playButton", in: namespace)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.thinMaterial)
            .background(
                Image(viewModel.selectedSong.image)
                    .resizable()
                    .opacity(0.7)
                    .if(!viewModel.showDetail) {
                        $0.hidden()
                    }
            )
            .ignoresSafeArea()
    }

    private var controlsView: some View {
        VStack {
            ProgressView(value: viewModel.playerProgress)
                .progressViewStyle(
                    LinearProgressViewStyle(tint: .white))
                .padding(.bottom, 8)

            HStack {
                Text(viewModel.playerTime.elapsedText)

                Spacer()

                Text(viewModel.playerTime.remainingText)
            }
            .font(.system(size: 14, weight: .semibold))

//            Spacer()

            audioControlButtons
                .disabled(!viewModel.isPlayerReady)
                .padding(.bottom)

            Spacer()

//            adjustmentControlsView
        }
        .padding(.horizontal)
    }

    private var audioControlButtons: some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer()
            ButtonWithImage(image: Image.shuffle) {}
            Button {
                viewModel.skip(forwards: false)
            } label: {
                Image.backwardFill
            }
            .font(.system(size: 28))

            Spacer()

            Button {
                viewModel.playOrPause()
            } label: {
                ZStack {
                    Color.blue
                        .frame(
                            width: 10,
                            height: 35 * CGFloat(viewModel.meterLevel))
                        .opacity(0.5)

                    viewModel.isPlaying ? Image.pauseCircleFill : Image.playCircleFill
                }
            }
            .frame(width: 40)
            .font(.system(size: 45))

            Spacer()

            Button {
                viewModel.skip(forwards: true)
            } label: {
                Image.forwardEndFills
            }
            .font(.system(size: 32))
            ButtonWithImage(image: Image.repeats) {}
            Spacer()
        }
        .foregroundColor(.primary)
        .padding(.vertical, 20)
        .frame(height: 58)
    }

    private var adjustmentControlsView: some View {
        VStack {
            HStack {
                Text("Playback speed")
                    .font(.system(size: 16, weight: .bold))

                Spacer()
            }

            Picker("Select a rate", selection: $viewModel.playbackRateIndex) {
                ForEach(0 ..< viewModel.allPlaybackRates.count) {
                    Text(viewModel.allPlaybackRates[$0].label)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .disabled(!viewModel.isPlayerReady)
            .padding(.bottom, 20)

            HStack {
                Text("Pitch adjustment")
                    .font(.system(size: 16, weight: .bold))

                Spacer()
            }

            Picker("Select a pitch", selection: $viewModel.playbackPitchIndex) {
                ForEach(0 ..< viewModel.allPlaybackPitches.count) {
                    Text(viewModel.allPlaybackPitches[$0].label)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .disabled(!viewModel.isPlayerReady)
        }
        .padding()
        .background(.ultraThickMaterial)
    }
}

struct PlayerDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    @StateObject static var viewModel = PlayerViewModel()
    static var previews: some View {
        PlayerDetailView(namespace: namespace)
            .environmentObject(viewModel)
    }
}

// MARK: - PlayerDetailTitle

struct PlayerDetailTitle: View {
    @State var isLike: Bool = false
    @State var isDislike: Bool = false
    var namespace: Namespace.ID
    @EnvironmentObject var viewModel: PlayerViewModel
    var likeIcon: Image {
        return isLike == true ? Image.thumbs_upFill : Image.thumbs_up
    }

    var dislikeIcon: Image {
        return isDislike == true ? Image.thumbs_downFill : Image.thumbs_down
    }

    var body: some View {
        HStack {
            Button(action: { withAnimation(.spring()) {
                isDislike.toggle()
                isLike = !isDislike
            }}, label: {
                dislikeIcon
            })
            .foregroundColor(.white)
            Spacer()
            VStack(alignment: .center, spacing: 4) {
                Marquee {
                    Text(viewModel.selectedSong.title)
                        .font(.title3.bold())
                        .matchedGeometryEffect(id: "albumTitle", in: namespace)
                }.marqueeAutoreverses(false)
                    .marqueeDuration(8)
                    .marqueeWhenNotFit(true)
                    .marqueeIdleAlignment(.center)
                    .frame(height: 44)

                Text(viewModel.selectedSong.album)
                    .matchedGeometryEffect(id: "trackTitle", in: namespace)
            }
            Spacer()
            Button(action: { withAnimation(.spring()) {
                isLike.toggle()
                isDislike = !isLike
            }}, label: {
                likeIcon
            })
            .foregroundColor(.white)

        }.padding(.horizontal, 20)
    }
}

// MARK: - PlayerDetailControlView

//struct PlayerDetailControlView: View {
//    @Binding var isPlaying: Bool
//
//    var namespace: Namespace.ID
//    var playIcon: Image {
//        return isPlaying == true ? Image.pauseCircleFill : Image.playCircleFill
//    }
//
//    var body: some View {
//        HStack(alignment: .center, spacing: 32) {
//            ButtonWithImage(image: Image.shuffle) {}
//            ButtonWithImage(image: Image.backwardFill) { }
//            ButtonWithImage(image: playIcon) {
//                isPlaying.toggle()
//            }
//            .font(.largeTitle)
//            ButtonWithImage(image: Image.forwardEndFills) { }
//            ButtonWithImage(image: Image.repeats) {}
//        }.matchedGeometryEffect(id: "playButton", in: namespace)
//    }
//}

// MARK: - ButtonWithImage

struct ButtonWithImage: View {
    var image: Image
    var onTap: () -> Void
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            image
        }).foregroundColor(.white)
    }
}
