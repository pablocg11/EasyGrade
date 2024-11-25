# 📚 Easy Grade 📚
Welcome to Easy Grade, a powerful and intuitive app designed to streamline the management of exams.
This application allows you to create, edit, delete, and list exam templates, as well as recognize and correct student answers effortlessly.

# Features ✨

🎓 **Exam Template Management**
- **Create Templates**: Easily define exam templates with customizable options like:
  - Number of questions.
  - Number of answers per question.
  - Scoring rules (correct answer, incorrect answer penalty, unanswered penalty).
- **Edit Templates**: Modify existing templates to fit your needs.
- **Delete Templates**: Remove templates you no longer need.
- **List Templates**: Browse and select from a comprehensive list of your templates.

📸 **Student Answer Recognition**
- Use the device camera to capture an image of a student's exam.
- Recognize and extract the student’s information (name, ID) and their answers using text recognition.

📊 **Exam Correction**
- Automatically correct student answers based on the selected template.
- Apply scoring rules to calculate a normalized score.
- Visualize the correction progress with smooth animations.

# Tech Stack 🛠️

📱 **SwiftUI**
- Modern UI: SwiftUI powers the user interface with a clean, declarative, and dynamic design.
- Navigation: Intuitive navigation between screens using NavigationView and NavigationLink.

💾 **CoreData**
- Data Management: CoreData handles all exam template data, ensuring persistence and seamless integration.
- CRUD Operations: Create, Read, Update, and Delete exam templates directly from the app.

🤖 **Vision Framework**
- Text Recognition: Leverages Apple's Vision framework to recognize text from captured images, including student information and answers.

🎨 **Animations**
- Progress Visualization: Animated circular progress bars provide a visually appealing way to display correction progress.
