//
//  Time.swift
//  RequestDemo
//
//  Created by Mousa Alwaraki on 4/27/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current
let hour = calendar.component(.hour, from: date)
let minutes = calendar.component(.minute, from: date)
let day = 01
let month = 01
let year = 2001
let currentTimeString = "\(hour).\(minutes)" ?? "smth"
let todaysDate = "\(year)-\(month)-\(day)"



//func getCurrentTime() {
//    let timeFormatter = DateFormatter()
//    timeFormatter.dateFormat = "HH.mm"
//    let currentTime = timeFormatter.date(from: currentTimeString)
//    return currentTime
//}
