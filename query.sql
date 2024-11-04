CREATE TABLE `rakamin-kf-analytics-440607.kimia_farma.kf_tabel_analisis` AS
SELECT
    ft.transaction_id, ft.date, ft.branch_id, kc.branch_name, kc.kota, kc.provinsi, kc.rating AS rating_cabang, ft.customer_name, ft.product_id, p.product_name,      p.product_category, p.price AS actual_price, ft.discount_percentage,
-- Persentase Gross Laba berdasarkan kategori harga
    CASE
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price > 50000 THEN 0.15
        WHEN ft.price > 100000 THEN 0.20
        WHEN ft.price > 300000 THEN 0.25
        WHEN ft.price > 500000 THEN 0.30
    END AS persentase_gross_laba,
-- Menghitung Nett Sales setelah diskon 
    (ft.price * (1 - ft.discount_percentage / 100)) AS nett_sales,
-- Menghitung Nett Profit berdasarkan laba setelah diskon 
    ((ft.price * (1 - ft.discount_percentage / 100)) *
        CASE
            WHEN ft.price <= 50000 THEN 0.10
            WHEN ft.price > 50000 THEN 0.15
            WHEN ft.price > 100000 THEN 0.20
            WHEN ft.price > 300000 THEN 0.25
            WHEN ft.price > 500000 THEN 0.30
        END
    ) AS nett_profit,
    ft.rating AS rating_transaksi
FROM
    `kimiafarma.kf_final_transaction` ft
LEFT JOIN
    `kimiafarma.kf_kantor_cabang` kc ON ft.branch_id = kc.branch_id
LEFT JOIN
    `kimiafarma.kf_product` p ON ft.product_id = p.product_id;
