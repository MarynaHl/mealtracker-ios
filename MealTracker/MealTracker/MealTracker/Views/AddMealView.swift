import SwiftUI

struct AddMealView: View {
    @ObservedObject var viewModel: MealsViewModel
    
    // Поля для прийому їжі
    @State private var name: String = "Прийом їжі"
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
    @State private var selectedColor: Color = .blue
    @State private var note: String = ""
    
    // Керування нотаткою
    @State private var showNoteEditor: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Початок
                Text("Початок")
                    .font(.subheadline)
                DatePicker("", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                
                // Кінець
                Text("Кінець")
                    .font(.subheadline)
                DatePicker("", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                
                // Поле для назви
                Text("Назва/Тип прийому")
                    .font(.subheadline)
                TextField("Наприклад, Сніданок", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Вибір кольору (простий приклад з декількома кольорами)
                Text("Колір:")
                    .font(.subheadline)
                HStack {
                    ForEach([Color.blue, Color.green, Color.orange, Color.red, Color.purple, Color.yellow], id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: selectedColor == color ? 2 : 0)
                            )
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }
                .padding(.bottom, 8)
                
                // Нотатка
                Button(action: {
                    showNoteEditor = true
                }) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("Додати нотатку")
                    }
                }
                .padding(.bottom, 8)
                .sheet(isPresented: $showNoteEditor) {
                    NoteEditorView(note: $note)
                }
                
                // Кнопка "Зберегти"
                Button(action: {
                    saveMeal()
                }) {
                    Text("Зберегти")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 16)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Новий Прийом Їжі", displayMode: .inline)
            .toolbar {
                // Кнопка "Закрити", якщо треба
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрити") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveMeal() {
        // Створюємо Meal
        let meal = Meal(
            name: name.isEmpty ? "Прийом їжі" : name,
            startDate: startDate,
            endDate: endDate,
            color: selectedColor,
            note: note
        )
        // Додаємо у ViewModel
        viewModel.addMeal(meal: meal)
        // Закриваємо вікно
        presentationMode.wrappedValue.dismiss()
    }
}

// Окремий екран для редагування нотатки
struct NoteEditorView: View {
    @Binding var note: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $note)
                    .padding()
                Button("Готово") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationBarTitle("Нотатка", displayMode: .inline)
        }
    }
}
