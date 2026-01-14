# PulpitMobility-Parking-System-Database-Design
## Problem Understanding
Urban parking systems generate a large amount of operational and transactional data, but in many cases this data is poorly structured, making it difficult to extract meaningful insights. The objective of this project was to design a well-structured relational database for a parking management system that can support day-to-day operations as well as analytical and decision-making use cases.
The focus was not only on storing data but on ensuring that the design:
  -	avoids redundancy,
  -	maintains data integrity,
  -	supports future scalability, and
  -	enables meaningful analytical queries such as occupancy analysis, revenue trends, and user behavior.

## Approach and Methodology
The project was approached in a design-first manner rather than starting with raw data insertion.
  1.	Entity Identification
      Core entities such as users, vehicles, parking lots, parking slots, sessions, pricing, and payments were identified based on real-world parking workflows.
  2.	Relationship Mapping
      Relationships were defined carefully to reflect real-life dependencies (e.g., one user owning multiple vehicles, one parking lot containing multiple slots).
  3.	Normalization During Design
      Instead of creating an unstructured database and normalizing it later, normalization principles were applied directly during schema design. This ensured that the final schema                naturally complies with BCNF.
  4.	Query-Driven Validation
      The schema was validated by writing logical SQL queries to ensure it supports operational, analytical, and decision-support requirements.
This methodology ensured clarity, simplicity, and long-term usability.

## Tools and Technologies Used
  -	MySQL – Relational database management system
  -	SQL – Schema design, constraints, and analytical queries
  -	MySQL Workbench – Database modeling and query execution
  -	Markdown – Documentation and README preparation
The focus was intentionally kept on core database and SQL concepts rather than external frameworks.

## Challenges Faced
  - One of the main challenges was balancing completeness with simplicity. While it was tempting to add many entities and features, each addition was evaluated based on whether it genuinely     added value.
  - Another challenge involved handling data population decisions. Large-scale dummy data generation was initially explored but later avoided to prevent introducing artificial patterns that     could misrepresent real-world behavior. Instead, the design was validated using logical, data-agnostic queries and minimal manual data where required.
  - Additionally, enforcing foreign key constraints and safe update modes highlighted the importance of inserting and deleting data in the correct dependency order, reinforcing real-world       database discipline.

## Design and Creative Decisions
Several intentional design choices were made to differentiate this system:
-	 Normalization by Design
    The schema was designed with single-responsibility tables, ensuring normalization up to BCNF without requiring later decomposition.
-	 Derived Metrics Over Stored States
    Metrics such as parking occupancy are derived dynamically from active sessions rather than stored explicitly, preventing data inconsistency.
-	 Extensible Pricing Model
    Pricing was separated from sessions to support future extensions such as time-based or vehicle-type-based pricing without schema changes.
-	 Query Categorization
    SQL queries were grouped into access, operational, KPI, and decision-support categories to reflect different stakeholder needs rather than treating queries as isolated statements.
These decisions were made to prioritize clarity, scalability, and analytical usefulness over unnecessary complexity.

## Database Normalization Explanation
  ### Initial Concept
Conceptually, all parking-related information could exist in a single table containing user details, vehicle details, parking slot information, session timings, and payment data together. However, such a structure would result in significant redundancy. For example, the same user and vehicle details would repeat for every parking session, and pricing or payment details would be duplicated unnecessarily. This would also lead to update, insertion, and deletion anomalies.
  ### First Normal Form (1NF)
To satisfy First Normal Form, the database was designed so that:
-	Each column contains atomic values
-	There are no repeating groups or multi-valued attributes
This was achieved by separating core entities into individual tables such as users, vehicles, parking_sessions, and payments. Each table represents a single type of information, and each field stores only one value. As a result, all tables comply with 1NF.
  ### Second Normal Form (2NF)
Second Normal Form focuses on eliminating partial dependencies. In this design, surrogate primary keys (such as user_id, vehicle_id, and session_id) were used instead of composite keys. Because of this, all non-key attributes in each table depend entirely on the primary key and not on any subset of it. This ensures that the database naturally satisfies 2NF.
  ### Third Normal Form (3NF)
To achieve Third Normal Form, transitive dependencies were removed. This was done by separating logically independent attributes into their own tables. For example:
-	Vehicle type information was moved into a separate vehicle_types table
-	Pricing details were handled using a pricing_plans table
-	Parking lot details were separated from individual parking slots
This ensures that non-key attributes depend only on the primary key and not on other non-key attributes, thereby satisfying 3NF.
  ### Boyce-Codd Normal Form (BCNF)
The final schema satisfies BCNF because, in every table, all functional dependencies have a determinant that is a candidate key. Each table represents a single responsibility, and there are no hidden dependencies between attributes. For example, in the vehicles table, all attributes depend solely on vehicle_id, and in the payments table, payment details depend only on payment_id.
  ### Final Outcome
By applying normalization principles during the design phase itself, the database achieves a clean and efficient structure that minimizes redundancy, maintains data integrity, and supports scalable analytical queries. The final schema is fully normalized up to BCNF and is well-suited for real-world operational and analytical use cases.

