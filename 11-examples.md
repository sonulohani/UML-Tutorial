# Chapter 11: Examples and Case Studies

This chapter provides comprehensive real-world examples that demonstrate how to apply UML concepts in practice. Each example includes multiple diagram types to show different perspectives of the same system.

---

## Case Study 1: Online Banking System

### System Overview
An online banking system that allows customers to manage their accounts, transfer money, pay bills, and view transaction history.

### 1.1 Use Case Diagram

```plantuml
@startuml
left to right direction

actor Customer
actor BankEmployee
actor SystemAdmin

package "Online Banking System" {
  usecase "Login" as UC1
  usecase "View Account Balance" as UC2
  usecase "Transfer Money" as UC3
  usecase "Pay Bills" as UC4
  usecase "View Transaction History" as UC5
  usecase "Manage Customer Accounts" as UC6
  usecase "Generate Reports" as UC7
  usecase "System Maintenance" as UC8
  usecase "Authenticate User" as UC9
}

Customer --> UC1
Customer --> UC2
Customer --> UC3
Customer --> UC4
Customer --> UC5

BankEmployee --> UC6
BankEmployee --> UC7

SystemAdmin --> UC8

UC1 .> UC9 : <<include>>
UC2 .> UC9 : <<include>>
UC3 .> UC9 : <<include>>
UC4 .> UC9 : <<include>>
UC5 .> UC9 : <<include>>
@enduml
```

### 1.2 Class Diagram

```plantuml
@startuml
class Customer {
  - customerId: String
  - firstName: String
  - lastName: String
  - email: String
  - phoneNumber: String
  - address: Address
  - dateOfBirth: Date
  
  + Customer(firstName: String, lastName: String, email: String)
  + getFullName(): String
  + updateContactInfo(email: String, phone: String): void
  + addAccount(account: Account): void
}

abstract class Account {
  # accountNumber: String
  # balance: double
  # accountType: AccountType
  # dateOpened: Date
  # isActive: boolean
  
  + Account(accountNumber: String, initialBalance: double)
  + getBalance(): double
  + deposit(amount: double): void
  + {abstract} withdraw(amount: double): boolean
  + getTransactionHistory(): List<Transaction>
}

class CheckingAccount {
  - overdraftLimit: double
  - monthlyFee: double
  
  + CheckingAccount(accountNumber: String, initialBalance: double)
  + withdraw(amount: double): boolean
  + chargeMonthlyFee(): void
}

class SavingsAccount {
  - interestRate: double
  - minimumBalance: double
  
  + SavingsAccount(accountNumber: String, initialBalance: double)
  + withdraw(amount: double): boolean
  + calculateInterest(): double
  + applyInterest(): void
}

class Transaction {
  - transactionId: String
  - amount: double
  - transactionType: TransactionType
  - timestamp: DateTime
  - description: String
  - fromAccount: Account
  - toAccount: Account
  
  + Transaction(amount: double, type: TransactionType, fromAccount: Account)
  + execute(): boolean
  + reverse(): boolean
}

class Address {
  - street: String
  - city: String
  - state: String
  - zipCode: String
  - country: String
  
  + Address(street: String, city: String, state: String, zipCode: String)
  + toString(): String
  + validate(): boolean
}

enum AccountType {
  CHECKING
  SAVINGS
  CREDIT
  LOAN
}

enum TransactionType {
  DEPOSIT
  WITHDRAWAL
  TRANSFER
  BILL_PAYMENT
  FEE
  INTEREST
}

class BankingService {
  - accounts: Map<String, Account>
  - customers: Map<String, Customer>
  
  + transferMoney(fromAccount: String, toAccount: String, amount: double): boolean
  + payBill(account: String, payee: String, amount: double): boolean
  + getAccountBalance(accountNumber: String): double
  + getTransactionHistory(accountNumber: String): List<Transaction>
}

class AuthenticationService {
  - userCredentials: Map<String, String>
  
  + authenticate(username: String, password: String): boolean
  + changePassword(username: String, oldPassword: String, newPassword: String): boolean
  + lockAccount(username: String): void
}

' Relationships
Customer "1" -- "1..*" Account : owns
Account <|-- CheckingAccount
Account <|-- SavingsAccount
Account "1" -- "*" Transaction : has
Customer "1" -- "1" Address : lives at
BankingService ..> Account : manages
BankingService ..> Transaction : processes
AuthenticationService ..> Customer : authenticates
@enduml
```

### 1.3 Sequence Diagram: Money Transfer

```plantuml
@startuml
actor Customer
participant "Web Interface" as UI
participant "BankingService" as BS
participant "AuthService" as Auth
participant "FromAccount" as FA
participant "ToAccount" as TA
participant "Transaction" as T

Customer -> UI: initiateTransfer(fromAccount, toAccount, amount)
UI -> Auth: authenticate(customerId)
Auth --> UI: authenticationResult

alt authentication successful
  UI -> BS: transferMoney(fromAccount, toAccount, amount)
  BS -> FA: checkBalance(amount)
  FA --> BS: balanceAvailable
  
  alt sufficient balance
    BS -> T: new Transaction(amount, TRANSFER, fromAccount, toAccount)
    BS -> FA: withdraw(amount)
    FA --> BS: withdrawalSuccess
    BS -> TA: deposit(amount)
    TA --> BS: depositSuccess
    BS -> T: execute()
    T --> BS: transactionComplete
    BS --> UI: transferSuccess
    UI --> Customer: displayConfirmation()
  else insufficient balance
    BS --> UI: insufficientFunds
    UI --> Customer: displayError("Insufficient funds")
  end
else authentication failed
  Auth --> UI: authenticationFailed
  UI --> Customer: displayError("Authentication failed")
end
@enduml
```

### 1.4 Activity Diagram: Account Opening Process

```plantuml
@startuml
start

:Customer submits application;
:Verify customer identity;

if (Identity verified?) then (yes)
  :Check credit history;
  if (Credit check passed?) then (yes)
    :Create customer profile;
    :Generate account number;
    :Set initial deposit;
    :Activate account;
    :Send welcome package;
    :Account opened successfully;
    stop
  else (no)
    :Send rejection letter;
    :Application rejected;
    stop
  endif
else (no)
  :Request additional documentation;
  :Customer provides documents;
  :Re-verify identity;
  if (Re-verification successful?) then (yes)
    :Proceed with application;
  else (no)
    :Application rejected;
    stop
  endif
endif
@enduml
```

---

## Case Study 2: E-Learning Platform

### System Overview
An online learning platform where students can enroll in courses, watch videos, take quizzes, and track their progress.

### 2.1 Use Case Diagram

```plantuml
@startuml
left to right direction

actor Student
actor Instructor
actor Administrator

package "E-Learning Platform" {
  usecase "Register/Login" as UC1
  usecase "Browse Courses" as UC2
  usecase "Enroll in Course" as UC3
  usecase "Watch Videos" as UC4
  usecase "Take Quiz" as UC5
  usecase "View Progress" as UC6
  usecase "Create Course" as UC7
  usecase "Upload Content" as UC8
  usecase "Grade Assignments" as UC9
  usecase "Manage Users" as UC10
  usecase "Generate Reports" as UC11
  usecase "System Configuration" as UC12
}

Student --> UC1
Student --> UC2
Student --> UC3
Student --> UC4
Student --> UC5
Student --> UC6

Instructor --> UC1
Instructor --> UC7
Instructor --> UC8
Instructor --> UC9

Administrator --> UC10
Administrator --> UC11
Administrator --> UC12

UC3 .> UC1 : <<include>>
UC4 .> UC3 : <<include>>
UC5 .> UC3 : <<include>>
@enduml
```

### 2.2 Class Diagram

```plantuml
@startuml
abstract class User {
  # userId: String
  # username: String
  # email: String
  # password: String
  # registrationDate: Date
  # isActive: boolean
  
  + User(username: String, email: String, password: String)
  + login(username: String, password: String): boolean
  + updateProfile(email: String): void
  + {abstract} getRole(): UserRole
}

class Student {
  - studentId: String
  - enrollmentDate: Date
  - totalCredits: int
  
  + Student(username: String, email: String, password: String)
  + enrollInCourse(course: Course): boolean
  + getEnrolledCourses(): List<Course>
  + getProgress(course: Course): Progress
  + getRole(): UserRole
}

class Instructor {
  - instructorId: String
  - department: String
  - bio: String
  - qualifications: List<String>
  
  + Instructor(username: String, email: String, password: String)
  + createCourse(title: String, description: String): Course
  + uploadContent(course: Course, content: Content): void
  + gradeAssignment(assignment: Assignment, grade: double): void
  + getRole(): UserRole
}

class Course {
  - courseId: String
  - title: String
  - description: String
  - duration: int
  - difficulty: DifficultyLevel
  - price: double
  - isPublished: boolean
  - creationDate: Date
  
  + Course(title: String, description: String, instructor: Instructor)
  + addContent(content: Content): void
  + removeContent(content: Content): void
  + publish(): void
  + getEnrollmentCount(): int
}

abstract class Content {
  # contentId: String
  # title: String
  # description: String
  # duration: int
  # order: int
  # isPublished: boolean
  
  + Content(title: String, description: String)
  + {abstract} getContentType(): ContentType
  + updateContent(title: String, description: String): void
}

class Video {
  - videoUrl: String
  - resolution: String
  - fileSize: long
  - transcript: String
  
  + Video(title: String, description: String, videoUrl: String)
  + getContentType(): ContentType
  + updateVideoUrl(url: String): void
}

class Quiz {
  - timeLimit: int
  - passingScore: double
  - maxAttempts: int
  
  + Quiz(title: String, description: String)
  + addQuestion(question: Question): void
  + removeQuestion(question: Question): void
  + getContentType(): ContentType
}

class Question {
  - questionId: String
  - questionText: String
  - questionType: QuestionType
  - points: double
  - correctAnswer: String
  - options: List<String>
  
  + Question(questionText: String, type: QuestionType, points: double)
  + addOption(option: String): void
  + setCorrectAnswer(answer: String): void
}

class Enrollment {
  - enrollmentId: String
  - enrollmentDate: Date
  - completionDate: Date
  - status: EnrollmentStatus
  - finalGrade: double
  
  + Enrollment(student: Student, course: Course)
  + updateProgress(content: Content): void
  + calculateProgress(): double
  + complete(): void
}

class Progress {
  - progressId: String
  - completedContent: List<Content>
  - currentContent: Content
  - progressPercentage: double
  - lastAccessDate: Date
  
  + Progress(enrollment: Enrollment)
  + markContentComplete(content: Content): void
  + getCurrentProgress(): double
}

enum UserRole {
  STUDENT
  INSTRUCTOR
  ADMINISTRATOR
}

enum DifficultyLevel {
  BEGINNER
  INTERMEDIATE
  ADVANCED
}

enum ContentType {
  VIDEO
  QUIZ
  ASSIGNMENT
  READING
}

enum QuestionType {
  MULTIPLE_CHOICE
  TRUE_FALSE
  SHORT_ANSWER
  ESSAY
}

enum EnrollmentStatus {
  ACTIVE
  COMPLETED
  DROPPED
  SUSPENDED
}

' Relationships
User <|-- Student
User <|-- Instructor
Course "1" -- "1" Instructor : created by
Course "1" *-- "*" Content : contains
Content <|-- Video
Content <|-- Quiz
Quiz "1" *-- "*" Question : contains
Student "*" -- "*" Course : enrolls
(Student, Course) .. Enrollment
Enrollment "1" -- "1" Progress : tracks
@enduml
```

### 2.3 State Diagram: Course Lifecycle

```plantuml
@startuml
[*] --> Draft : create course

Draft --> InReview : submit for review
Draft --> Draft : edit content

InReview --> Published : approve
InReview --> Draft : reject

Published --> Archived : archive
Published --> Published : update content

Archived --> Published : reactivate
Archived --> [*] : delete

note right of Draft : Instructor can edit\nand add content
note right of InReview : Admin reviews\ncourse content
note right of Published : Students can\nenroll and access
note right of Archived : Read-only access\nfor enrolled students
@enduml
```

---

## Case Study 3: Hospital Management System

### System Overview
A comprehensive hospital management system for managing patients, doctors, appointments, medical records, and billing.

### 3.1 Class Diagram

```plantuml
@startuml
abstract class Person {
  # personId: String
  # firstName: String
  # lastName: String
  # dateOfBirth: Date
  # gender: Gender
  # phoneNumber: String
  # address: Address
  
  + Person(firstName: String, lastName: String, dateOfBirth: Date)
  + getFullName(): String
  + getAge(): int
  + updateContactInfo(phone: String, address: Address): void
}

class Patient {
  - patientId: String
  - bloodType: BloodType
  - allergies: List<String>
  - emergencyContact: Contact
  - insuranceInfo: Insurance
  
  + Patient(firstName: String, lastName: String, dateOfBirth: Date)
  + addAllergy(allergy: String): void
  + getMedicalHistory(): List<MedicalRecord>
  + scheduleAppointment(doctor: Doctor, dateTime: DateTime): Appointment
}

class Doctor {
  - doctorId: String
  - licenseNumber: String
  - specialization: Specialization
  - department: Department
  - yearsOfExperience: int
  - consultationFee: double
  
  + Doctor(firstName: String, lastName: String, specialization: Specialization)
  + getAvailableSlots(date: Date): List<TimeSlot>
  + prescribeMedication(patient: Patient, medication: Medication): Prescription
  + createMedicalRecord(patient: Patient, diagnosis: String): MedicalRecord
}

class Nurse {
  - nurseId: String
  - licenseNumber: String
  - shift: Shift
  - department: Department
  
  + Nurse(firstName: String, lastName: String, department: Department)
  + administerMedication(patient: Patient, medication: Medication): void
  + recordVitalSigns(patient: Patient, vitals: VitalSigns): void
}

class Appointment {
  - appointmentId: String
  - dateTime: DateTime
  - duration: int
  - status: AppointmentStatus
  - reason: String
  - notes: String
  
  + Appointment(patient: Patient, doctor: Doctor, dateTime: DateTime)
  + reschedule(newDateTime: DateTime): void
  + cancel(): void
  + complete(): void
}

class MedicalRecord {
  - recordId: String
  - visitDate: Date
  - diagnosis: String
  - symptoms: List<String>
  - treatment: String
  - notes: String
  
  + MedicalRecord(patient: Patient, doctor: Doctor, diagnosis: String)
  + addSymptom(symptom: String): void
  + updateTreatment(treatment: String): void
}

class Prescription {
  - prescriptionId: String
  - dateIssued: Date
  - instructions: String
  - refillsRemaining: int
  
  + Prescription(doctor: Doctor, patient: Patient)
  + addMedication(medication: Medication, dosage: String): void
  + refill(): boolean
}

class Medication {
  - medicationId: String
  - name: String
  - genericName: String
  - manufacturer: String
  - dosageForm: DosageForm
  - strength: String
  
  + Medication(name: String, genericName: String, strength: String)
  + checkInteractions(otherMedications: List<Medication>): List<String>
}

class Department {
  - departmentId: String
  - name: String
  - location: String
  - headOfDepartment: Doctor
  
  + Department(name: String, location: String)
  + addDoctor(doctor: Doctor): void
  + addNurse(nurse: Nurse): void
  + getStaff(): List<Person>
}

class Room {
  - roomNumber: String
  - roomType: RoomType
  - capacity: int
  - isOccupied: boolean
  - dailyRate: double
  
  + Room(roomNumber: String, roomType: RoomType, capacity: int)
  + assignPatient(patient: Patient): void
  + releasePatient(): void
}

class Bill {
  - billId: String
  - billDate: Date
  - totalAmount: double
  - paidAmount: double
  - status: BillStatus
  - dueDate: Date
  
  + Bill(patient: Patient)
  + addCharge(description: String, amount: double): void
  + makePayment(amount: double): void
  + calculateBalance(): double
}

enum Gender {
  MALE
  FEMALE
  OTHER
}

enum BloodType {
  A_POSITIVE
  A_NEGATIVE
  B_POSITIVE
  B_NEGATIVE
  AB_POSITIVE
  AB_NEGATIVE
  O_POSITIVE
  O_NEGATIVE
}

enum Specialization {
  CARDIOLOGY
  NEUROLOGY
  ORTHOPEDICS
  PEDIATRICS
  SURGERY
  INTERNAL_MEDICINE
}

enum AppointmentStatus {
  SCHEDULED
  CONFIRMED
  IN_PROGRESS
  COMPLETED
  CANCELLED
  NO_SHOW
}

enum RoomType {
  GENERAL
  PRIVATE
  ICU
  EMERGENCY
  SURGERY
}

enum BillStatus {
  PENDING
  PARTIALLY_PAID
  PAID
  OVERDUE
}

' Relationships
Person <|-- Patient
Person <|-- Doctor
Person <|-- Nurse

Patient "1" -- "*" Appointment : schedules
Doctor "1" -- "*" Appointment : attends
Patient "1" -- "*" MedicalRecord : has
Doctor "1" -- "*" MedicalRecord : creates
Doctor "1" -- "*" Prescription : writes
Patient "1" -- "*" Prescription : receives
Prescription "*" -- "*" Medication : contains
Department "1" -- "*" Doctor : employs
Department "1" -- "*" Nurse : employs
Patient "*" -- "0..1" Room : occupies
Patient "1" -- "*" Bill : receives
@enduml
```

### 3.2 Sequence Diagram: Patient Appointment Booking

```plantuml
@startuml
actor Patient
participant "Booking System" as BS
participant "Doctor Schedule" as DS
participant "Appointment" as A
participant "Notification Service" as NS

Patient -> BS: requestAppointment(doctorId, preferredDate)
BS -> DS: getAvailableSlots(doctorId, preferredDate)
DS --> BS: availableSlots

BS --> Patient: displayAvailableSlots(slots)
Patient -> BS: selectSlot(selectedDateTime)

BS -> A: createAppointment(patient, doctor, dateTime)
A --> BS: appointmentCreated

BS -> NS: sendConfirmation(patient, appointmentDetails)
NS --> Patient: confirmationEmail
NS -> DS: blockTimeSlot(doctor, dateTime)

BS --> Patient: bookingConfirmation(appointmentId)
@enduml
```

---

## Case Study 4: Social Media Platform

### 4.1 Class Diagram

```plantuml
@startuml
class User {
  - userId: String
  - username: String
  - email: String
  - passwordHash: String
  - firstName: String
  - lastName: String
  - profilePicture: String
  - bio: String
  - joinDate: Date
  - isVerified: boolean
  - privacySettings: PrivacySettings
  
  + User(username: String, email: String, password: String)
  + createPost(content: String, mediaFiles: List<Media>): Post
  + followUser(user: User): void
  + unfollowUser(user: User): void
  + likePost(post: Post): void
  + commentOnPost(post: Post, content: String): Comment
}

class Post {
  - postId: String
  - content: String
  - timestamp: DateTime
  - likesCount: int
  - commentsCount: int
  - sharesCount: int
  - isPublic: boolean
  
  + Post(author: User, content: String)
  + addMedia(media: Media): void
  + like(user: User): void
  + unlike(user: User): void
  + share(user: User): void
  + delete(): void
}

class Comment {
  - commentId: String
  - content: String
  - timestamp: DateTime
  - likesCount: int
  
  + Comment(author: User, post: Post, content: String)
  + like(user: User): void
  + reply(user: User, content: String): Comment
  + edit(newContent: String): void
}

class Media {
  - mediaId: String
  - fileName: String
  - fileType: MediaType
  - fileSize: long
  - uploadDate: DateTime
  - url: String
  - altText: String
  
  + Media(fileName: String, fileType: MediaType, url: String)
  + generateThumbnail(): String
  + compress(): void
}

class Friendship {
  - friendshipId: String
  - requestDate: DateTime
  - acceptedDate: DateTime
  - status: FriendshipStatus
  
  + Friendship(requester: User, recipient: User)
  + accept(): void
  + decline(): void
  + block(): void
}

class Group {
  - groupId: String
  - name: String
  - description: String
  - creationDate: Date
  - isPrivate: boolean
  - memberCount: int
  
  + Group(name: String, description: String, creator: User)
  + addMember(user: User): void
  + removeMember(user: User): void
  + createPost(author: User, content: String): Post
}

class Message {
  - messageId: String
  - content: String
  - timestamp: DateTime
  - isRead: boolean
  - messageType: MessageType
  
  + Message(sender: User, recipient: User, content: String)
  + markAsRead(): void
  + recall(): void
}

class Notification {
  - notificationId: String
  - type: NotificationType
  - message: String
  - timestamp: DateTime
  - isRead: boolean
  
  + Notification(user: User, type: NotificationType, message: String)
  + markAsRead(): void
  + dismiss(): void
}

enum MediaType {
  IMAGE
  VIDEO
  AUDIO
  DOCUMENT
}

enum FriendshipStatus {
  PENDING
  ACCEPTED
  BLOCKED
  DECLINED
}

enum MessageType {
  TEXT
  MEDIA
  VOICE
  VIDEO_CALL
}

enum NotificationType {
  LIKE
  COMMENT
  FRIEND_REQUEST
  MESSAGE
  MENTION
  GROUP_INVITATION
}

' Relationships
User "1" -- "*" Post : creates
User "1" -- "*" Comment : writes
Post "1" -- "*" Comment : has
Post "1" -- "*" Media : contains
User "*" -- "*" User : follows
User "*" -- "*" Group : member of
Group "1" -- "*" Post : contains
User "1" -- "*" Message : sends
User "1" -- "*" Message : receives
User "1" -- "*" Notification : receives
User "*" -- "*" User : friends
(User, User) .. Friendship
@enduml
```

---

## Best Practices Demonstrated

### 1. Consistent Naming Conventions
- Classes use PascalCase: `BankingService`, `MedicalRecord`
- Attributes use camelCase: `firstName`, `accountNumber`
- Methods use camelCase: `calculateBalance()`, `updateProfile()`

### 2. Appropriate Relationships
- **Composition**: `Course *-- Content` (content belongs to course)
- **Aggregation**: `Department o-- Doctor` (doctors can change departments)
- **Inheritance**: `User <|-- Student` (student is a type of user)
- **Association**: `Patient -- Appointment` (patients have appointments)

### 3. Proper Use of Enums
- Defined clear enumeration types for status fields
- Used descriptive names for enum values
- Grouped related constants together

### 4. Abstraction and Interfaces
- Used abstract classes for common behavior: `Person`, `Account`, `Content`
- Defined clear inheritance hierarchies
- Separated interface from implementation

### 5. Multiplicity Specification
- Always specified relationship multiplicities
- Used appropriate cardinalities: `1`, `*`, `0..1`, `1..*`
- Considered real-world constraints

---

## Common Patterns in Examples

### 1. User Management Pattern
```
User (abstract) -> Student, Instructor, Doctor, Patient
```

### 2. Content Management Pattern
```
Content (abstract) -> Video, Quiz, Document
```

### 3. Transaction Pattern
```
Transaction -> Account (from/to)
```

### 4. Audit Trail Pattern
```
Entity -> History/Log records
```

### 5. Status Management Pattern
```
Entity -> Status (enum)
```

---

## Key Takeaways

1. **Start with Use Cases**: Always begin by understanding what the system should do
2. **Model Real Relationships**: Ensure relationships reflect real-world constraints
3. **Use Appropriate Abstractions**: Abstract common behavior into base classes
4. **Consider Lifecycle**: Model how objects change state over time
5. **Keep It Focused**: Each diagram should have a clear purpose
6. **Validate with Stakeholders**: Ensure diagrams accurately represent requirements
7. **Iterate and Refine**: UML diagrams evolve as understanding improves

---

**Conclusion**: These examples demonstrate how UML can be used to model complex real-world systems. The key is to choose the right diagrams for your audience and purpose, maintain consistency, and focus on clarity over completeness.

---

**Practice**: Try creating your own UML diagrams for systems you're familiar with, such as:
- Library management system
- Restaurant ordering system
- Hotel reservation system
- Inventory management system
- Student information system 