//
//  PostModel.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//


import Foundation

struct Post {
    let id: UUID
    let text: String
    let authorName: String
    let authorAvatarURL: URL
//    let authorTag: String
    var likesCount: Int
    var commentsCount: Int
    let timestamp: Date
}

