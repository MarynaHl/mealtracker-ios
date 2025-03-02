import SwiftUI

struct MealListView: View {
    @ObservedObject var viewModel: MealsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Проходимося по масиву прийомів
                ForEach(viewModel.meals) { meal in
                    // Один рядок
                    SwipeToDeleteRow {
                        mealRow(meal: meal)
                    } onDelete: {
                        if let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }) {
                            viewModel.meals.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    // Відображення одного рядка
    private func mealRow(meal: Meal) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Верхня частина з назвою та годиною
            HStack {
                Circle()
                    .fill(meal.color)
                    .frame(width: 16, height: 16)
                
                Text(meal.name)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(timeString(from: meal.date))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Нотатка (якщо не пуста)
            if !meal.note.isEmpty {
                Text(meal.note)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Інтервал від попереднього прийому
            if let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }),
               index < viewModel.meals.count - 1 {
                let previousMeal = viewModel.meals[index + 1]
                Text("Інтервал: \(viewModel.intervalBetween(previous: previousMeal, current: meal))")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Divider().background(Color.gray.opacity(0.3))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.clear)
    }
    
    // Формуємо рядок “hh:mm” (або 24-год формат)
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Свайп-видалення
struct SwipeToDeleteRow<Content: View>: View {
    let content: () -> Content
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.red
                .overlay(
                    Text("Delete")
                        .foregroundColor(.white)
                        .padding(.leading, 20),
                    alignment: .leading
                )
            
            content()
                .background(Color.black) // щоб було темно
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
                                withAnimation {
                                    onDelete()
                                }
                            } else {
                                withAnimation {
                                    offset = 0
                                }
                            }
                        }
                )
        }
        .frame(height: 60)
    }
}
