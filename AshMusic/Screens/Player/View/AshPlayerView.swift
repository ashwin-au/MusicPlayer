//
//  AshPlayerView.swift
//  TrainingSwift
//
//  Created by Ashwin A U on 05/05/23.
//

import SwiftUI

struct AshPlayerView: View {
    @Namespace var namespace
    @StateObject var viewModel = PlayerViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.showDetail {
                    PlayerDetailView(namespace: namespace)
                        .environmentObject(viewModel)
                        .if(!viewModel.showDetail) {
                            $0.hidden()
                        }
                        .matchedGeometryEffect(id: "player", in: namespace)
                } else {
                    VStack {
                        SongListView().environmentObject(viewModel)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    MiniPlayerView(namespace: namespace)
                        .environmentObject(viewModel)
                        .if(viewModel.showDetail) {
                            $0.hidden()
                        }
                        .matchedGeometryEffect(id: "player", in: namespace)
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                            viewModel.showDetail = false
                        }

                    }, label: {
                        Image.close
                            .foregroundColor(.white)
                    })
                    .if(!viewModel.showDetail) {
                        $0.hidden()
                    }
                }
            }
        }
    }
}

struct AshPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AshPlayerView()
    }
}

struct ViewBuilderView<Content>: View where Content: View {
    private var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack {
            content()
        }.background(Color.blue)
    }
}
