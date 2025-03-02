import Foundation
import SwiftUI

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    
    // Додаємо новий прийом їжі
    func addMeal(_ meal: Meal) {
        meals.append(meal)
        sortMeals()
    }
    
    // Сортуємо так, щоб найновіші були зверху
    func sortMeals() {
        meals.sort { $0.date > $1.date }
    }
    
    // Видалення
    func deleteMeal(at offsets: IndexSet) {
        meals.remove(atOffsets: offsets)
    }
    
    // Обчислення інтервалу між двома прийомами (у хвилинах/годинах)
    func intervalBetween(previous: Meal, current: Meal) -> String {
        let interval = previous.date.timeIntervalSince(current.date)
        let minutes = Int(interval / 60)
        let absMinutes = abs(minutes)
        if absMinutes < 60 {
            return "\(absMinutes) хв"
        } else {
            let hours = absMinutes / 60
            let remainderMinutes = absMinutes % 60
            return "\(hours) год \(remainderMinutes) хв"
        }
    }
}
