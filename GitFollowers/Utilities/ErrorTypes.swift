//
//  ErrorTypes.swift
//  GitFollowers
//
//  Created by kodirbek on 1/15/24.
//

import Foundation

enum ErrorTypes: String {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Plsease try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
