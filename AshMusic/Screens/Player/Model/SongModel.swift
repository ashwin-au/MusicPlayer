//
//  SongModel.swift
//  TrainingSwift
//
//  Created by Ashwin A U on 05/05/23.
//

import Foundation
 
struct SongModel: Identifiable, Hashable {
    var id = UUID()
    var artist: String
    var album: String
    var title: String
    var image: String
    var url: String
}
