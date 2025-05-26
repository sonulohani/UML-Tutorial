# Chapter 5: Use Case Diagrams

Use case diagrams are behavioral diagrams that show the functionality of a system from a user's perspective. They capture the requirements of a system by showing how users (actors) interact with the system to achieve specific goals.

## What is a Use Case Diagram?

A **Use Case Diagram** shows:
- **Actors**: Users or external systems that interact with the system
- **Use Cases**: Specific functionality or services the system provides
- **Relationships**: How actors and use cases are connected
- **System Boundary**: What is inside and outside the system

Use case diagrams are primarily used for:
- Requirements gathering and analysis
- System scope definition
- Communication with stakeholders
- Test case planning
- Project planning and estimation

---

## Basic Elements

### 1. Actors

**Definition**: An actor represents a role played by a user or external system that interacts with the system.

**Notation**: Stick figure with a name below

**Types of Actors**:
- **Primary Actors**: Initiate use cases to achieve goals
- **Secondary Actors**: Provide services to the system
- **External Systems**: Other systems that interact with our system

**Examples**:
```plantuml
@startuml
actor Customer
actor "Bank Employee" as BE
actor "Payment Gateway" as PG
@enduml
```

### 2. Use Cases

**Definition**: A use case represents a specific piece of functionality that the system provides to achieve a user goal.

**Notation**: Oval with the use case name inside

**Characteristics**:
- Describes what the system does, not how
- Represents a complete interaction
- Provides value to an actor
- Has a clear beginning and end

**Examples**:
```plantuml
@startuml
usecase "Login to System"
usecase "Place Order"
usecase "Generate Report"
@enduml
```

### 3. System Boundary

**Definition**: A rectangle that defines what is inside the system (use cases) and what is outside (actors).

**Notation**: Rectangle with system name at the top

```plantuml
@startuml
rectangle "Online Banking System" {
  usecase "View Balance"
  usecase "Transfer Money"
  usecase "Pay Bills"
}

actor Customer
Customer --> "View Balance"
@enduml
```

---

## Relationships in Use Case Diagrams

### 1. Association

**Definition**: Shows that an actor participates in a use case.

**Notation**: Solid line connecting actor to use case

```plantuml
@startuml
actor Customer
usecase "Place Order" as UC1

Customer --> UC1
@enduml
```

### 2. Include Relationship

**Definition**: A use case includes another use case as part of its normal flow.

**Notation**: Dashed arrow with `<<include>>` stereotype

**When to use**: When multiple use cases share common functionality

```plantuml
@startuml
usecase "Place Order" as UC1
usecase "Validate Payment" as UC2
usecase "Update Inventory" as UC3

UC1 .> UC2 : <<include>>
UC1 .> UC3 : <<include>>
@enduml
```

### 3. Extend Relationship

**Definition**: A use case extends another use case with additional behavior under certain conditions.

**Notation**: Dashed arrow with `<<extend>>` stereotype

**When to use**: For optional or exceptional behavior

```plantuml
@startuml
usecase "Place Order" as UC1
usecase "Apply Discount" as UC2
usecase "Gift Wrap" as UC3

UC2 .> UC1 : <<extend>>
UC3 .> UC1 : <<extend>>
@enduml
```

### 4. Generalization

**Definition**: Shows that one use case is a specialized version of another.

**Notation**: Solid arrow with triangle pointing to the general use case

```plantuml
@startuml
usecase "Make Payment" as UC1
usecase "Pay by Credit Card" as UC2
usecase "Pay by PayPal" as UC3

UC2 --> UC1
UC3 --> UC1
@enduml
```

---

## Complete Example: Online Banking System

```plantuml
@startuml
left to right direction

actor Customer
actor "Bank Employee" as BE
actor "System Administrator" as SA
actor "External Payment System" as EPS

package "Online Banking System" {
  usecase "Login" as UC1
  usecase "View Account Balance" as UC2
  usecase "Transfer Money" as UC3
  usecase "Pay Bills" as UC4
  usecase "View Transaction History" as UC5
  usecase "Apply for Loan" as UC6
  usecase "Manage Customer Accounts" as UC7
  usecase "Generate Reports" as UC8
  usecase "System Maintenance" as UC9
  usecase "Authenticate User" as UC10
  usecase "Send Notification" as UC11
  usecase "Validate Account" as UC12
  usecase "Process International Transfer" as UC13
}

' Primary Actor Relationships
Customer --> UC1
Customer --> UC2
Customer --> UC3
Customer --> UC4
Customer --> UC5
Customer --> UC6

' Secondary Actor Relationships
BE --> UC7
BE --> UC8
SA --> UC9
EPS --> UC3

' Include Relationships
UC1 .> UC10 : <<include>>
UC2 .> UC10 : <<include>>
UC3 .> UC10 : <<include>>
UC4 .> UC10 : <<include>>
UC5 .> UC10 : <<include>>
UC6 .> UC10 : <<include>>

UC3 .> UC12 : <<include>>
UC4 .> UC12 : <<include>>

' Extend Relationships
UC13 .> UC3 : <<extend>>
UC11 .> UC3 : <<extend>>
UC11 .> UC4 : <<extend>>

' Generalization
UC3 --> "Make Payment"
UC4 --> "Make Payment"

note right of UC13 : Extension point:\nif transfer amount > $10,000\nand destination is international
note right of UC11 : Extension point:\nafter successful transaction
@enduml
```

---

## Real-World Examples

### Example 1: E-Learning Platform

```plantuml
@startuml
left to right direction

actor Student
actor Instructor
actor Administrator

package "E-Learning Platform" {
  usecase "Register Account" as UC1
  usecase "Login" as UC2
  usecase "Browse Courses" as UC3
  usecase "Enroll in Course" as UC4
  usecase "Watch Video" as UC5
  usecase "Take Quiz" as UC6
  usecase "Submit Assignment" as UC7
  usecase "View Progress" as UC8
  usecase "Create Course" as UC9
  usecase "Upload Content" as UC10
  usecase "Grade Assignment" as UC11
  usecase "Manage Users" as UC12
  usecase "Generate Analytics" as UC13
  usecase "Authenticate User" as UC14
  usecase "Send Email Notification" as UC15
}

' Student interactions
Student --> UC1
Student --> UC2
Student --> UC3
Student --> UC4
Student --> UC5
Student --> UC6
Student --> UC7
Student --> UC8

' Instructor interactions
Instructor --> UC2
Instructor --> UC9
Instructor --> UC10
Instructor --> UC11

' Administrator interactions
Administrator --> UC12
Administrator --> UC13

' Include relationships
UC2 .> UC14 : <<include>>
UC4 .> UC14 : <<include>>
UC5 .> UC14 : <<include>>
UC6 .> UC14 : <<include>>
UC7 .> UC14 : <<include>>
UC9 .> UC14 : <<include>>
UC10 .> UC14 : <<include>>
UC11 .> UC14 : <<include>>

' Extend relationships
UC15 .> UC4 : <<extend>>
UC15 .> UC7 : <<extend>>
UC15 .> UC11 : <<extend>>

note right of UC15 : Sends confirmation\nemails for important\nactions
@enduml
```

### Example 2: Hospital Management System

```plantuml
@startuml
left to right direction

actor Patient
actor Doctor
actor Nurse
actor Receptionist
actor "Insurance System" as IS

package "Hospital Management System" {
  usecase "Register Patient" as UC1
  usecase "Schedule Appointment" as UC2
  usecase "Check In" as UC3
  usecase "Conduct Examination" as UC4
  usecase "Prescribe Medication" as UC5
  usecase "Update Medical Record" as UC6
  usecase "Administer Medication" as UC7
  usecase "Record Vital Signs" as UC8
  usecase "Generate Bill" as UC9
  usecase "Process Payment" as UC10
  usecase "Verify Insurance" as UC11
  usecase "Send Appointment Reminder" as UC12
}

' Actor relationships
Patient --> UC1
Patient --> UC2
Patient --> UC3
Patient --> UC10

Doctor --> UC4
Doctor --> UC5
Doctor --> UC6

Nurse --> UC7
Nurse --> UC8

Receptionist --> UC1
Receptionist --> UC2
Receptionist --> UC9

IS --> UC11

' Include relationships
UC2 .> UC11 : <<include>>
UC9 .> UC11 : <<include>>

' Extend relationships
UC12 .> UC2 : <<extend>>

note right of UC12 : Reminder sent 24 hours\nbefore appointment
@enduml
```

---

## Best Practices

### 1. Naming Conventions

**Use Cases**:
- Start with a verb (action)
- Use active voice
- Be specific and clear
- Examples: "Place Order", "Generate Report", "Update Profile"

**Actors**:
- Use nouns representing roles
- Be specific about the role
- Examples: "Customer", "System Administrator", "Payment Gateway"

### 2. Scope and Level

**System Level**: Focus on what the system does for users
- ✅ "Process Order"
- ❌ "Validate Credit Card Number" (too detailed)

**User Goal Level**: Each use case should achieve a user goal
- ✅ "Book Flight"
- ❌ "Click Submit Button" (too low level)

### 3. Actor Guidelines

**Primary vs Secondary Actors**:
- Primary actors initiate use cases
- Secondary actors are called upon by the system

**External Systems as Actors**:
- Treat external systems as actors when they interact with your system
- Examples: Payment Gateway, Email Service, Database

### 4. Relationship Guidelines

**Include Relationships**:
- Use when functionality is always performed
- Common functionality shared by multiple use cases
- Example: Authentication is always required

**Extend Relationships**:
- Use for optional or conditional behavior
- Exceptional flows
- Example: Apply discount (only if customer has coupon)

**Avoid Overuse**:
- Don't create complex hierarchies
- Keep diagrams simple and readable
- Focus on main functionality

---

## Common Mistakes to Avoid

### 1. Functional Decomposition
❌ **Wrong**: Breaking down use cases into implementation steps
```
- "Validate Input"
- "Check Database"
- "Update Record"
- "Send Response"
```

✅ **Correct**: Focus on user goals
```
- "Update Customer Profile"
```

### 2. Too Many Relationships
❌ **Wrong**: Overusing include/extend relationships
✅ **Correct**: Use relationships sparingly and only when necessary

### 3. Implementation Details
❌ **Wrong**: "Save to Database", "Call Web Service"
✅ **Correct**: "Store Customer Information", "Process Payment"

### 4. Missing Actors
❌ **Wrong**: Not identifying all actors who interact with the system
✅ **Correct**: Include all primary and secondary actors

### 5. Vague Use Case Names
❌ **Wrong**: "Manage Data", "Handle Request"
✅ **Correct**: "Update Product Catalog", "Process Refund Request"

---

## Use Case Documentation

While use case diagrams show the overview, each use case should be documented with:

### Basic Template

**Use Case**: Place Order
**Actor**: Customer
**Precondition**: Customer is logged in and has items in cart
**Postcondition**: Order is placed and confirmation is sent

**Main Flow**:
1. Customer selects "Checkout"
2. System displays order summary
3. Customer confirms shipping address
4. Customer selects payment method
5. System processes payment
6. System creates order record
7. System sends confirmation email

**Alternative Flows**:
- 5a. Payment fails: System displays error message
- 3a. Customer changes address: System updates shipping cost

**Exception Flows**:
- System unavailable: Display maintenance message

---

## Tools for Creating Use Case Diagrams

### 1. PlantUML (Text-based)
```plantuml
@startuml
actor User
usecase "Login" as UC1
User --> UC1
@enduml
```

### 2. Draw.io (Visual)
- Free online tool
- Drag and drop interface
- Good for quick diagrams

### 3. Lucidchart (Professional)
- Collaborative editing
- Templates available
- Integration with other tools

### 4. Visual Paradigm (Enterprise)
- Full UML support
- Requirements management
- Code generation capabilities

---

## Integration with Development Process

### 1. Requirements Gathering
- Use case diagrams help identify system scope
- Facilitate discussions with stakeholders
- Ensure all user needs are captured

### 2. Test Planning
- Each use case becomes a test scenario
- Alternative flows become test cases
- Exception flows become error test cases

### 3. Project Planning
- Use cases help estimate development effort
- Prioritize features based on actor importance
- Plan iterations around use case completion

### 4. System Design
- Use cases drive system architecture
- Identify major system components
- Define interfaces between components

---

**Next Chapter**: Continue to [Chapter 6: Sequence Diagrams](./06-sequence-diagrams.md) to learn about modeling interactions over time.

---

**Key Takeaways:**
- Use case diagrams capture system functionality from user perspective
- Focus on what the system does, not how it does it
- Actors represent roles, not specific individuals
- Use relationships (include, extend, generalization) sparingly
- Keep diagrams simple and focused on main functionality
- Document detailed use case flows separately from diagrams 