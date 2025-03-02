import Foundation
import SwiftUI

struct Meal: Identifiable {
    let id: UUID
    var name: String       // Назва (за замовчуванням "Прийом їжі", або "Сніданок", тощо)
    var startDate: Date    // Дата та час початку
    var endDate: Date      // Дата та час завершення
    var color: Color       // Колір з SwiftUI
    var note: String       // Нотатка (додатковий коментар)
    
    init(
        id: UUID = UUID(),
        name: String = "Прийом їжі",
        startDate: Date,
        endDate: Date,
        color: Color = Color.blue,
        note: String = ""
    ) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
        self.note = note
    }
}
