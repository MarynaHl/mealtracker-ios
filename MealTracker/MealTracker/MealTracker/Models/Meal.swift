import Foundation
import SwiftUI

struct Meal: Identifiable {
    let id: UUID
    var date: Date          // Одна дата/час прийому
    var name: String        // Назва прийому (Сніданок, Обід, тощо)
    var note: String        // Нотатка
    var color: Color        // Колір для візуальної позначки
    
    init(
        id: UUID = UUID(),
        date: Date,
        name: String = "Прийом їжі",
        note: String = "",
        color: Color = Color.pink
    ) {
        self.id = id
        self.date = date
        self.name = name
        self.note = note
        self.color = color
    }
}
