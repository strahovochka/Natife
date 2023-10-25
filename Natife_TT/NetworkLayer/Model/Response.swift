//
//  Response.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import Foundation

enum Response<T> {
    case success(T)
    case error(String)
}
