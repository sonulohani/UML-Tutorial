# Chapter 7: Activity Diagrams

Activity diagrams are behavioral diagrams that show the flow of activities and actions within a system. They model workflows, business processes, and algorithms by showing the sequence of activities and the decisions that control the flow.

## What is an Activity Diagram?

An **Activity Diagram** shows:
- **Activities**: Tasks or operations being performed
- **Control Flow**: The order in which activities are executed
- **Decision Points**: Where the flow branches based on conditions
- **Parallel Activities**: Activities that can occur simultaneously
- **Start and End Points**: Where the process begins and ends

Activity diagrams are primarily used for:
- Business process modeling
- Workflow documentation
- Algorithm design
- Use case realization
- System behavior analysis

---

## Basic Elements

### 1. Activities and Actions

**Activity**: A larger unit of work that may contain other activities
**Action**: An atomic unit of work that cannot be decomposed

**Notation**: Rounded rectangles

```plantuml
@startuml
start
:Process Order;
:Validate Payment;
:Ship Product;
stop
@enduml
```

### 2. Control Flow

**Definition**: Arrows showing the sequence of activities

**Notation**: Solid arrows connecting activities

```plantuml
@startuml
start
:Activity 1;
:Activity 2;
:Activity 3;
stop
@enduml
```

### 3. Initial and Final Nodes

**Initial Node**: Black filled circle - where the activity starts
**Final Node**: Black filled circle with border - where the activity ends
**Flow Final**: Circle with X - ends a specific flow

```plantuml
@startuml
start
:Do Something;
if (condition?) then (yes)
  :Path A;
  end
else (no)
  :Path B;
  stop
endif
@enduml
```

### 4. Decision and Merge Nodes

**Decision Node**: Diamond shape - where flow branches based on conditions
**Merge Node**: Diamond shape - where flows come back together

```plantuml
@startuml
start
:Check Inventory;
if (Items Available?) then (yes)
  :Process Order;
else (no)
  :Backorder Items;
endif
:Send Confirmation;
stop
@enduml
```

---

## Advanced Control Structures

### 1. Fork and Join (Parallel Activities)

**Fork**: Splits flow into parallel paths
**Join**: Synchronizes parallel paths back together

```plantuml
@startuml
start
:Receive Order;
fork
  :Process Payment;
fork again
  :Check Inventory;
fork again
  :Prepare Shipping;
end fork
:Complete Order;
stop
@enduml
```

### 2. Loops and Iteration

**While Loop**: Repeat while condition is true
**For Loop**: Repeat for a specific number of times

```plantuml
@startuml
start
:Initialize Counter;
while (Counter < 10?) is (yes)
  :Process Item;
  :Increment Counter;
endwhile (no)
:Finish Processing;
stop
@enduml
```

### 3. Exception Handling

Show how exceptions are handled in the flow.

```plantuml
@startuml
start
:Process Payment;
note right: May throw PaymentException
if (Payment Successful?) then (yes)
  :Confirm Order;
else (no)
  :Handle Payment Error;
  :Notify Customer;
endif
stop
@enduml
```

---

## Swimlanes (Activity Partitions)

Swimlanes organize activities by responsibility - showing who or what performs each activity.

### Vertical Swimlanes

```plantuml
@startuml
|Customer|
start
:Place Order;

|Order System|
:Validate Order;
:Check Inventory;

|Payment System|
:Process Payment;

|Fulfillment|
:Ship Order;

|Customer|
:Receive Order;
stop
@enduml
```

### Horizontal Swimlanes

```plantuml
@startuml
|#AntiqueWhite|Customer|
start
:Submit Request;

|#LightBlue|Sales Team|
:Review Request;
:Prepare Quote;

|#LightGreen|Management|
:Approve Quote;

|#LightBlue|Sales Team|
:Send Quote to Customer;

|#AntiqueWhite|Customer|
:Review Quote;
stop
@enduml
```

---

## Complete Example: Order Processing Workflow

```plantuml
@startuml
title Order Processing Workflow

|#LightBlue|Customer|
start
:Browse Products;
:Add Items to Cart;
:Proceed to Checkout;
:Enter Payment Info;

|#LightGreen|Order System|
:Validate Order Data;
if (Order Valid?) then (no)
  |#LightBlue|Customer|
  :Display Error Message;
  stop
else (yes)
endif

:Calculate Total;
:Generate Order ID;

|#LightCoral|Payment System|
:Process Payment;
if (Payment Successful?) then (no)
  |#LightBlue|Customer|
  :Display Payment Error;
  stop
else (yes)
endif

|#LightGreen|Order System|
:Create Order Record;

fork
  |#LightYellow|Inventory System|
  :Check Item Availability;
  if (Items Available?) then (yes)
    :Reserve Items;
    :Update Inventory;
  else (no)
    :Create Backorder;
    |#LightBlue|Customer|
    :Send Backorder Notification;
  endif
fork again
  |#LightPink|Email System|
  :Send Order Confirmation;
fork again
  |#LightGray|Analytics System|
  :Record Order Metrics;
  :Update Customer Profile;
end fork

|#LightYellow|Inventory System|
if (Items Reserved?) then (yes)
  |#LightCyan|Fulfillment|
  :Pick Items;
  :Pack Order;
  :Generate Shipping Label;
  :Ship Order;
  
  |#LightPink|Email System|
  :Send Shipping Notification;
  
  |#LightBlue|Customer|
  :Receive Order;
  :Confirm Delivery;
  
  |#LightGreen|Order System|
  :Mark Order Complete;
else (no)
  :Wait for Restock;
endif

stop
@enduml
```

---

## Real-World Examples

### Example 1: Software Development Process

```plantuml
@startuml
title Software Development Lifecycle

|Developer|
start
:Analyze Requirements;
:Design Solution;
:Write Code;

|Code Review|
:Review Code;
if (Code Approved?) then (no)
  |Developer|
  :Fix Issues;
  |Code Review|
  :Review Again;
else (yes)
endif

|Testing|
:Run Unit Tests;
if (Tests Pass?) then (no)
  |Developer|
  :Fix Bugs;
  |Testing|
  :Retest;
else (yes)
endif

:Run Integration Tests;
if (Integration OK?) then (no)
  |Developer|
  :Fix Integration Issues;
else (yes)
endif

|Deployment|
:Deploy to Staging;
:User Acceptance Testing;
if (UAT Passed?) then (no)
  |Developer|
  :Address Feedback;
else (yes)
endif

:Deploy to Production;
:Monitor System;
stop
@enduml
```

### Example 2: Customer Support Process

```plantuml
@startuml
title Customer Support Ticket Process

|Customer|
start
:Submit Support Ticket;

|Support System|
:Auto-assign Ticket ID;
:Categorize Issue;

|Level 1 Support|
:Review Ticket;
if (Can Resolve?) then (yes)
  :Provide Solution;
  |Customer|
  :Test Solution;
  if (Issue Resolved?) then (yes)
    |Support System|
    :Close Ticket;
    stop
  else (no)
    |Level 1 Support|
  endif
else (no)
endif

:Escalate to Level 2;

|Level 2 Support|
:Investigate Issue;
if (Can Resolve?) then (yes)
  :Implement Solution;
  |Customer|
  :Verify Fix;
  if (Issue Resolved?) then (yes)
    |Support System|
    :Close Ticket;
    stop
  else (no)
    |Level 2 Support|
  endif
else (no)
endif

:Escalate to Engineering;

|Engineering|
:Deep Investigation;
:Develop Fix;
:Test Solution;
:Deploy Fix;

|Customer|
:Verify Resolution;
|Support System|
:Close Ticket;
stop
@enduml
```

---

## Activity Diagram Patterns

### 1. Sequential Processing

```plantuml
@startuml
start
:Step 1;
:Step 2;
:Step 3;
:Step 4;
stop
@enduml
```

### 2. Conditional Processing

```plantuml
@startuml
start
:Input Data;
if (Data Valid?) then (yes)
  :Process Data;
  :Generate Output;
else (no)
  :Show Error;
endif
stop
@enduml
```

### 3. Parallel Processing

```plantuml
@startuml
start
:Initialize;
fork
  :Task A;
fork again
  :Task B;
fork again
  :Task C;
end fork
:Combine Results;
stop
@enduml
```

### 4. Loop Processing

```plantuml
@startuml
start
:Initialize;
repeat
  :Process Item;
  :Get Next Item;
repeat while (More Items?) is (yes)
:Finalize;
stop
@enduml
```

### 5. Exception Handling Pattern

```plantuml
@startuml
start
:Begin Operation;
partition "Try Block" {
  :Risky Operation;
  :Continue Processing;
}
if (Exception Occurred?) then (yes)
  partition "Catch Block" {
    :Handle Exception;
    :Log Error;
    :Notify User;
  }
else (no)
  :Normal Completion;
endif
stop
@enduml
```

---

## Best Practices

### 1. Naming Conventions
- **Activities**: Use verb phrases (e.g., "Process Order", "Validate Input")
- **Decision Points**: Use questions (e.g., "Payment Valid?", "Items Available?")
- **Swimlanes**: Use role names or system names

### 2. Level of Detail
- **High-level**: Focus on major activities and decisions
- **Detailed**: Include all steps and conditions
- **Consistent**: Maintain same level throughout diagram

### 3. Layout and Organization
- **Top to bottom**: Generally flow from top to bottom
- **Left to right**: Use for parallel activities
- **Minimize crossings**: Avoid crossing flow lines
- **Group related**: Keep related activities close together

### 4. Swimlane Usage
- **Clear responsibility**: Each swimlane should have clear ownership
- **Minimize handoffs**: Reduce activities crossing swimlanes
- **Logical grouping**: Group by role, system, or department

### 5. Decision Points
- **Clear conditions**: Make decision criteria explicit
- **Complete coverage**: Ensure all possible paths are covered
- **Mutually exclusive**: Conditions should not overlap

---

## Common Mistakes to Avoid

### 1. Too Much Detail
❌ **Wrong**: Including every minor step
✅ **Correct**: Focus on significant activities

### 2. Missing Decision Outcomes
❌ **Wrong**: Decision points without clear yes/no paths
✅ **Correct**: All decision branches clearly labeled

### 3. Unbalanced Parallel Flows
❌ **Wrong**: Fork without corresponding join
✅ **Correct**: Every fork has a matching join

### 4. Unclear Swimlane Boundaries
❌ **Wrong**: Activities spanning multiple swimlanes
✅ **Correct**: Each activity clearly in one swimlane

### 5. Complex Nested Structures
❌ **Wrong**: Deeply nested loops and conditions
✅ **Correct**: Break complex flows into sub-diagrams

---

## Advanced Features

### 1. Object Flow

Show how objects move through the process.

```plantuml
@startuml
start
:Create Order;
:Order: Order Object;
:Validate Order;
:Order: Validated Order;
:Process Payment;
:Order: Paid Order;
:Ship Order;
stop
@enduml
```

### 2. Signals and Events

Show external events that trigger activities.

```plantuml
@startuml
start
:Wait for Order;
:Order Received;
:Process Order;
:Payment Processed;
:Ship Order;
stop
@enduml
```

### 3. Time Events

Show time-based triggers.

```plantuml
@startuml
start
:Start Process;
:Wait 24 hours;
:Send Reminder;
:Wait 48 hours;
:Escalate Issue;
stop
@enduml
```

### 4. Interruption Regions

Show how processes can be interrupted.

```plantuml
@startuml
start
partition "Main Process" {
  :Step 1;
  :Step 2;
  :Step 3;
}
note right: Can be interrupted\nby emergency stop
:Complete Process;
stop
@enduml
```

---

## Integration with Other Diagrams

### 1. Use Case to Activity
- Use case scenarios → activity diagrams
- Use case steps → activities
- Alternative flows → decision points

### 2. Activity to Sequence
- Activities → messages between objects
- Swimlanes → lifelines
- Flow → message sequence

### 3. Activity to Class
- Activities → methods in classes
- Object flow → class relationships
- Swimlanes → class responsibilities

---

## Tools and Techniques

### 1. PlantUML Activity Diagrams
```plantuml
@startuml
start
:Activity;
if (condition?) then (yes)
  :Action A;
else (no)
  :Action B;
endif
stop
@enduml
```

### 2. Business Process Modeling
- **BPMN**: Business Process Model and Notation
- **Workflow engines**: Execute activity diagrams
- **Process mining**: Generate diagrams from logs

### 3. Algorithm Documentation
- **Pseudocode**: Convert to activity diagrams
- **Flowcharts**: Similar to activity diagrams
- **State machines**: For complex control logic

---

## Validation and Testing

### 1. Completeness Check
- All paths lead to end points
- No orphaned activities
- All decision branches covered

### 2. Consistency Check
- Activities match use case descriptions
- Swimlanes align with system architecture
- Object flow matches class diagrams

### 3. Performance Analysis
- Identify bottlenecks
- Parallel opportunities
- Critical path analysis

---

**Next Chapter**: Continue to [Chapter 8: State Diagrams](./08-state-diagrams.md) to learn about modeling object lifecycles and state transitions.

---

**Key Takeaways:**
- Activity diagrams model workflows and business processes
- Use activities, decisions, forks, and joins effectively
- Swimlanes organize activities by responsibility
- Focus on significant activities, not every detail
- Ensure all decision paths are covered
- Use parallel flows to show concurrent activities 