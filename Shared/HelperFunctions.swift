//
//  HelperFunctions.swift
//  XKCD
//
//  Created by Georg Meissner on 03.08.20.
//

import Foundation

func formatDate (date: Date) -> String{
    let format = DateFormatter()
//    format.dateFormat = "date.locformat"//"yyyy-MM-dd"
    format.dateFormat = "yyyy-MM-dd"
    let formattedDate = format.string(from: date)
    return formattedDate
}
