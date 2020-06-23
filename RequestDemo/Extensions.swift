//
//  Extensions.swift
//  RequestDemo
//
//  Created by Mousa Alwaraki on 4/27/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import Foundation

extension Date {
    func getWeekdayString() -> String{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEEE"
          let weekDay = dateFormatter.string(from: Date())
          return weekDay
    }
}
