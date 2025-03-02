import SwiftUI

struct MealListView: View {
    @ObservedObject var viewModel: MealsViewModel
    
    var body: some View {
        ScrollView {
            // Використаємо LazyVStack, щоб відображати список
            LazyVStack(spacing: 0) {
                // Групуємо за днем
                ForEach(groupedMealsByDate(), id: \.key) { date, meals in
                    // Заголовок дня
                    Text(formatDateForSection(date))
                        .font(.headline)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    // Перелік прийомів їжі за цей день
                    ForEach(meals) { meal in
                        // Свайп для видалення через встроєний SwiftUI підхід
                        SwipeToDeleteRow {
                            mealRow(meal: meal)
                        } onDelete: {
                            if let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }) {
                                viewModel.meals.remove(at: index)
                            }
                        }
                    }
                    // Трохи відступу після списку конкретного дня
                    .padding(.bottom, 4)
                }
            }
        }
    }
    
    // Одне рядкове у списку
    private func mealRow(meal: Meal) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                // Кольорове коло та назва
                Circle()
                    .fill(meal.color)
                    .frame(width: 16, height: 16)
                
                Text(meal.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(timeString(from: meal.startDate)) - \(timeString(from: meal.endDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Інтервал між попереднім прийомом
            Text("Інтервал: \(intervalToString(meal: meal))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
        // Тонка лінія знизу як розділювач
        .overlay(
            Divider()
                .background(Color.gray.opacity(0.2)),
            alignment: .bottom
        )
    }
    
    // Повертає години:хвилини з Date
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Визначення інтервалу між поточним та попереднім прийомом
    // Якщо попереднього немає, то "-"
    private func intervalToString(meal: Meal) -> String {
        // Знаходимо індекс у viewModel
        guard let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }),
              index < viewModel.meals.count - 1 else {
            return "-"
        }
        
        let previousMeal = viewModel.meals[index + 1]
        let interval = viewModel.intervalBetween(previous: previousMeal, current: meal)
        
        // Інтервал у хвилинах
        let minutes = Int(interval / 60)
        // Можна перевести у години і хвилини
        if minutes < 60 {
            return "\(minutes) хв"
        } else {
            let hours = minutes / 60
            let remainderMinutes = minutes % 60
            return "\(hours) год \(remainderMinutes) хв"
        }
    }
    
    // Групуємо прийоми їжі за датою (лише день, без часу)
    private func groupedMealsByDate() -> [(key: Date, value: [Meal])] {
        let grouped = Dictionary(grouping: viewModel.meals) { meal -> Date in
            // Беремо лише день, місяць і рік
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: meal.startDate)
            return calendar.date(from: components) ?? meal.startDate
        }
        // Сортуємо за ключем (датою) від новішого до старішого
        let sorted = grouped.sorted { $0.key > $1.key }
        return sorted
    }
    
    // Формат дати в заголовку (сьогодні, вчора або "dd MMMM")
    private func formatDateForSection(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Сьогодні"
        } else if calendar.isDateInYesterday(date) {
            return "Вчора"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM"
            return formatter.string(from: date)
        }
    }
}

// Простий компонент для реалізації свайпу з видаленням
struct SwipeToDeleteRow<Content: View>: View {
    let content: () -> Content
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isDeleting: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Фон під елементом
            Color.red
                .overlay(
                    Text("Delete")
                        .foregroundColor(.white)
                        .padding(.leading, 20),
                    alignment: .leading
                )
            
            // Сам елемент
            content()
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < 0 {
                                offset = gesture.translation.width
                            }
                        }
                        .onEnded { gesture in
                            if gesture.translation.width < -100 {
                                // Підтверджуємо видалення
                                withAnimation {
                                    onDelete()
                                }
                            } else {
                                // Відміняємо свайп
                                withAnimation {
                                    offset = 0
                                }
                            }
                        }
                )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
    }
}
