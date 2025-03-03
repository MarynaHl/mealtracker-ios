import Foundation
import SwiftUI

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    
    // Словник: "Назва" -> "Колір" (для автоматичного підстановлення)
    let defaultColorMapping: [String : Color] = [
        "Сніданок": .green,
        "Обід": .pink,
        "Вечеря": .blue,
        "Перекус": .orange
        // Можна розширити
    ]
    
    // Зворотній пошук: шукаємо "Назву" за заданим кольором (якщо така є)
    func nameForColor(_ color: Color) -> String? {
        defaultColorMapping.first(where: { $0.value == color })?.key
    }
    
    // Або колір за назвою
    func colorForName(_ name: String) -> Color? {
        defaultColorMapping[name]
    }
    
    // Додаємо новий прийом їжі
    func addMeal(_ meal: Meal) {
        meals.append(meal)
        sortMeals()
    }
    
    // Сортувати, щоб найновіші були зверху
    func sortMeals() {
        meals.sort { $0.date > $1.date }
    }
    
    // Видаляємо
    func deleteMeal(at offsets: IndexSet) {
        meals.remove(atOffsets: offsets)
    }
    
    // Повертає відформатований інтервал часу (між двома прийомами)
    // Використовуємо absolute value, щоб уникнути NaN або від’ємного результату
    func intervalBetween(later: Meal, earlier: Meal) -> String {
        let interval = abs(later.date.timeIntervalSince(earlier.date))
        let minutes = Int(interval / 60)
        
        if minutes < 60 {
            return "\(minutes) хв"
        } else {
            let hours = minutes / 60
            let remainder = minutes % 60
            return "\(hours) год \(remainder) хв"
        }
    }
}
