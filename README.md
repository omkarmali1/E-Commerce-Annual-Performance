# 💰 E-Commerce-Annual-Performance
<br>

**Tool** : SQL Workbench <br> 
**Visualization** : Microsoft Excel <br>
<br>
<br>
---

## 📂 **STAGE 0: Problem Statement**

### **Background Story**
Measuring business performance is a very important aspect for a company. It helps in monitoring and evaluating the success or failure of various business processes. Business performance measurement can be carried out by considering several business metrics. In this project, an analysis of the business performance of an eCommerce company will be conducted using business metrics such as customer growth, product quality, and payment types based on historical data over a period of three years.

### **Objective**
Gather insights from the analysis and with visualizations in the form of:
1. **Annual Customer Activity Growth**
2. **Annual Product Category Quality**
3. **Annual Payment Type Usage**
<br>
<br>

---

## 📂 **STAGE 1: Data Preparation**

The dataset used is from a Brazilian eCommerce company that contains order information with a total of 99,441 entries from 2016 to 2018. There are features that provide information such as order status, location, item details, payment type, and reviews.

### **Create Database and ERD**
**The steps involved include:**
1)Creating a database workspace in pgAdmin and creating a table using the CREATE TABLE statement.
2)Importing CSV data into the database.
3)Setting a Primary Key or Foreign Key using the ALTER TABLE statement.
4)Creating and exporting an ERD (Entity Relationship Diagram). <br>

**Schema:** <br>
<p align="center">
  <kbd><img src="Images/Schema.png" width=800px> </kbd> <br>
  Schema
</p>
<br>
<br>

---

## 📂 **STAGE 2: Data Analysis**

### **1. Annual Customer Activity Growth**

The growth of annual customer activity can be analyzed from Monthly Active Users (MAU), new customers, repeat order customers, and the average order per customer.

<p align="center">
Tabel 1. Analysis Results of Annual Customer Activity Growth  <br>
  <kbd><img src="Images/Cust_growth_mat.png" width=800px> </kbd> <br>
</p>

<br>
Overall, the company experienced an increase in Monthly Active Users and new customers every year. A significant increase occurred from 2016 to 2017, as transaction data in 2016 began in September <br>
<p align="center">
  <kbd><img src="Images/ACAGA_tot_new_cust.png" width=600px> </kbd> <br>
  Fig 1. Average MAU and New Customers Graph
</p>


<br>
<br>
A significant increase also occurred in the number of customers who placed repeat orders from 2016 to 2017. However, there was a slight decrease in 2018.<br>
<p align="center">
  <kbd><img src="Images/ACAGA_repeat_order_cust.png" width=600px> </kbd> <br>
  Image 2. Graph of the Number of Customers Who Make Repeat Orders
</p>

<br>
<br>

From the analysis and the graph below, it can be observed that the average number of customers each year tends to only place orders once, indicating that the majority of customers do not place repeat orders..<br>
<p align="center">
  <kbd><img src="Images/ACAGA_freq_cust_order.png" width=600px> </kbd> <br>
  Fig 3. Average Frequency of Customer Orders
</p>


<br>

### **2. Annual Product Category Quality**

The annual product category quality can be analyzed based on total revenue, total order cancellations, top product categories, and categories with the highest cancellation rates.


<p align="center">
  Tabel 2. The Result of Annual Product Category Analysis <br>
  <kbd><img src="asset/produk.png" width=1000px> </kbd> <br>
</p>

<br>

Overall, the company's revenue increases every year.. <br>
<br>
<p align="center">
  <kbd><img src="asset/gambar_5_total_revenue.png" width=600px> </kbd> <br>
Fig . Total Revenue Per Year
</p>


<br>

<p align="center">
  <kbd><img src="asset/gambar_6_top.png" width=600px> </kbd> <br>
  
fig 5. Total Revenue Top Products Graph Per Year
</p>

The revenue generated from the top products also increases for each year. Additionally, each year has a different top product category. In 2018, the company generated the highest revenue with the top product category of health and beauty. <br>
<br>
<br>

<p align="center">
  <kbd><img src="asset/gambar_7_cenceled.png" width=600px> </kbd> <br>
  Gambar 7. Grafik Total Revenue Top Produk Pertahun
</p>

Produk yang sering dibatalkan oleh pelanggan untuk setiap tahunnya juga memiliki jenis kategori yang berbeda dan terus mengalami kenaikan. Tahun 2018 memiliki jumlah produk yang dibatalkan paling banyak dan memiliki jenis kategori yang sama dengan top produk yang paling banyak menghasilkan revenue. Hal tersebut dapat diduga karena jenis kategori kesehatan dan kecantikan sedang mendominasi pasar.  <br>
<br>

### **3. Annual Payment Type Usage**
Tipe pembayaran yang digunakan pelanggan dapat dianalisis dari jenis pembayaran favorit dan jumlah penggunaan untuk setiap jenis pembayaran pertahun. 

<details>
  <summary>Click untuk melihat Queries</summary>

  ```sql
-- 1) Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time diurutkan dari yang terfavorit
SELECT payment_type, COUNT(1) 
FROM order_payments_dataset
GROUP BY 1
ORDER BY 2 DESC;

-- 2)Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun
SELECT
	payment_type,
	SUM(CASE WHEN year = 2016 THEN total ELSE 0 END) AS "2016",
	SUM(CASE WHEN year = 2017 THEN total ELSE 0 END) AS "2017",
	SUM(CASE WHEN year = 2018 THEN total ELSE 0 END) AS "2018",
	SUM(total) AS sum_payment_type_usage
FROM (
	SELECT 
		date_part('year', od.order_purchase_timestamp) as year,
		opd.payment_type,
		COUNT(opd.payment_type) AS total
	FROM orders_dataset AS od
	JOIN order_payments_dataset AS opd 
		ON od.order_id = opd.order_id
	GROUP BY 1, 2
	) AS sub
GROUP BY 1
ORDER BY 2 DESC;
  ```
</details>

<p align="center">
  Tabel 3. Hasil Analisis Tipe Pembayaran yang Digunakan Pelanggan <br>
  <kbd><img src="asset/payment.png" width=600px> </kbd> <br>
</p>

<br>
<p align="center">
  <kbd><img src="asset/gambar_8_tipe_pembayaran.png" width=600px> </kbd> <br>
  Gambar 8. Grafik Tipe Pembayaran yang Digunakan Pelanggan Pertahun
</p>

Mayoritas pelanggan melakukan pembayaran menggunakan kartu kredit dan cenderung mengalami peningkatan setiap tahunnya. Pembayaran menggunakan voucher meningkat pada tahun 2017, namun menurun pada tahun 2018. Hal tersebut dapat diduga karena ketersediaan voucher yang diberikan perusahaan lebih sedikit dari tahun lalu. Disisi lain, pelanggan yang melakukan pembayaran dengan kartu debit meningkat secara signifikan pada tahun 2018. Hal tersebut dapat diduga karena kemungkinan terdapat promosi pembayaran untuk kartu debit, sehingga banyak pelanggan yang tertarik untuk menggunakan metode tersebut.
<br>
<br>


---

## 📂 **STAGE 3: Summary**
- Dilihat dari analisis pertumbuhan tahunan pelanggan dapat disimpulkan bahwa **jumlah pelanggan baru dan aktif (MAU) meningkat setiap tahunnya**, namun pelanggan cenderung tidak repeat order atau hanya melakukan pembelian satu kali. Dari hal tersebut perlu adanya strategi bisnis untuk meningkatkan minat pelanggan agar melakukan pembelian misalnya dengan pemberian promo, *call to action*, dan lain sebagainya.
- Dari analisis kualitas produk tahunan, **revenue terus meningkat dengan kategori produk yang berbeda setiap tahunnya**. Kategori **kesehatan dan kecantikan** menjadi produk best seller sekaligus produk yang paling sering dibatalkan pembeliannya pada tahun 2018. Berdasarkan hasil analisis ini dapat dilakukan strategi bisnis berupa riset produk apa yang akan menjadi trend di tahun selanjutnya, sehingga diharapkan dapat memperbesar peluang perusahaan mendapatkan revenue.
- **Kartu kredit** merupakan tipe pembayaran mayoritas yang digunakan oleh pelanggan.
