const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const pool = require('../db');

const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = 'uploads/products';
    if (!fs.existsSync(uploadPath)) fs.mkdirSync(uploadPath, { recursive: true });
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    const ext = path.extname(file.originalname);
    cb(null, `product-${uniqueSuffix}${ext}`);
  },
});

const upload = multer({ storage });

router.post('/', upload.fields([{ name: "images", maxCount: 10 }]), async (req, res) => {
  const {
    business_id,
    sku,
    product_name,
    product_description,
    product_price,
    weight,
    product_quantity,
    manage_stock,
    stock_availability,
    category_id,
    product_status,
    product_visibility,
    color,
    size,
    url_key,
  } = req.body;

  const conn = await pool.getConnection();

  try {
    await conn.beginTransaction();

    const [productResult] = await conn.query(
      `INSERT INTO products (
        business_id, sku, product_name, product_description,
        product_price, weight, product_quantity,
        manage_stock, stock_availability,
        category_id, product_status,
        product_visibility, color, size,url_key
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        business_id,
        sku,
        product_name,
        product_description,
        product_price,
        weight,
        product_quantity,
        manage_stock,
        stock_availability,
        category_id || "1",
        product_status,
        product_visibility,
        color,
        size,
        url_key,
      ]
    );

    const product_id = productResult.insertId;

    if (req.files?.images?.length > 0) {
      for (const file of req.files.images) {
        const imageUrl = `/uploads/products/${file.filename}`;
        await conn.query(
          'INSERT INTO product_images (product_id, image_url) VALUES (?, ?)',
          [product_id, imageUrl]
        );
      }
    }

    await conn.commit();
    res.status(201).json({ product_id, message: 'Product and images saved successfully' });
  } catch (error) {
    await conn.rollback();
    console.error('Error saving product:', error);
    res.status(500).json({ error: error.message });
  } finally {
    conn.release();
  }
});

router.get('/', async (req, res) => {
  const { business_id } = req.query;
  if (!business_id) {
    return res.status(400).json({ error: "Missing business_id" });
  }

  try {
    const conn = await pool.getConnection();

    const [results] = await conn.query(`
      SELECT 
        p.product_id AS id, 
        p.product_name AS NAME,
        p.product_price AS PRICE,
        p.sku AS SKU,
        p.product_quantity AS STOCK,
        p.product_status AS STATUS,
        (
          SELECT image_url FROM product_images 
          WHERE product_id = p.product_id 
          LIMIT 1
        ) AS THUMBNAIL,
        (
          SELECT ROUND(AVG(rating), 1)
          FROM product_reviews
          WHERE product_id = p.product_id
        ) AS AVERAGE_RATING
      FROM products p
      WHERE p.business_id = ?
    `, [business_id]);

    const products = results.map(product => ({
      ...product,
      PRICE: `$${parseFloat(product.PRICE).toFixed(2)}`,
      THUMBNAIL: product.THUMBNAIL || 'https://via.placeholder.com/50',
      AVERAGE_RATING: product.AVERAGE_RATING !== null ? product.AVERAGE_RATING : 'N/A'
    }));

    conn.release();
    res.json({ products });
  } catch (err) {
    console.error("Error fetching products:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

  
router.get('/:id', async (req, res) => {
    const { id } = req.params;
  
    try {
      const conn = await pool.getConnection();
  
      const [productRows] = await conn.query('SELECT * FROM products WHERE product_id = ?', [id]);
  
      if (productRows.length === 0) {
        return res.status(404).json({ message: 'Product not found' });
      }
  
      const product = {};
      Object.entries(productRows[0]).forEach(([key, val]) => {
        product[key.toLowerCase()] = val;
      });
  
      const [imageRows] = await conn.query('SELECT image_url FROM product_images WHERE product_id = ?', [id]);
  
      product.images = imageRows.map((row) => row.image_url);
  
      conn.release();
  
      res.json(product);
    } catch (error) {
      console.error('Error fetching product:', error);
      res.status(500).json({ message: 'Server error' });
    }
  });
 
router.put('/unlist', async (req, res) => {
  const { product_id } = req.body;

  if (!Array.isArray(product_id) || product_id.length === 0) {
    return res.status(400).json({ error: "No products selected" });
  }

  try {
    const conn = await pool.getConnection();
    await conn.query(
      `UPDATE products SET product_status = 'disabled' WHERE product_id IN (?)`,
      [product_id]
    );
    conn.release();
    res.json({ message: "Selected products have been unlisted" });
  } catch (err) {
    console.error("Error unlisting products:", err);
    res.status(500).json({ error: "Server error while unlisting products" });
  }
});

router.put('/relist', async (req, res) => {
  const { product_id } = req.body;

  if (!Array.isArray(product_id) || product_id.length === 0) {
    return res.status(400).json({ error: "No products selected" });
  }

  try {
    const conn = await pool.getConnection();
    await conn.query(
      `UPDATE products SET product_status = 'enabled' WHERE product_id IN (?)`,
      [product_id]
    );
    conn.release();
    res.json({ message: "Selected products have been relisted" });
  } catch (err) {
    console.error("Error relisting products:", err);
    res.status(500).json({ error: "Server error while relisting products" });
  }
});

router.delete("/delete", async (req, res) => {
  const { product_id } = req.body;

  if (!Array.isArray(product_id) || product_id.length === 0) {
    return res.status(400).json({ error: "No products selected" });
  }

  try {
    const conn = await pool.getConnection();
    await conn.query(
      `UPDATE products SET product_status = 'deleted' WHERE product_id IN (?)`,
      [product_id]
    );
    conn.release();
    res.json({ message: "Selected products marked as deleted." });
  } catch (err) {
    console.error("Error soft-deleting products:", err);
    res.status(500).json({ error: "Server error while soft-deleting products" });
  }
});


router.put("/:id", upload.array("images"), async (req, res) => {
  const { id } = req.params;

  const {
    product_name, sku, product_price, product_description,
    weight, manage_stock, product_quantity, product_status,
    product_visibility, url_key, stock_availability, business_id, category_id, color, size,
    removedImages 
  } = req.body;

  try {
    const conn = await pool.getConnection();

    await conn.query(
      `UPDATE products SET 
        product_name=?, sku=?, product_price=?, product_description=?, weight=?, 
        manage_stock=?, product_quantity=?, product_status=?, product_visibility=?, 
        url_key=?, stock_availability=?, business_id=?, category_id=?, color=?, size=?
        WHERE product_id=?`,
      [
        product_name, sku, product_price, product_description, weight,
        manage_stock, product_quantity, product_status, product_visibility,
        url_key, stock_availability, business_id, category_id, color, size, id,
      ]
    );

    if (removedImages) {
      const parsed = JSON.parse(removedImages);
      for (const imageUrl of parsed) {
        const relativePath = imageUrl.replace(`${process.env.BACKEND_URL || "http://localhost:8080"}`, "");
        const imagePath = path.join(__dirname, "..", relativePath);
        try {
          fs.unlinkSync(imagePath);
        } catch (err) {
          console.warn("File not found or couldn't delete:", imagePath);
        }
        await conn.query("DELETE FROM product_images WHERE product_id = ? AND image_url = ?", [id, relativePath]);
      }
    }

    if (req.files && req.files.length > 0) {
      const imageInsertValues = req.files.map(file => [id, `/uploads/products/${file.filename}`]);
      await conn.query("INSERT INTO product_images (product_id, image_url) VALUES ?", [imageInsertValues]);
    }

    res.json({ message: "Product updated successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to update product" });
  }
});
