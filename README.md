# 🛍️ Social Media Campaign Analytics with SQL: David Jones EOFY Case Study

A relational database designed and built in **MySQL** to track the full customer journey for an online retailer: **ad view → ad click → order → payment**. The project then uses SQL to answer the Chief Marketing Officer's questions about social media campaign performance for the **End of Financial Year (EOFY) sale**.

> The case is based on David Jones. **All data is dummy data** created for this project. It is not affiliated with or endorsed by David Jones.

---

## 📌 Project Overview

| | |
|---|---|
| **Business goal** | Help the CMO improve return on social media ad spend by tracking CTR, conversion and revenue per campaign |
| **Key metric** | Social media **click-through rate (CTR)**, followed through to purchase |
| **Tools** | MySQL, MySQL Workbench |
| **Skills** | ER modelling (Chen's notation), normalisation, DDL with PK/FK constraints, dummy data generation, analytical SQL (JOINs, CASE, aggregation, GROUP BY) |
| **Deliverables** | ER diagram, SQL schema, dummy data, 7 business analysis queries, written report |

---

## 📂 Repository Structure

```
.
├── sql/
│   ├── 01_create_schema.sql       
│   ├── Insert Value.sql    
│   └── Business Case.sql     # The 7 analytical queries
├── docs/
│   └── ERD.png                     # ER diagram (Chen's notation)
└── README.md
```

---

## 🗄️ Part A: Database Design

### Entities

| Table | Purpose | Key fields |
|---|---|---|
| `Customer` | Users who view ads, click and buy | **CustomerID**, Full_Name, Email, Phone_Number, Registration_Date |
| `Social_Media_Platform` | Channels running ads (Instagram, Facebook, X, TikTok, …) | **PlatformID**, Platform_Name |
| `Advertisement` | Marketing campaigns | **AdID**, Campaign_Name, *PlatformID* |
| `Ad_View` | Ad impressions (associative) | **ViewID**, *CustomerID*, *AdID*, View_Time |
| `Ad_Click` | Ad clicks (associative) | **ClickID**, *CustomerID*, *AdID*, Click_Time |
| `Customer_Order` | Purchases, either ad-driven or organic | **OrderID**, *CustomerID*, *AdID* (nullable), Order_Date, Total_Amount |
| `Order_Detail` | Products in each order (associative) | **OrderID + ProductID**, Quantity, Unit_Price |
| `Product` | Items for sale | **ProductID**, Product_Name, Price, *CategoryID* |
| `Category` | Product groupings | **CategoryID**, Category_Name |
| `Payment` | Payment for each order | **PaymentID**, *OrderID*, Payment_Method, Payment_Date, Amount |

**Bold** = primary key · *Italic* = foreign key

### Relationships

- Platform **1 : M** Advertisement
- Customer **1 : M** Ad_View / Ad_Click / Customer_Order
- Advertisement **1 : M** Ad_View / Ad_Click
- Advertisement **1 : M (optional)** Customer_Order. A **nullable `AdID`** separates ad-driven orders from organic ones.
- Customer_Order **1 : M** Order_Detail **M : 1** Product (resolves the M:N between orders and products)
- Category **1 : M** Product
- Customer_Order **1 : 1** Payment

### ER Diagram

![ER Diagram](docs/ERD.png)

### Dummy Data

| Table | Rows |
|---|---|
| Customer | 12 |
| Social_Media_Platform | 10 |
| Category | 10 |
| Product | 12 |
| Advertisement | 10 |
| Ad_View | 30 |
| Ad_Click | 22 |
| Customer_Order | 14 |
| Order_Detail | 14 |
| Payment | 14 |

---

## 📊 Part B: Business Analysis Queries

| # | Business concern | SQL techniques | Key finding (dummy data) |
|---|---|---|---|
| 1 | **CTR by campaign** | `LEFT JOIN` views and clicks, `COUNT`, derived ratio | CTR ranges from 100% (e.g. EOFY Clothing Sale, Electronics Mega Sale) to 0% (Home Essentials, Luxury Accessories, Winter Collection) |
| 2 | **Click-to-purchase conversion** | `LEFT JOIN` on CustomerID + AdID, `COUNT(DISTINCT)` | Ads 1 and 2 convert at 66.7%, most at 50%, and Ad 8 at 0% |
| 3 | **Organic vs ad-driven orders** | `CASE WHEN AdID IS NULL`, `SUM`, `GROUP BY` | Ad-driven: 11 orders / 1,675 revenue. Organic: 3 orders / 210 revenue |
| 4 | **Revenue per campaign** | `LEFT JOIN`, `COUNT(DISTINCT)`, `SUM` | Sports Gear (300) and Clearance Event (220) lead. Home Essentials earned nothing. |
| 5 | **Product performance from ad-driven sales** | 3-table `JOIN`, `WHERE AdID IS NOT NULL` | Revenue is concentrated in high-value items (Smartphone 900, then Watch, Headphones, Perfume) |
| 6 | **Multi-ad exposure vs spending** | `COUNT(DISTINCT AdID)` per customer, `LEFT JOIN` orders | Customers who saw 3 ads spent 360–870, but exposure alone doesn't guarantee a purchase |
| 7 | **New vs existing customers** | `CASE` on Registration_Date, ad-driven filter | Existing customers 880 vs new customers 795, so both segments matter |

### Example: CTR by campaign

```sql
-- Paste your exact query from 03_business_queries.sql here
SELECT  a.Campaign_Name,
        COUNT(DISTINCT v.ViewID)  AS Total_Views,
        COUNT(DISTINCT c.ClickID) AS Total_Clicks,
        ROUND(COUNT(DISTINCT c.ClickID) / COUNT(DISTINCT v.ViewID) * 100, 2) AS CTR_Percent
FROM Advertisement a
LEFT JOIN Ad_View  v ON a.AdID = v.AdID
LEFT JOIN Ad_Click c ON a.AdID = c.AdID
GROUP BY a.Campaign_Name
ORDER BY CTR_Percent DESC;
```

---

## 💡 Recommendations for the CMO

1. **Shift budget to proven campaigns.** Put spend behind high-CTR, high-revenue campaigns and replicate what makes them work.
2. **Fix or pause zero-performers.** Redesign creative, calls to action and targeting for 0% CTR or 0% conversion ads (for example, Home Essentials), and use A/B testing.
3. **Lead with hero products.** Feature high-value products (smartphones, watches) in EOFY ads, and bundle them with lower-value items.
4. **Retarget engaged non-buyers.** Customers who saw several ads but didn't buy are the best retargeting audience.
5. **Balance acquisition and retention.** New and existing customers contribute similar ad-driven revenue.
6. **Improve attribution.** Track the time between click and order, and campaign cost, to measure true ROI.

---


---

## ⚠️ Limitations

- The dataset is small and synthetic (12 customers, 14 orders), so the results show how the analysis works rather than real performance.
- Campaign cost isn't stored, so "ROI" is measured as revenue per campaign. Adding a `Budget` column to `Advertisement` would allow true ROAS.

---

## 👤 Author

**Van Phong Nguyen**
Master's student, Macquarie University
📧 phongnguyenvan97dn@gmail.com
