# Chapter 9: Component Diagrams

Component diagrams are structural diagrams that show the organization and dependencies among software components. They model the high-level architecture of a system by showing how components are connected through their interfaces.

## What is a Component Diagram?

A **Component Diagram** shows:
- **Components**: Modular parts of a system
- **Interfaces**: Contracts that components provide or require
- **Dependencies**: How components depend on each other
- **Ports**: Interaction points on components
- **Connectors**: Links between components

Component diagrams are primarily used for:
- System architecture design
- Component-based development
- Deployment planning
- Understanding system structure
- Interface specification

---

## Basic Elements

### 1. Components

**Definition**: A modular, deployable, and replaceable part of a system

**Notation**: Rectangle with component stereotype or component icon

**Types**:
- **Subsystem**: Large-scale component
- **Module**: Mid-level component
- **Class**: Fine-grained component

```plantuml
@startuml
component "Web Server" as WS
component "Application Server" as AS
component "Database Server" as DS

WS --> AS : HTTP
AS --> DS : SQL
@enduml
```

### 2. Interfaces

**Definition**: Contracts that specify what services a component provides or requires

**Types**:
- **Provided Interface**: Services the component offers (lollipop notation)
- **Required Interface**: Services the component needs (socket notation)

```plantuml
@startuml
component "Order Service" as OS
component "Payment Service" as PS

interface "Payment API" as PayAPI
interface "Order API" as OrderAPI

OS -() OrderAPI : provides
OS --( PayAPI : requires
PS -() PayAPI : provides
@enduml
```

### 3. Ports

**Definition**: Interaction points that specify how a component interacts with its environment

```plantuml
@startuml
component "Web Application" as WebApp {
  port "HTTP Port" as HTTP
  port "Database Port" as DB
}

component "Load Balancer" as LB
component "Database" as Database

LB --> HTTP
DB --> Database
@enduml
```

### 4. Dependencies

**Definition**: Relationships showing that one component depends on another

**Notation**: Dashed arrow with `<<use>>` or dependency stereotype

```plantuml
@startuml
component "User Interface" as UI
component "Business Logic" as BL
component "Data Access" as DA

UI ..> BL : <<use>>
BL ..> DA : <<use>>
@enduml
```

---

## Component Types and Patterns

### 1. Layered Architecture

```plantuml
@startuml
package "Presentation Layer" {
  component "Web UI" as WebUI
  component "Mobile App" as Mobile
  component "API Gateway" as Gateway
}

package "Business Layer" {
  component "User Service" as UserSvc
  component "Order Service" as OrderSvc
  component "Payment Service" as PaySvc
}

package "Data Layer" {
  component "User Repository" as UserRepo
  component "Order Repository" as OrderRepo
  component "Payment Repository" as PayRepo
}

package "Infrastructure" {
  component "Database" as DB
  component "Message Queue" as MQ
  component "Cache" as Cache
}

' Dependencies
WebUI ..> Gateway
Mobile ..> Gateway
Gateway ..> UserSvc
Gateway ..> OrderSvc
Gateway ..> PaySvc

UserSvc ..> UserRepo
OrderSvc ..> OrderRepo
PaySvc ..> PayRepo

UserRepo ..> DB
OrderRepo ..> DB
PayRepo ..> DB

OrderSvc ..> MQ
PaySvc ..> Cache
@enduml
```

### 2. Microservices Architecture

```plantuml
@startuml
component "API Gateway" as Gateway

package "User Service" {
  component "User API" as UserAPI
  component "User Business Logic" as UserBL
  component "User Database" as UserDB
  
  UserAPI --> UserBL
  UserBL --> UserDB
}

package "Order Service" {
  component "Order API" as OrderAPI
  component "Order Business Logic" as OrderBL
  component "Order Database" as OrderDB
  
  OrderAPI --> OrderBL
  OrderBL --> OrderDB
}

package "Payment Service" {
  component "Payment API" as PayAPI
  component "Payment Business Logic" as PayBL
  component "Payment Database" as PayDB
  
  PayAPI --> PayBL
  PayBL --> PayDB
}

package "Notification Service" {
  component "Notification API" as NotifAPI
  component "Email Service" as EmailSvc
  component "SMS Service" as SMSSvc
  
  NotifAPI --> EmailSvc
  NotifAPI --> SMSSvc
}

' External connections
Gateway --> UserAPI
Gateway --> OrderAPI
Gateway --> PayAPI
Gateway --> NotifAPI

' Inter-service communication
OrderBL ..> PayAPI : <<call>>
OrderBL ..> NotifAPI : <<call>>
PayBL ..> NotifAPI : <<call>>
@enduml
```

---

## Complete Example: E-commerce System Architecture

```plantuml
@startuml
title E-commerce System Component Architecture

package "Client Tier" {
  component "Web Browser" as Browser
  component "Mobile App" as MobileApp
  component "Admin Console" as AdminConsole
}

package "Presentation Tier" {
  component "Web Server" as WebServer
  component "Load Balancer" as LoadBalancer
  component "CDN" as CDN
}

package "Application Tier" {
  component "API Gateway" as APIGateway
  
  package "Core Services" {
    component "User Management" as UserMgmt
    component "Product Catalog" as ProductCatalog
    component "Shopping Cart" as ShoppingCart
    component "Order Processing" as OrderProc
    component "Payment Processing" as PaymentProc
    component "Inventory Management" as InventoryMgmt
  }
  
  package "Support Services" {
    component "Authentication Service" as AuthSvc
    component "Notification Service" as NotificationSvc
    component "Search Service" as SearchSvc
    component "Recommendation Engine" as RecommendationEngine
  }
}

package "Data Tier" {
  component "User Database" as UserDB
  component "Product Database" as ProductDB
  component "Order Database" as OrderDB
  component "Inventory Database" as InventoryDB
  component "Analytics Database" as AnalyticsDB
  component "Cache Cluster" as CacheCluster
  component "Search Index" as SearchIndex
}

package "External Services" {
  component "Payment Gateway" as ExtPaymentGW
  component "Shipping Service" as ShippingService
  component "Email Service" as EmailService
  component "SMS Service" as SMSService
}

' Client connections
Browser --> LoadBalancer : HTTPS
MobileApp --> LoadBalancer : HTTPS
AdminConsole --> LoadBalancer : HTTPS

' Presentation tier
LoadBalancer --> WebServer
WebServer --> CDN : static content
WebServer --> APIGateway : API calls

' API Gateway to services
APIGateway --> UserMgmt
APIGateway --> ProductCatalog
APIGateway --> ShoppingCart
APIGateway --> OrderProc
APIGateway --> PaymentProc
APIGateway --> InventoryMgmt
APIGateway --> AuthSvc
APIGateway --> SearchSvc

' Service dependencies
UserMgmt ..> AuthSvc : <<use>>
ShoppingCart ..> ProductCatalog : <<use>>
OrderProc ..> ShoppingCart : <<use>>
OrderProc ..> InventoryMgmt : <<use>>
OrderProc ..> PaymentProc : <<use>>
OrderProc ..> NotificationSvc : <<use>>
PaymentProc ..> ExtPaymentGW : <<use>>
ProductCatalog ..> RecommendationEngine : <<use>>
SearchSvc ..> SearchIndex : <<use>>

' Data connections
UserMgmt --> UserDB
ProductCatalog --> ProductDB
OrderProc --> OrderDB
InventoryMgmt --> InventoryDB
RecommendationEngine --> AnalyticsDB
SearchSvc --> SearchIndex

' Caching
UserMgmt --> CacheCluster
ProductCatalog --> CacheCluster
ShoppingCart --> CacheCluster

' External service connections
NotificationSvc --> EmailService
NotificationSvc --> SMSService
OrderProc --> ShippingService

note right of APIGateway : Handles authentication,\nrate limiting, routing
note right of CacheCluster : Redis cluster for\nhigh-performance caching
note right of SearchIndex : Elasticsearch for\nproduct search
@enduml
```

---

## Interface Modeling

### 1. Provided and Required Interfaces

```plantuml
@startuml
component "Order Service" as OrderSvc
component "Payment Service" as PaySvc
component "Inventory Service" as InvSvc
component "Notification Service" as NotifSvc

interface "IOrderManagement" as IOrderMgmt
interface "IPaymentProcessing" as IPayment
interface "IInventoryCheck" as IInventory
interface "INotification" as INotif

' Provided interfaces
OrderSvc -() IOrderMgmt
PaySvc -() IPayment
InvSvc -() IInventory
NotifSvc -() INotif

' Required interfaces
OrderSvc --( IPayment
OrderSvc --( IInventory
OrderSvc --( INotif

note right of OrderSvc : Orchestrates order\nprocessing workflow
@enduml
```

### 2. Interface Specifications

```plantuml
@startuml
interface "IPaymentProcessor" as IPayment {
  + processPayment(amount: Money, method: PaymentMethod): PaymentResult
  + refundPayment(transactionId: String): RefundResult
  + validatePaymentMethod(method: PaymentMethod): boolean
}

interface "IInventoryManager" as IInventory {
  + checkAvailability(productId: String, quantity: int): boolean
  + reserveItems(productId: String, quantity: int): ReservationId
  + releaseReservation(reservationId: ReservationId): void
  + updateStock(productId: String, quantity: int): void
}

component "Payment Service" as PaySvc
component "Inventory Service" as InvSvc

PaySvc ..|> IPayment : implements
InvSvc ..|> IInventory : implements
@enduml
```

---

## Deployment and Packaging

### 1. Component Packaging

```plantuml
@startuml
package "ecommerce-core" {
  component "User Management"
  component "Product Catalog"
  component "Order Processing"
}

package "ecommerce-payment" {
  component "Payment Service"
  component "Payment Gateway Adapter"
}

package "ecommerce-inventory" {
  component "Inventory Service"
  component "Warehouse Management"
}

package "ecommerce-notification" {
  component "Notification Service"
  component "Email Templates"
  component "SMS Templates"
}

package "ecommerce-web" {
  component "Web Controllers"
  component "API Endpoints"
  component "Authentication Filters"
}

' Dependencies between packages
"ecommerce-web" ..> "ecommerce-core"
"ecommerce-core" ..> "ecommerce-payment"
"ecommerce-core" ..> "ecommerce-inventory"
"ecommerce-core" ..> "ecommerce-notification"
@enduml
```

### 2. Deployment Components

```plantuml
@startuml
node "Web Server Cluster" {
  component "Load Balancer" as LB
  component "Web Server 1" as WS1
  component "Web Server 2" as WS2
  component "Web Server 3" as WS3
  
  LB --> WS1
  LB --> WS2
  LB --> WS3
}

node "Application Server Cluster" {
  component "App Server 1" as AS1
  component "App Server 2" as AS2
  component "App Server 3" as AS3
}

node "Database Cluster" {
  component "Primary DB" as PrimaryDB
  component "Secondary DB 1" as SecDB1
  component "Secondary DB 2" as SecDB2
  
  PrimaryDB --> SecDB1 : replication
  PrimaryDB --> SecDB2 : replication
}

node "Cache Cluster" {
  component "Redis Master" as RedisMaster
  component "Redis Slave 1" as RedisSlave1
  component "Redis Slave 2" as RedisSlave2
  
  RedisMaster --> RedisSlave1 : replication
  RedisMaster --> RedisSlave2 : replication
}

' Connections
WS1 --> AS1
WS2 --> AS2
WS3 --> AS3

AS1 --> PrimaryDB
AS2 --> PrimaryDB
AS3 --> PrimaryDB

AS1 --> RedisMaster
AS2 --> RedisMaster
AS3 --> RedisMaster
@enduml
```

---

## Component Patterns

### 1. Model-View-Controller (MVC)

```plantuml
@startuml
component "View" as V
component "Controller" as C
component "Model" as M

interface "IView" as IV
interface "IController" as IC
interface "IModel" as IM

V ..|> IV
C ..|> IC
M ..|> IM

C --> V : updates
V --> C : user input
C --> M : manipulates
M --> V : notifies
@enduml
```

### 2. Repository Pattern

```plantuml
@startuml
component "Business Logic" as BL
component "Repository Interface" as RepoInterface
component "Concrete Repository" as ConcreteRepo
component "Data Access Layer" as DAL
component "Database" as DB

BL --> RepoInterface : uses
RepoInterface <|.. ConcreteRepo : implements
ConcreteRepo --> DAL : uses
DAL --> DB : queries
@enduml
```

### 3. Service-Oriented Architecture (SOA)

```plantuml
@startuml
component "Service Consumer" as Consumer
component "Service Registry" as Registry
component "Service Provider" as Provider

Consumer --> Registry : discover
Registry --> Consumer : service info
Consumer --> Provider : invoke
Provider --> Registry : register
@enduml
```

---

## Best Practices

### 1. Component Design Principles
- **Single Responsibility**: Each component has one clear purpose
- **High Cohesion**: Related functionality grouped together
- **Loose Coupling**: Minimal dependencies between components
- **Interface Segregation**: Small, focused interfaces

### 2. Dependency Management
- **Dependency Inversion**: Depend on abstractions, not concretions
- **Minimize Dependencies**: Reduce coupling between components
- **Explicit Dependencies**: Make dependencies clear and visible
- **Avoid Circular Dependencies**: Prevent circular references

### 3. Interface Design
- **Stable Interfaces**: Minimize interface changes
- **Versioning**: Support multiple interface versions
- **Documentation**: Clearly document interface contracts
- **Error Handling**: Define error handling strategies

### 4. Component Organization
- **Logical Grouping**: Group related components
- **Layer Separation**: Separate concerns into layers
- **Package Structure**: Organize components into packages
- **Naming Conventions**: Use consistent naming

---

## Common Mistakes to Avoid

### 1. Overly Complex Components
❌ **Wrong**: Components that do too many things
✅ **Correct**: Focused, single-purpose components

### 2. Tight Coupling
❌ **Wrong**: Direct dependencies between components
✅ **Correct**: Interface-based dependencies

### 3. Missing Interfaces
❌ **Wrong**: Components communicating directly
✅ **Correct**: Well-defined interfaces between components

### 4. Inconsistent Abstraction Levels
❌ **Wrong**: Mixing high-level and low-level components
✅ **Correct**: Consistent abstraction levels

### 5. Poor Package Organization
❌ **Wrong**: Random component grouping
✅ **Correct**: Logical package structure

---

## Integration with Other Diagrams

### 1. Class Diagrams
- Components → packages or subsystems
- Interfaces → interface classes
- Dependencies → package dependencies

### 2. Deployment Diagrams
- Components → deployed artifacts
- Nodes → deployment targets
- Connections → network links

### 3. Sequence Diagrams
- Components → lifelines
- Interface calls → messages
- Component interactions → message flows

---

## Tools and Technologies

### 1. Component Frameworks
- **Spring Framework**: Dependency injection
- **OSGi**: Dynamic component model
- **Enterprise JavaBeans**: Component architecture
- **COM/DCOM**: Microsoft component model

### 2. Modeling Tools
- **Enterprise Architect**: Component modeling
- **Visual Paradigm**: UML component diagrams
- **Lucidchart**: Online component diagrams
- **PlantUML**: Text-based component diagrams

### 3. Architecture Documentation
- **C4 Model**: Context, containers, components, code
- **Arc42**: Architecture documentation template
- **Architecture Decision Records**: Document decisions

---

## Performance and Scalability

### 1. Component Granularity
- **Coarse-grained**: Fewer, larger components
- **Fine-grained**: Many, smaller components
- **Balance**: Right size for your needs

### 2. Communication Patterns
- **Synchronous**: Direct method calls
- **Asynchronous**: Message-based communication
- **Event-driven**: Publish-subscribe patterns

### 3. Scalability Considerations
- **Stateless Components**: Enable horizontal scaling
- **Load Distribution**: Balance load across instances
- **Caching**: Reduce component interactions
- **Connection Pooling**: Optimize resource usage

---

**Next Chapter**: Continue to [Chapter 10: Deployment Diagrams](./10-deployment-diagrams.md) to learn about modeling system deployment and infrastructure.

---

**Key Takeaways:**
- Component diagrams model system architecture and component relationships
- Use interfaces to define contracts between components
- Apply design principles: single responsibility, loose coupling, high cohesion
- Organize components into logical packages and layers
- Consider deployment and scalability requirements
- Integrate component diagrams with other UML diagrams for complete system documentation 