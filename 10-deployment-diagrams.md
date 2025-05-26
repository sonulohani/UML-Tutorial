# Chapter 10: Deployment Diagrams

Deployment diagrams are structural diagrams that show the physical deployment of software components on hardware nodes. They model the runtime architecture of a system by showing how software artifacts are distributed across the computing infrastructure.

## What is a Deployment Diagram?

A **Deployment Diagram** shows:
- **Nodes**: Physical or virtual computing resources
- **Artifacts**: Deployable software components
- **Deployment**: How artifacts are deployed on nodes
- **Communication**: Network connections between nodes
- **Dependencies**: Relationships between deployed components

Deployment diagrams are primarily used for:
- System deployment planning
- Infrastructure documentation
- Performance analysis
- Security planning
- Capacity planning

---

## Basic Elements

### 1. Nodes

**Definition**: Physical or virtual computing resources that can host software components

**Types**:
- **Device Nodes**: Physical hardware (servers, workstations, mobile devices)
- **Execution Environment Nodes**: Software platforms (JVM, .NET runtime, containers)

**Notation**: 3D box with node name

```plantuml
@startuml
node "Web Server" as WebServer
node "Application Server" as AppServer
node "Database Server" as DBServer

WebServer --> AppServer : HTTP
AppServer --> DBServer : JDBC
@enduml
```

### 2. Artifacts

**Definition**: Physical pieces of software that are deployed on nodes

**Types**:
- **Executable Files**: Applications, services
- **Libraries**: JAR files, DLLs
- **Configuration Files**: Properties, XML files
- **Data Files**: Databases, documents

**Notation**: Rectangle with artifact stereotype

```plantuml
@startuml
artifact "webapp.war" as WebApp
artifact "app.jar" as AppJar
artifact "config.xml" as Config

node "Tomcat Server" as Tomcat {
  WebApp
  Config
}

node "JVM" as JVM {
  AppJar
}
@enduml
```

### 3. Communication Paths

**Definition**: Network connections between nodes

**Notation**: Lines connecting nodes with protocol labels

```plantuml
@startuml
node "Client" as Client
node "Load Balancer" as LB
node "Web Server 1" as WS1
node "Web Server 2" as WS2
node "Database" as DB

Client --> LB : HTTPS
LB --> WS1 : HTTP
LB --> WS2 : HTTP
WS1 --> DB : TCP/IP
WS2 --> DB : TCP/IP
@enduml
```

---

## Node Types and Environments

### 1. Physical Nodes

```plantuml
@startuml
node "Production Server" <<device>> {
  node "Docker Engine" <<execution environment>> {
    artifact "web-app.jar"
    artifact "config.properties"
  }
}

node "Database Server" <<device>> {
  node "PostgreSQL" <<execution environment>> {
    artifact "ecommerce.db"
    artifact "pg_config"
  }
}

node "Load Balancer" <<device>> {
  artifact "nginx.conf"
  artifact "ssl.cert"
}
@enduml
```

### 2. Cloud Infrastructure

```plantuml
@startuml
cloud "AWS Cloud" {
  node "EC2 Instance 1" as EC2_1 {
    node "Docker" {
      artifact "web-service:v1.2"
    }
  }
  
  node "EC2 Instance 2" as EC2_2 {
    node "Docker" {
      artifact "web-service:v1.2"
    }
  }
  
  node "RDS Instance" as RDS {
    artifact "PostgreSQL Database"
  }
  
  node "S3 Bucket" as S3 {
    artifact "Static Assets"
    artifact "User Uploads"
  }
  
  node "CloudFront CDN" as CDN
}

CDN --> S3 : content delivery
EC2_1 --> RDS : database connection
EC2_2 --> RDS : database connection
@enduml
```

### 3. Containerized Deployment

```plantuml
@startuml
node "Kubernetes Cluster" {
  node "Master Node" {
    artifact "kube-apiserver"
    artifact "etcd"
    artifact "kube-scheduler"
  }
  
  node "Worker Node 1" {
    node "Pod 1" {
      artifact "web-app:latest"
    }
    node "Pod 2" {
      artifact "api-service:v2.1"
    }
  }
  
  node "Worker Node 2" {
    node "Pod 3" {
      artifact "web-app:latest"
    }
    node "Pod 4" {
      artifact "background-worker:v1.5"
    }
  }
}

node "External Database" {
  artifact "PostgreSQL"
}

"Worker Node 1" --> "External Database" : TCP/5432
"Worker Node 2" --> "External Database" : TCP/5432
@enduml
```

---

## Complete Example: E-commerce Deployment Architecture

```plantuml
@startuml
title E-commerce System Deployment Architecture

package "DMZ (Demilitarized Zone)" {
  node "Load Balancer 1" as LB1 <<device>> {
    artifact "HAProxy Config"
    artifact "SSL Certificates"
  }
  
  node "Load Balancer 2" as LB2 <<device>> {
    artifact "HAProxy Config"
    artifact "SSL Certificates"
  }
  
  node "CDN Edge Server" as CDN <<device>> {
    artifact "Static Content Cache"
    artifact "Image Cache"
  }
}

package "Web Tier" {
  node "Web Server 1" as WS1 <<device>> {
    node "Nginx" <<execution environment>> {
      artifact "nginx.conf"
      artifact "web-frontend.js"
      artifact "css-bundle.css"
    }
  }
  
  node "Web Server 2" as WS2 <<device>> {
    node "Nginx" <<execution environment>> {
      artifact "nginx.conf"
      artifact "web-frontend.js"
      artifact "css-bundle.css"
    }
  }
}

package "Application Tier" {
  node "App Server 1" as AS1 <<device>> {
    node "JVM 11" <<execution environment>> {
      artifact "ecommerce-api.jar"
      artifact "application.properties"
      artifact "logback.xml"
    }
  }
  
  node "App Server 2" as AS2 <<device>> {
    node "JVM 11" <<execution environment>> {
      artifact "ecommerce-api.jar"
      artifact "application.properties"
      artifact "logback.xml"
    }
  }
  
  node "Background Worker" as BW <<device>> {
    node "Python 3.9" <<execution environment>> {
      artifact "order-processor.py"
      artifact "email-service.py"
      artifact "requirements.txt"
    }
  }
}

package "Data Tier" {
  node "Primary Database" as PDB <<device>> {
    node "PostgreSQL 13" <<execution environment>> {
      artifact "ecommerce_db"
      artifact "postgresql.conf"
      artifact "pg_hba.conf"
    }
  }
  
  node "Read Replica 1" as RR1 <<device>> {
    node "PostgreSQL 13" <<execution environment>> {
      artifact "ecommerce_db_replica"
      artifact "postgresql.conf"
    }
  }
  
  node "Redis Cache" as Redis <<device>> {
    node "Redis 6" <<execution environment>> {
      artifact "redis.conf"
      artifact "session_cache"
      artifact "product_cache"
    }
  }
}

package "External Services" {
  node "Payment Gateway" as PayGW <<external>>
  node "Email Service" as EmailSvc <<external>>
  node "Shipping API" as ShipAPI <<external>>
}

package "Monitoring & Logging" {
  node "Log Server" as LogServer <<device>> {
    node "ELK Stack" <<execution environment>> {
      artifact "elasticsearch"
      artifact "logstash"
      artifact "kibana"
    }
  }
  
  node "Monitoring Server" as MonServer <<device>> {
    artifact "prometheus"
    artifact "grafana"
    artifact "alertmanager"
  }
}

' Network connections
LB1 --> WS1 : HTTP/80
LB1 --> WS2 : HTTP/80
LB2 --> WS1 : HTTP/80
LB2 --> WS2 : HTTP/80

WS1 --> AS1 : HTTP/8080
WS1 --> AS2 : HTTP/8080
WS2 --> AS1 : HTTP/8080
WS2 --> AS2 : HTTP/8080

AS1 --> PDB : TCP/5432
AS2 --> PDB : TCP/5432
AS1 --> RR1 : TCP/5432
AS2 --> RR1 : TCP/5432

AS1 --> Redis : TCP/6379
AS2 --> Redis : TCP/6379
BW --> Redis : TCP/6379

BW --> PDB : TCP/5432

' External connections
AS1 --> PayGW : HTTPS/443
AS2 --> PayGW : HTTPS/443
BW --> EmailSvc : HTTPS/443
BW --> ShipAPI : HTTPS/443

' Monitoring connections
AS1 --> LogServer : TCP/5044
AS2 --> LogServer : TCP/5044
BW --> LogServer : TCP/5044

AS1 --> MonServer : HTTP/9090
AS2 --> MonServer : HTTP/9090

' Database replication
PDB --> RR1 : replication

note right of LB1 : Active-Passive\nLoad Balancer Setup
note right of PDB : Master-Slave\nDatabase Replication
note right of Redis : Session and\nApplication Cache
note right of CDN : Global Content\nDelivery Network
@enduml
```

---

## Deployment Patterns

### 1. Three-Tier Architecture

```plantuml
@startuml
package "Presentation Tier" {
  node "Web Browser" as Browser
  node "Mobile App" as Mobile
}

package "Application Tier" {
  node "Web Server" as WebServer {
    artifact "web-app.war"
  }
  
  node "Application Server" as AppServer {
    artifact "business-logic.jar"
    artifact "api-gateway.jar"
  }
}

package "Data Tier" {
  node "Database Server" as DBServer {
    artifact "application.db"
  }
  
  node "File Server" as FileServer {
    artifact "user-uploads"
    artifact "static-content"
  }
}

Browser --> WebServer : HTTPS
Mobile --> AppServer : REST API
WebServer --> AppServer : HTTP
AppServer --> DBServer : JDBC
AppServer --> FileServer : NFS
@enduml
```

### 2. Microservices Deployment

```plantuml
@startuml
node "API Gateway" as Gateway {
  artifact "gateway-service"
}

node "Service Mesh" as Mesh {
  node "User Service Pod" {
    artifact "user-service:v1.2"
    artifact "envoy-proxy"
  }
  
  node "Order Service Pod" {
    artifact "order-service:v2.1"
    artifact "envoy-proxy"
  }
  
  node "Payment Service Pod" {
    artifact "payment-service:v1.8"
    artifact "envoy-proxy"
  }
}

node "Message Broker" as Broker {
  artifact "kafka-cluster"
}

node "Service Registry" as Registry {
  artifact "consul"
}

Gateway --> Mesh : HTTP/gRPC
Mesh --> Broker : async messaging
Mesh --> Registry : service discovery
@enduml
```

### 3. Serverless Architecture

```plantuml
@startuml
cloud "AWS" {
  node "API Gateway" as APIGW
  
  node "Lambda Functions" as Lambda {
    artifact "user-handler.zip"
    artifact "order-handler.zip"
    artifact "payment-handler.zip"
  }
  
  node "DynamoDB" as DDB {
    artifact "user-table"
    artifact "order-table"
  }
  
  node "S3" as S3 {
    artifact "static-website"
    artifact "user-uploads"
  }
  
  node "CloudFront" as CF
}

APIGW --> Lambda : invocation
Lambda --> DDB : queries
CF --> S3 : content delivery
@enduml
```

---

## Infrastructure Considerations

### 1. High Availability Setup

```plantuml
@startuml
package "Region 1 (Primary)" {
  package "Availability Zone 1A" {
    node "Web Server 1A" as WS1A
    node "App Server 1A" as AS1A
    node "DB Primary" as DB1
  }
  
  package "Availability Zone 1B" {
    node "Web Server 1B" as WS1B
    node "App Server 1B" as AS1B
    node "DB Standby" as DB2
  }
}

package "Region 2 (DR)" {
  package "Availability Zone 2A" {
    node "Web Server 2A" as WS2A
    node "App Server 2A" as AS2A
    node "DB Replica" as DB3
  }
}

node "Global Load Balancer" as GLB

GLB --> WS1A
GLB --> WS1B
GLB --> WS2A : failover

DB1 --> DB2 : synchronous replication
DB1 --> DB3 : asynchronous replication
@enduml
```

### 2. Auto-Scaling Configuration

```plantuml
@startuml
node "Auto Scaling Group" as ASG {
  node "Instance 1" as I1 {
    artifact "web-app"
  }
  
  node "Instance 2" as I2 {
    artifact "web-app"
  }
  
  node "Instance N" as IN {
    artifact "web-app"
  }
}

node "Load Balancer" as LB
node "CloudWatch" as CW
node "Auto Scaling Service" as ASS

LB --> I1
LB --> I2
LB --> IN

CW --> ASS : metrics
ASS --> ASG : scale up/down
@enduml
```

### 3. Security Zones

```plantuml
@startuml
package "Internet" {
  node "User Browser" as User
}

package "DMZ" {
  node "Web Application Firewall" as WAF
  node "Load Balancer" as LB
}

package "Private Network" {
  node "Application Servers" as AppServers
  node "Internal Services" as IntServices
}

package "Secure Zone" {
  node "Database Servers" as DBServers
  node "Backup Systems" as Backup
}

User --> WAF : HTTPS
WAF --> LB : HTTP
LB --> AppServers : HTTP
AppServers --> IntServices : internal
AppServers --> DBServers : encrypted
DBServers --> Backup : secure backup
@enduml
```

---

## Performance and Scalability

### 1. Caching Strategy

```plantuml
@startuml
node "Client" as Client

node "CDN" as CDN {
  artifact "static-content-cache"
}

node "Reverse Proxy" as Proxy {
  artifact "nginx-cache"
}

node "Application Server" as AppServer {
  artifact "application.jar"
}

node "Redis Cache" as Redis {
  artifact "session-cache"
  artifact "data-cache"
}

node "Database" as DB {
  artifact "persistent-data"
}

Client --> CDN : static content
Client --> Proxy : dynamic content
Proxy --> AppServer : cache miss
AppServer --> Redis : session/data
AppServer --> DB : persistent queries
@enduml
```

### 2. Database Scaling

```plantuml
@startuml
node "Application Tier" as AppTier {
  artifact "read-write-service"
  artifact "read-only-service"
}

node "Database Master" as Master {
  artifact "primary-db"
}

node "Read Replica 1" as Replica1 {
  artifact "replica-db"
}

node "Read Replica 2" as Replica2 {
  artifact "replica-db"
}

node "Database Proxy" as Proxy {
  artifact "connection-pooling"
  artifact "load-balancing"
}

AppTier --> Proxy
Proxy --> Master : writes
Proxy --> Replica1 : reads
Proxy --> Replica2 : reads
Master --> Replica1 : replication
Master --> Replica2 : replication
@enduml
```

---

## Best Practices

### 1. Deployment Principles
- **Immutable Infrastructure**: Deploy new versions rather than updating
- **Blue-Green Deployment**: Maintain two identical environments
- **Rolling Updates**: Gradual replacement of instances
- **Canary Releases**: Test with small subset of users

### 2. Security Considerations
- **Network Segmentation**: Isolate different tiers
- **Encryption**: Encrypt data in transit and at rest
- **Access Control**: Implement proper authentication and authorization
- **Monitoring**: Log and monitor all access

### 3. Monitoring and Observability
- **Health Checks**: Monitor application and infrastructure health
- **Metrics Collection**: Gather performance and business metrics
- **Distributed Tracing**: Track requests across services
- **Alerting**: Set up proactive alerts for issues

### 4. Disaster Recovery
- **Backup Strategy**: Regular, tested backups
- **Geographic Distribution**: Deploy across multiple regions
- **Recovery Procedures**: Documented and tested recovery plans
- **RTO/RPO Targets**: Define recovery time and point objectives

---

## Common Deployment Challenges

### 1. Configuration Management
❌ **Problem**: Inconsistent configurations across environments
✅ **Solution**: Infrastructure as Code (IaC) and configuration management tools

### 2. Dependency Management
❌ **Problem**: Version conflicts and missing dependencies
✅ **Solution**: Containerization and dependency isolation

### 3. Service Discovery
❌ **Problem**: Hard-coded service endpoints
✅ **Solution**: Service registry and discovery mechanisms

### 4. Data Consistency
❌ **Problem**: Data synchronization across distributed systems
✅ **Solution**: Event-driven architecture and eventual consistency patterns

---

## Tools and Technologies

### 1. Infrastructure as Code
- **Terraform**: Multi-cloud infrastructure provisioning
- **CloudFormation**: AWS infrastructure templates
- **Ansible**: Configuration management and deployment
- **Kubernetes**: Container orchestration

### 2. Containerization
- **Docker**: Container runtime and images
- **Kubernetes**: Container orchestration platform
- **Docker Swarm**: Docker-native clustering
- **OpenShift**: Enterprise Kubernetes platform

### 3. Cloud Platforms
- **AWS**: Amazon Web Services
- **Azure**: Microsoft Azure
- **GCP**: Google Cloud Platform
- **Digital Ocean**: Simple cloud infrastructure

### 4. Monitoring Tools
- **Prometheus**: Metrics collection and alerting
- **Grafana**: Metrics visualization
- **ELK Stack**: Logging and log analysis
- **Jaeger**: Distributed tracing

---

## Integration with Development Process

### 1. CI/CD Pipeline Integration
- Deployment diagrams guide pipeline design
- Infrastructure changes tracked in version control
- Automated testing of deployment configurations
- Progressive deployment strategies

### 2. Environment Management
- Consistent environments across development lifecycle
- Environment-specific configurations
- Promotion process between environments
- Environment provisioning automation

### 3. Capacity Planning
- Performance requirements drive infrastructure design
- Load testing validates deployment architecture
- Scaling strategies based on usage patterns
- Cost optimization through right-sizing

---

**Conclusion**: Deployment diagrams are essential for documenting and planning system infrastructure. They help teams understand how software components are distributed across hardware resources and guide decisions about scalability, security, and performance.

---

**Key Takeaways:**
- Deployment diagrams model the physical architecture of systems
- Use nodes to represent computing resources and artifacts for software components
- Consider high availability, scalability, and security in deployment design
- Integrate deployment planning with development and operations processes
- Use modern tools and practices like IaC, containers, and cloud platforms
- Document and test disaster recovery procedures 