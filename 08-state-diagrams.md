# Chapter 8: State Diagrams

State diagrams (also called State Machine diagrams) are behavioral diagrams that show how an object changes state in response to events. They model the lifecycle of objects and the dynamic behavior of systems by showing states, transitions, and the events that trigger them.

## What is a State Diagram?

A **State Diagram** shows:
- **States**: Conditions or situations during an object's lifetime
- **Transitions**: Changes from one state to another
- **Events**: Triggers that cause transitions
- **Guards**: Conditions that must be true for transitions
- **Actions**: Activities performed during transitions or in states

State diagrams are primarily used for:
- Object lifecycle modeling
- Protocol specification
- User interface behavior
- System state management
- Reactive system design

---

## Basic Elements

### 1. States

**Definition**: A condition or situation during the life of an object

**Notation**: Rounded rectangle with state name

**Types of States**:
- **Simple State**: Basic state with no internal structure
- **Composite State**: State containing other states
- **Initial State**: Black filled circle - starting point
- **Final State**: Black filled circle with border - ending point

```plantuml
@startuml
[*] --> Idle
Idle --> Processing
Processing --> Complete
Complete --> [*]
@enduml
```

### 2. Transitions

**Definition**: Change from one state to another

**Notation**: Arrow between states

**Syntax**: `event [guard] / action`

```plantuml
@startuml
[*] --> Off
Off --> On : powerOn
On --> Off : powerOff
On --> Standby : idle [timeout > 30min] / saveState
Standby --> On : activity
@enduml
```

### 3. Events

**Definition**: Occurrences that trigger state transitions

**Types**:
- **Signal Events**: External signals
- **Call Events**: Method calls
- **Time Events**: Time-based triggers
- **Change Events**: Condition changes

### 4. Guards

**Definition**: Boolean conditions that must be true for transition

**Notation**: Square brackets `[condition]`

### 5. Actions

**Definition**: Activities performed during transitions

**Types**:
- **Entry Actions**: Performed when entering a state
- **Exit Actions**: Performed when leaving a state
- **Transition Actions**: Performed during transition

---

## State Types and Notation

### 1. Simple States

```plantuml
@startuml
state "Waiting for Input" as Waiting
state "Processing Data" as Processing
state "Displaying Result" as Display

[*] --> Waiting
Waiting --> Processing : inputReceived
Processing --> Display : processingComplete
Display --> Waiting : userAcknowledge
Display --> [*] : exit
@enduml
```

### 2. States with Internal Activities

```plantuml
@startuml
state Processing {
  Processing : entry / startTimer
  Processing : do / processData
  Processing : exit / stopTimer
}

[*] --> Processing
Processing --> [*] : complete
@enduml
```

### 3. Composite States (Nested States)

```plantuml
@startuml
state "Order Processing" as OrderProc {
  [*] --> Validating
  Validating --> PaymentProcessing : valid
  PaymentProcessing --> Fulfillment : paymentApproved
  Fulfillment --> [*] : shipped
  
  Validating --> [*] : invalid
  PaymentProcessing --> [*] : paymentFailed
}

[*] --> OrderProc
OrderProc --> [*]
@enduml
```

### 4. Concurrent States (Parallel Regions)

```plantuml
@startuml
state "Media Player" as Player {
  state "Audio Control" as Audio {
    [*] --> AudioOff
    AudioOff --> AudioOn : play
    AudioOn --> AudioOff : stop
  }
  
  state "Video Control" as Video {
    [*] --> VideoOff
    VideoOff --> VideoOn : play
    VideoOn --> VideoOff : stop
  }
}

[*] --> Player
Player --> [*] : shutdown
@enduml
```

---

## Complete Example: Order State Machine

```plantuml
@startuml
title Order Lifecycle State Machine

[*] --> Draft

state Draft {
  Draft : entry / createOrderId
  Draft : do / validateItems
}

state "Under Review" as Review {
  Review : entry / notifyReviewer
  Review : do / performChecks
}

state "Payment Processing" as Payment {
  state "Awaiting Payment" as AwaitPay
  state "Processing Payment" as ProcPay
  state "Payment Verified" as PayVerified
  
  [*] --> AwaitPay
  AwaitPay --> ProcPay : paymentSubmitted
  ProcPay --> PayVerified : paymentApproved
  ProcPay --> AwaitPay : paymentFailed
  PayVerified --> [*]
}

state Fulfillment {
  state "Picking Items" as Picking
  state "Packing" as Packing
  state "Shipping" as Shipping
  
  [*] --> Picking
  Picking --> Packing : itemsPicked
  Packing --> Shipping : packed
  Shipping --> [*] : shipped
}

state Delivered {
  Delivered : entry / sendDeliveryNotification
  Delivered : do / trackDelivery
}

state Cancelled {
  Cancelled : entry / processRefund
  Cancelled : entry / notifyCustomer
}

state Completed {
  Completed : entry / archiveOrder
  Completed : entry / updateAnalytics
}

' Transitions
Draft --> Review : submit [itemsValid]
Draft --> Cancelled : cancel

Review --> Payment : approved
Review --> Draft : rejected / addComments
Review --> Cancelled : cancel

Payment --> Fulfillment : paymentComplete
Payment --> Cancelled : cancel [refundable]

Fulfillment --> Delivered : shipped
Fulfillment --> Cancelled : cancel [beforeShipping]

Delivered --> Completed : confirmed
Delivered --> Cancelled : returnRequested [withinReturnPeriod]

Cancelled --> [*]
Completed --> [*]

note right of Draft : Customer can modify\norder details
note right of Review : Business rules\nvalidation
note right of Payment : Multiple payment\nattempts allowed
note right of Fulfillment : Inventory allocation\nand shipping
@enduml
```

---

## Real-World Examples

### Example 1: User Session State Machine

```plantuml
@startuml
title User Session Management

[*] --> Anonymous

state Anonymous {
  Anonymous : entry / createSessionId
  Anonymous : do / trackActivity
}

state "Logging In" as Login {
  Login : entry / showLoginForm
  Login : do / validateCredentials
}

state Authenticated {
  state "Active Session" as Active {
    Active : entry / loadUserProfile
    Active : do / trackUserActivity
    Active : exit / saveUserState
  }
  
  state "Session Warning" as Warning {
    Warning : entry / showTimeoutWarning
    Warning : do / countdownTimer
  }
  
  [*] --> Active
  Active --> Warning : inactivityTimeout [warningThreshold]
  Warning --> Active : userActivity
  Warning --> [*] : timeoutExpired
}

state "Logged Out" as LoggedOut {
  LoggedOut : entry / clearSession
  LoggedOut : entry / redirectToHome
}

' Transitions
Anonymous --> Login : loginAttempt
Login --> Authenticated : credentialsValid
Login --> Anonymous : credentialsFailed [attempts < 3]
Login --> LoggedOut : credentialsFailed [attempts >= 3] / lockAccount

Authenticated --> LoggedOut : logout
Authenticated --> LoggedOut : sessionExpired
Authenticated --> Anonymous : sessionInvalidated

LoggedOut --> Anonymous : newSession
LoggedOut --> [*] : browserClosed
@enduml
```

### Example 2: ATM Transaction State Machine

```plantuml
@startuml
title ATM Transaction State Machine

[*] --> Idle

state Idle {
  Idle : entry / displayWelcome
  Idle : do / waitForCard
}

state "Card Inserted" as CardIn {
  CardIn : entry / readCard
  CardIn : do / validateCard
}

state "PIN Entry" as PINEntry {
  PINEntry : entry / promptPIN
  PINEntry : do / maskInput
  PINEntry : exit / clearPINDisplay
}

state "Menu Selection" as Menu {
  Menu : entry / displayMenu
  Menu : do / waitForSelection
}

state "Transaction Processing" as Processing {
  state "Balance Inquiry" as Balance {
    Balance : do / queryBalance
    Balance : exit / displayBalance
  }
  
  state "Cash Withdrawal" as Withdrawal {
    state "Amount Entry" as AmountEntry
    state "Dispensing Cash" as Dispensing
    
    [*] --> AmountEntry
    AmountEntry --> Dispensing : amountValid [sufficientFunds]
    Dispensing --> [*] : cashDispensed
  }
  
  state "Deposit" as Deposit {
    Deposit : do / acceptDeposit
    Deposit : exit / updateBalance
  }
}

state "Transaction Complete" as Complete {
  Complete : entry / printReceipt
  Complete : do / askAnotherTransaction
}

state "Card Ejected" as CardOut {
  CardOut : entry / ejectCard
  CardOut : do / waitForCardRemoval
}

state "Error State" as Error {
  Error : entry / displayError
  Error : entry / logError
  Error : do / waitForTimeout
}

' Main flow transitions
Idle --> CardIn : cardInserted
CardIn --> PINEntry : cardValid
CardIn --> Error : cardInvalid / retainCard

PINEntry --> Menu : pinCorrect
PINEntry --> PINEntry : pinIncorrect [attempts < 3]
PINEntry --> Error : pinIncorrect [attempts >= 3] / retainCard

Menu --> Processing : optionSelected
Processing --> Complete : transactionSuccessful
Processing --> Error : transactionFailed

Complete --> Menu : anotherTransaction
Complete --> CardOut : finished

CardOut --> Idle : cardRemoved
CardOut --> Error : timeout [cardNotRemoved]

Error --> Idle : timeout / reset
Error --> [*] : criticalError / shutdown

note right of PINEntry : Maximum 3 attempts\nallowed
note right of Processing : Different transaction\ntypes handled
note right of Error : Logs all errors\nfor audit trail
@enduml
```

---

## Advanced State Machine Concepts

### 1. History States

Remember the last active substate when re-entering a composite state.

```plantuml
@startuml
state "Media Player" as Player {
  state Playing
  state Paused
  state Stopped
  
  state History <<history,type=shallow>>
  
  [*] --> Stopped
  Stopped --> Playing : play
  Playing --> Paused : pause
  Paused --> Playing : resume
  Playing --> Stopped : stop
  Paused --> Stopped : stop
  
  Player --> History : resume
}

[*] --> Player
Player --> [*] : exit
@enduml
```

### 2. Junction and Choice Points

**Junction**: Static conditional branching
**Choice**: Dynamic conditional branching

```plantuml
@startuml
state choice1 <<choice>>
state junction1 <<junction>>

[*] --> choice1
choice1 --> StateA : [condition1]
choice1 --> StateB : [condition2]
choice1 --> StateC : [else]

StateA --> junction1
StateB --> junction1
junction1 --> StateD : [always]
@enduml
```

### 3. Entry and Exit Points

Define specific entry and exit points for composite states.

```plantuml
@startuml
state "Composite State" as Comp {
  state entry1 <<entryPoint>>
  state exit1 <<exitPoint>>
  
  entry1 --> InternalState1
  InternalState1 --> InternalState2
  InternalState2 --> exit1
}

[*] --> entry1
exit1 --> [*]
@enduml
```

---

## State Machine Patterns

### 1. Simple State Machine

```plantuml
@startuml
[*] --> StateA
StateA --> StateB : event1
StateB --> StateC : event2
StateC --> [*] : event3
@enduml
```

### 2. State Machine with Guards

```plantuml
@startuml
[*] --> Waiting
Waiting --> Processing : start [resourcesAvailable]
Waiting --> Error : start [!resourcesAvailable]
Processing --> Complete : finish [successful]
Processing --> Error : finish [!successful]
Complete --> [*]
Error --> [*]
@enduml
```

### 3. Hierarchical State Machine

```plantuml
@startuml
state "Main State" as Main {
  state "Sub State 1" as Sub1 {
    [*] --> SubSub1
    SubSub1 --> SubSub2 : event
    SubSub2 --> [*]
  }
  
  state "Sub State 2" as Sub2
  
  [*] --> Sub1
  Sub1 --> Sub2 : transition
  Sub2 --> [*]
}

[*] --> Main
Main --> [*]
@enduml
```

### 4. Concurrent State Machine

```plantuml
@startuml
state "Parallel Processing" as Parallel {
  state "Process A" as ProcA {
    [*] --> A1
    A1 --> A2 : eventA
    A2 --> [*]
  }
  
  state "Process B" as ProcB {
    [*] --> B1
    B1 --> B2 : eventB
    B2 --> [*]
  }
}

[*] --> Parallel
Parallel --> [*]
@enduml
```

---

## Best Practices

### 1. State Naming
- Use noun phrases for states (e.g., "Waiting", "Processing", "Complete")
- Be descriptive and specific
- Avoid implementation details in names

### 2. Transition Labeling
- Use clear event names
- Include guards when necessary
- Specify actions when important
- Format: `event [guard] / action`

### 3. State Organization
- Group related states in composite states
- Use hierarchy to manage complexity
- Keep diagrams readable and focused

### 4. Event Handling
- Define all possible events for each state
- Handle error conditions explicitly
- Consider timeout events

### 5. Guard Conditions
- Make guards mutually exclusive when possible
- Use clear, testable conditions
- Document complex guard logic

---

## Common Mistakes to Avoid

### 1. Missing Transitions
❌ **Wrong**: States with no way to exit
✅ **Correct**: Every state should have exit transitions

### 2. Ambiguous Guards
❌ **Wrong**: Overlapping guard conditions
✅ **Correct**: Mutually exclusive guards

### 3. Too Many States
❌ **Wrong**: Overly complex state machines
✅ **Correct**: Use hierarchy to manage complexity

### 4. Implementation Details
❌ **Wrong**: States representing code structure
✅ **Correct**: States representing business concepts

### 5. Missing Error Handling
❌ **Wrong**: No error or exception states
✅ **Correct**: Explicit error handling paths

---

## Integration with Other Diagrams

### 1. Class Diagrams
- States → object states
- Transitions → method calls
- Events → method parameters

### 2. Sequence Diagrams
- State changes → message responses
- Events → incoming messages
- Actions → outgoing messages

### 3. Activity Diagrams
- States → activities
- Transitions → control flow
- Guards → decision conditions

---

## Tools and Implementation

### 1. PlantUML State Diagrams
```plantuml
@startuml
[*] --> State1
State1 --> State2 : event [guard] / action
State2 --> [*]
@enduml
```

### 2. State Machine Implementation
- **State Pattern**: Object-oriented implementation
- **State Tables**: Tabular representation
- **State Charts**: Executable specifications

### 3. Validation and Testing
- **State Coverage**: Test all states
- **Transition Coverage**: Test all transitions
- **Guard Coverage**: Test all guard conditions

---

## Performance Considerations

### 1. State Machine Complexity
- Limit nesting depth
- Minimize concurrent regions
- Use appropriate abstraction levels

### 2. Event Processing
- Consider event queuing
- Handle event priorities
- Manage event timing

### 3. Memory Usage
- Optimize state representation
- Consider state compression
- Manage history states efficiently

---

**Next Chapter**: Continue to [Chapter 9: Component Diagrams](./09-component-diagrams.md) to learn about modeling system architecture and component relationships.

---

**Key Takeaways:**
- State diagrams model object lifecycles and system behavior
- Use states, transitions, events, guards, and actions effectively
- Organize complex behavior with composite and concurrent states
- Handle all possible events and error conditions
- Keep diagrams focused and at appropriate abstraction level
- Integrate state machines with other UML diagrams for complete system models 