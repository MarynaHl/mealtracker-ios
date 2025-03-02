import SwiftUI

struct AddMealView: View {
    @ObservedObject var viewModel: MealsViewModel
    
    // Передане початкове значення часу
    var initialDate: Date
    
    // Локальний стан (щоб користувач міг редагувати перед додаванням)
    @State private var mealDate: Date = Date()
    @State private var mealName: String = "Прийом їжі"
    @State private var mealNote: String = ""
    @State private var selectedColor: Color = .pink
    
    // Для відображення модального picker-а
    @State private var showDatePicker = false
    
    // Для закриття вікна
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Дата/час (натискаємо, щоб змінити)
                    HStack {
                        Text("Дата / Час")
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            showDatePicker = true
                        }) {
                            Text(formattedDate(mealDate))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // “Їжа” (назва/тип)
                    HStack {
                        Text("Їжа")
                            .foregroundColor(.white)
                        Spacer()
                        TextField("Напр. 'Каша'", text: $mealName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                    }
                    
                    // Нотатка
                    HStack {
                        Text("Нотатка")
                            .foregroundColor(.white)
                        Spacer()
                        TextField("Деталі...", text: $mealNote)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                    }
                    
                    // Вибір кольору
                    HStack {
                        Text("Колір")
                            .foregroundColor(.white)
                        Spacer()
                        ColorPickerView(selectedColor: $selectedColor)
                    }
                    
                    // Кнопка "Зберегти"
                    Button(action: {
                        let meal = Meal(
                            date: mealDate,
                            name: mealName.isEmpty ? "Прийом їжі" : mealName,
                            note: mealNote,
                            color: selectedColor
                        )
                        viewModel.addMeal(meal)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Зберегти")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(12)
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("Їжа", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    })
                )
                // Sheet із коліщатком для вибору часу
                .sheet(isPresented: $showDatePicker) {
                    DatePickerSheet(date: $mealDate, isPresented: $showDatePicker)
                }
            }
            .onAppear {
                // Ініціалізуємо mealDate значенням, яке прийшло
                mealDate = initialDate
            }
        }
    }
}

// Окремий View для вибору кольору (кілька кнопок або стандартний ColorPicker)
struct ColorPickerView: View {
    @Binding var selectedColor: Color
    
    // Можна зробити масив кольорів:
    private let colors: [Color] = [.pink, .blue, .orange, .green, .purple, .yellow]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                    // Обвідка, якщо обраний колір
                    if color == selectedColor {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 34, height: 34)
                    }
                }
                .onTapGesture {
                    selectedColor = color
                }
            }
        }
    }
}

// Окремий View (sheet) із коліщатками дати й часу
struct DatePickerSheet: View {
    @Binding var date: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Закрити без змін
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer()
                
                // Кнопки перемикання “Дата” / “Час” у скрінах – це кастомна логіка
                // Можна зробити 2 DatePicker-и, але для спрощення просто один зі стилем коліщат
                Text("Вибір дати та часу")
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    // Застосувати і закрити
                    isPresented = false
                }) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .background(Color.gray.opacity(0.4))
            
            DatePicker(
                "",
                selection: $date,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .background(Color.black)
            .colorScheme(.dark) // колесо в темній темі
        }
        .background(Color.black)
    }
}

// Форматований рядок дати (приклад: "Сьогодні 20:49" або  "Пт 28/02 18:47")
func formattedDate(_ date: Date) -> String {
    let calendar = Calendar.current
    // Перевіряємо, чи це сьогодні
    if calendar.isDateInToday(date) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return "Сьогодні " + timeFormatter.string(from: date)
    }
    // Перевіряємо, чи це вчора
    if calendar.isDateInYesterday(date) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return "Вчора " + timeFormatter.string(from: date)
    }
    
    // Інакше просто формат: дд/мм час:хв
    let formatter = DateFormatter()
    formatter.dateFormat = "E d/MM HH:mm"
    return formatter.string(from: date)
}
