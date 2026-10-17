//
//  DateUtils.swift
//  MewNotch
//
//  Created by Monu Kumar on 05/03/2025.
//

import SwiftUI

class DateUtils {
    static let shared = DateUtils()

    private init() {}

    private var dateFormatter: DateFormatter = .init()

    func getFormattedDate(
        _ date: Date,
        format: String = "yyyy-MM-dd HH:mm a"
    ) -> String {
        dateFormatter.dateFormat = format

        return dateFormatter.string(
            from: date
        )
    }
}
