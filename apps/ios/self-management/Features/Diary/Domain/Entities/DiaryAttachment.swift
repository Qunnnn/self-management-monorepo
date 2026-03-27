//
//  DiaryAttachment.swift
//  self-management
//

import Foundation

struct DiaryAttachment: Identifiable, Equatable {
    let id: UUID
    let fileUrl: URL
    let fileType: String?
    let createdAt: Date
    
    init(id: UUID = UUID(), fileUrl: URL, fileType: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.fileUrl = fileUrl
        self.fileType = fileType
        self.createdAt = createdAt
    }
}
