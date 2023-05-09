//
//  MiniPlayerView.swift
//  TrainingSwift
//
//  Created by Ashwin A U on 05/05/23.
//

import AVFoundation
import SwiftUI

struct MiniPlayerView: View {
    var namespace: Namespace.ID
    @EnvironmentObject var viewModel: PlayerViewModel

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(viewModel.selectedSong.image)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
                    .matchedGeometryEffect(id: "trackImage", in: namespace)
                VStack(alignment: .leading, spacing: 4) {
                    Marquee {
                        Text(viewModel.selectedSong.title)
                            .font(.title3.bold())
                            .matchedGeometryEffect(id: "albumTitle", in: namespace)
                    }.marqueeAutoreverses(false)
                        .marqueeDuration(8)
                        .marqueeWhenNotFit(true)
                        .frame(height: 44)
                    Text(viewModel.selectedSong.album)
                        .matchedGeometryEffect(id: "trackTitle", in: namespace)
                }
                Spacer()
                PlayerControlView(isPlaying: $viewModel.isPlaying, namespace: namespace)
                    .padding()
            }
            PlayerProgress
        }.frame(maxWidth: .infinity, maxHeight: 140)
            .padding(8)
            .background(.ultraThinMaterial)
            .background(
                Image(viewModel.selectedSong.image)
                    .resizable()
                    .opacity(0.9)
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
        
    }

    var PlayerProgress: some View {
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
        }
    }
}

// struct MiniPalyerView_Previews: PreviewProvider {
//    @Namespace static var namespace
//    static var previews: some View {
//        MiniPlayerView(namespace: namespace)
//    }
// }

struct PlayerControlView: View {
    @Binding var isPlaying: Bool
    var namespace: Namespace.ID
    var playIcon: Image {
        return isPlaying == true ? Image.pause : Image.playFill
    }
    @EnvironmentObject var viewModel: PlayerViewModel
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Button(action: {  viewModel.skip(forwards: false) }, label: {
                Image.backwardFill
            }).foregroundColor(.white)
            Button(action: {
                withAnimation(.spring()) {
                    viewModel.playOrPause()
                }
            }, label: {
                playIcon
            }).foregroundColor(.white)

            Button(action: { viewModel.skip(forwards: true) }, label: {
                Image.forwardEndFills
            }).foregroundColor(.white)
        }.matchedGeometryEffect(id: "playButton", in: namespace)
    }
}
