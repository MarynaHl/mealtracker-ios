import Foundation
import SwiftUI

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    
    // Додаємо прийом їжі
    func addMeal(meal: Meal) {
        meals.append(meal)
        sortMeals()
    }
    
    // Видаляємо прийом їжі
    func deleteMeal(at offsets: IndexSet) {
        meals.remove(atOffsets: offsets)
    }
    
    // Сортувати, щоб найновіші були зверху
    func sortMeals() {
        // Сортуємо за датою початку від новішого до старішого
        meals.sort { $0.startDate > $1.startDate }
    }
    
    // Підрахунок інтервалу між прийомами
    // (наприклад, коли треба порахувати різницю між завершенням попереднього та початком цього)
    // Можна використати це в списку під час відображення
    func intervalBetween(previous: Meal, current: Meal) -> TimeInterval {
        return current.startDate.timeIntervalSince(previous.endDate)
    }
}
