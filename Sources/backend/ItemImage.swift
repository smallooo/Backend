//
//  File.swift
//  
//
//  Created by Dongming He on 2023/2/13.
//

import SwiftUI



public struct ItemImage : View {
    let path: String?
    let size: CGFloat
    
    public init(path: String?, size: CGFloat) {
        self.path = path
        self.size = size
    }
    
    public var body: some View {
        Image(systemName: "list.dash")
            .foregroundColor(.gray)
    }
}
