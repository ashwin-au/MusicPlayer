//
//  SongListView.swift
//  TrainingSwift
//
//  Created by Ashwin A U on 05/05/23.
//

import SwiftUI

struct SongListView: View {
    @EnvironmentObject var viewModel: PlayerViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.songList, id: \.id) { song in
                    SongCellView(data: song)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                                self.viewModel.showDetail.toggle()
                                self.viewModel.selectedSong = song
                                self.viewModel.changeTrack()
                            }
                        }
                    Divider().padding(.horizontal, 20)
                }
            }.padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                .padding(.bottom, 160)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.thinMaterial)
    }
}

// MARK: - SongCellView
struct SongCellView: View {
    var data: SongModel
    var body: some View {
        HStack {
            Image(data.image)
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 4) {
                Text(data.title)
                    .font(.caption.bold())
                Text(data.artist)
                    .font(.footnote)
            }
        }
    }
}
