-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2025 at 09:55 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fabriq`
--

-- --------------------------------------------------------

--
-- Table structure for table `businesses`
--

CREATE TABLE `businesses` (
  `business_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `business_name` varchar(225) NOT NULL,
  `business_email` varchar(225) DEFAULT NULL,
  `business_phone` varchar(20) DEFAULT NULL,
  `address` varchar(225) DEFAULT NULL,
  `city` varchar(225) DEFAULT NULL,
  `country` varchar(225) DEFAULT NULL,
  `business_description` varchar(255) DEFAULT NULL,
  `business_logo_url` varchar(225) DEFAULT NULL,
  `license_image_url` varchar(255) NOT NULL,
  `commission_percentage` decimal(5,2) DEFAULT NULL,
  `average_rating` decimal(2,1) DEFAULT NULL,
  `has_ai_access` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `businesses`
--

INSERT INTO `businesses` (`business_id`, `user_id`, `business_name`, `business_email`, `business_phone`, `address`, `city`, `country`, `business_description`, `business_logo_url`, `license_image_url`, `commission_percentage`, `average_rating`, `has_ai_access`, `created_at`) VALUES
(1, 11, 'SomeThing', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '/uploads/licenses/1742248471775-492621145.jpg', NULL, NULL, 1, '2025-03-17 21:54:31'),
(3, 24, 'Nothing', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '/uploads/licenses/1742324320693-329009230.jpg', NULL, NULL, NULL, '2025-03-18 18:58:40'),
(4, 27, '123.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '/uploads/licenses/1742355886236-238639203.jpg', NULL, NULL, NULL, '2025-03-19 03:44:46');

-- --------------------------------------------------------

--
-- Table structure for table `business_reviews`
--

CREATE TABLE `business_reviews` (
  `review_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `rating` decimal(2,1) NOT NULL,
  `review_text` varchar(600) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_reviews`
--

INSERT INTO `business_reviews` (`review_id`, `user_id`, `business_id`, `rating`, `review_text`, `created_at`) VALUES
(1, 30, 1, 3.4, 'Information feedback is a concept that refers to responses that inform an individual about the correctness, physical effect, or social or emotional impact of his or her behavior or thinking. It is similar to the principle behind knowledge of results, which states that immediate feedback is beneficial to learning. Feedback can be evaluative or corrective information about an action, event, or process. It can also be helpful information or criticism that is given to someone to say what can be done to improve a performance, product, etc..', '2025-03-25 02:14:28'),
(2, 12, 1, 4.2, 'sdcCZXVc', '2025-03-25 02:14:39');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(225) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(1, 'Shoes');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `platform_commission_amount` decimal(10,2) NOT NULL,
  `business_earnings` decimal(10,2) NOT NULL,
  `order_status` enum('pending','shipped','delivered','cancelled') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `total_amount`, `platform_commission_amount`, `business_earnings`, `order_status`, `created_at`) VALUES
(1, 22, 234.00, 23.00, 223.00, 'pending', '2025-03-19 15:28:01'),
(2, 15, 234.00, 23.00, 223.00, 'shipped', '2025-03-19 15:33:23'),
(3, 15, 456.00, 33.00, 45.00, 'delivered', '2025-03-20 00:14:58'),
(4, 12, 234.00, 12345.00, 1234.00, 'cancelled', '2025-03-20 00:14:58'),
(5, 16, 234.00, 23.00, 223.00, 'delivered', '2024-05-06 06:35:02'),
(6, 30, 456.00, 23.00, 429.00, 'pending', '2025-03-12 22:32:10');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `item_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`item_id`, `order_id`, `product_id`, `quantity`, `item_price`) VALUES
(1, 1, 13, 1, 234.00),
(2, 2, 22, 1, 234.00),
(3, 4, 13, 1545, 0.00),
(4, 3, 14, 1, 234.00),
(5, 3, 22, 1, 234.00),
(6, 5, 13, 1, 234.00),
(7, 6, 13, 1, 423.00);

-- --------------------------------------------------------

--
-- Table structure for table `otp_tokens`
--

CREATE TABLE `otp_tokens` (
  `otp_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `otp` int(11) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_method` enum('credit_card','debit_card','paypal','cod','e-wallet','bank_transfer') NOT NULL,
  `payment_status` enum('pending','completed','failed','refunded') NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `order_id`, `payment_method`, `payment_status`, `amount_paid`, `payment_date`) VALUES
(3, 1, 'credit_card', 'failed', 0.00, '2025-03-19 15:44:26'),
(4, 2, 'credit_card', 'completed', 234.00, '2025-03-19 23:18:29'),
(5, 5, 'debit_card', 'completed', 234.00, '2025-03-20 06:38:03'),
(6, 6, 'credit_card', 'completed', 456.00, '2025-03-24 22:34:54');

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `payment_methods_id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `payment_type` enum('credit card','debit card','paypal','bank_transfer','cod') NOT NULL,
  `payment_details` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `product_name` varchar(225) NOT NULL,
  `product_description` varchar(255) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `weight` decimal(10,2) NOT NULL,
  `product_quantity` int(11) NOT NULL,
  `manage_stock` enum('No','Yes') NOT NULL,
  `stock_availability` enum('No','Yes') NOT NULL,
  `category_id` int(11) NOT NULL,
  `average_rating` decimal(2,1) DEFAULT NULL,
  `product_status` enum('disabled','enabled','deleted') NOT NULL,
  `product_visibility` enum('not_visible','visible') NOT NULL,
  `color` varchar(225) NOT NULL,
  `size` varchar(225) NOT NULL,
  `url_key` varchar(225) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `business_id`, `sku`, `product_name`, `product_description`, `product_price`, `weight`, `product_quantity`, `manage_stock`, `stock_availability`, `category_id`, `average_rating`, `product_status`, `product_visibility`, `color`, `size`, `url_key`, `created_at`) VALUES
(12, 1, 'cvzx', 'Xjksbvk', 'adscvz', 3.00, 31.00, 23, 'Yes', 'Yes', 1, NULL, 'enabled', 'visible', 'Blue', 'Small', 'xzcczxc', '2025-03-19 01:47:20'),
(13, 1, 'zxcvz', 'cZXc', 'asdsfasv', 234.00, 22.00, 33, 'Yes', 'Yes', 1, NULL, 'enabled', 'visible', 'dsvas', 'Small', 'wefasdf', '2025-03-19 02:06:22'),
(14, 1, '123', 'Zaid', 'vczxc', 23.00, 22.00, 45, 'Yes', 'Yes', 1, NULL, 'enabled', 'visible', 'df', 'Small', 'zxcvzxc', '2025-03-19 02:17:08'),
(19, 1, 'cvz', 'ZA', '223', 23.00, 322.00, 23, 'No', 'No', 1, NULL, 'enabled', 'not_visible', '23', 'Small', 'adfs', '2025-03-19 02:29:00'),
(20, 1, 'daf', 'Sewadf', 'adsf', 23.00, 33.00, 3, 'Yes', 'Yes', 1, NULL, 'deleted', 'visible', 'adsc', 'Small', 'adf', '2025-03-19 03:06:44'),
(21, 1, 'cs', 'asc', 'sadvz', 34.00, 6.00, 0, 'No', 'No', 1, NULL, 'enabled', 'not_visible', 'cz', 'Small', 'sdaf', '2025-03-19 03:07:17'),
(22, 3, '234', 'Zawe', 'asdfsd', 23.00, 2.00, 23, 'Yes', 'Yes', 1, NULL, 'enabled', 'not_visible', 'Red', 'Small', 'sffgfs', '2025-03-19 15:32:28');

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `image_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image_url` varchar(225) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`image_id`, `product_id`, `image_url`, `created_at`) VALUES
(33, 12, '/uploads/products/product-1742348840879-849762646.png', '2025-03-19 01:47:20'),
(40, 19, '/uploads/products/product-1742351340263-772129662.png', '2025-03-19 02:29:00'),
(41, 14, '/uploads/products/product-1742353416672-553010826.png', '2025-03-19 03:03:36'),
(42, 20, '/uploads/products/product-1742353604267-460427909.png', '2025-03-19 03:06:44'),
(43, 21, '/uploads/products/product-1742353637876-111860263.png', '2025-03-19 03:07:17'),
(44, 12, '/uploads/products/product-1742386528251-918259965.png', '2025-03-19 12:15:28'),
(45, 13, '/uploads/products/product-1742449229810-47384068.png', '2025-03-20 05:40:29');

-- --------------------------------------------------------

--
-- Table structure for table `product_reviews`
--

CREATE TABLE `product_reviews` (
  `review_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `rating` decimal(2,1) NOT NULL,
  `review_text` varchar(600) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_reviews`
--

INSERT INTO `product_reviews` (`review_id`, `user_id`, `product_id`, `rating`, `review_text`, `created_at`) VALUES
(1, 30, 13, 3.4, 'nformation feedback is a concept that refers to responses that inform an individual about the correctness, physical effect, or social or emotional impact of his or her behavior or thinking. It is similar to the principle behind knowledge of results, which states that immediate feedback is beneficial to learning. Feedback can be evaluative or corrective information about an action, event, or process. It can also be helpful information or criticism that is given to someone to say what can be done to improve a performance, product, etc', '2025-03-24 22:47:08'),
(2, 11, 12, 1.2, 'safgsg', '2025-03-25 01:24:16'),
(3, 15, 12, 4.2, 'DVCZZVCV', '2025-03-25 01:25:28'),
(4, 15, 14, 5.0, 'zfvzvsa', '2025-03-25 01:25:28');

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `token_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(225) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`token_id`, `user_id`, `token`, `expires_at`, `created_at`) VALUES
(61, 11, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsImlhdCI6MTc0MjkyNjM5MSwiZXhwIjoxNzQ1NTE4MzkxfQ.Mis2gMNYWN2XAEjL4jJlzoCuieme1_ig2uRvMKtYcVo', '2025-04-24 23:13:11', '2025-03-25 18:13:11');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `rating` decimal(2,1) NOT NULL,
  `review_text` varchar(600) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `user_id`, `product_id`, `rating`, `review_text`, `created_at`) VALUES
(2, 11, 12, 3.4, 'fgzx', '2025-03-24 15:59:58');

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `subscription_id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `subscription_status` enum('active','expired','cancelled') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `plan_id` int(11) NOT NULL,
  `plan_name` varchar(225) NOT NULL,
  `plan_price` decimal(10,2) NOT NULL,
  `plan_duration_days` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(225) NOT NULL,
  `last_name` varchar(225) NOT NULL,
  `email` varchar(225) NOT NULL,
  `password` varchar(255) NOT NULL,
  `address` varchar(225) DEFAULT NULL,
  `city` varchar(225) DEFAULT NULL,
  `country` varchar(225) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `user_type` enum('customer','business','admin') NOT NULL,
  `verified` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `password`, `address`, `city`, `country`, `phone_number`, `user_type`, `verified`, `created_at`) VALUES
(11, 'Zaid', 'Ali', 'smza.hp@gmail.com', '$2b$10$DZhjWoThaZC5rHOQx3qzLOrK72CtHIXXhyaciTOp6z0UmlI39Aio.', NULL, NULL, NULL, NULL, 'business', 1, '2025-03-17 21:54:31'),
(12, 'Zaid', 'Ali', 'zaidalis2a@gmail.com', '$2b$10$N/X758NcUI.3IYexqkuBJult1B6Oc3hyhEwOjoOnY2ClLrPhprxoS', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-17 22:26:02'),
(13, 'Zaid', 'Ali', 'smzaidali2004@gmail.com', '$2b$10$eo/cNWf6bB0qKwmSnCfNS.N7wFrI.GgqJvjgMTtEYGldg5ISfSPau', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-17 23:08:12'),
(15, 'Zaid', 'Ali', 'B@mail.com', '$2b$10$6ce5VdglBAIFYBAvKu5NLu8l3yivRhsqxBoLEedyENd//sJLqs3s6', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-18 13:18:12'),
(16, 'Syed Muhammad', 'Saadullah', 'smsaadullah07@gmail.com', '$2b$10$QRBuAsWDByPGON/wb0z5u.RE1QUfrdIv80AKb4io0IOauvgH8/D2K', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-18 13:41:16'),
(19, 'Zaid', 'Ali', 'smzali31@gmail.com', '$2b$10$iSvyMCFDKyMHxt6k2KN2iOeZCq.NQuWzC8L4VYX4L6gIbYCv.I1KW', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-18 15:20:30'),
(20, 'Zaid', 'Ali', 'Z@mail.com', '$2b$10$Z5hFoT7pN6OdzxTyG948lOKHZ1eGx5oyf8MmVRQK4ON2sgDQXDuGe', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-18 17:15:10'),
(21, 'Zaid', 'Ali', 'c@mail.com', '$2b$10$St0LyqerYbjmfWTl/xstP.dJFxRZQrYQ5cOMWYihODzTsfkPoJ6rq', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-18 17:24:26'),
(22, 'Zaid', 'Ali', 'e@mail.com', '$2b$10$5mLmBNShg6CJ1sBEfl0fTeOex.k/Tx8D67lMSIo9Txn98JDuoZY/e', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-18 17:34:11'),
(23, 'Zaid', 'Ali', 'p@mail.com', '$2b$10$gBCCH1q6PnM4IUWjxUrLdOMz8zXXsPz4hjDTd28KXgCo87eQlrOZa', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-18 17:37:28'),
(24, 'Zaid', 'Ali', 'q@mail.com', '$2b$10$LWK4laZ.DcOkQPcxpqiqZegghaF8WKnJdzVdCzVH0l48mAin9CbYS', NULL, NULL, NULL, NULL, 'business', 1, '2025-03-18 18:58:40'),
(25, 'Zaid', 'Ali', 'r@gmail.com', '$2b$10$MjRO.MsjwKKPD6uA4tbzxuj4HX7ZBKJn2kob934ESPwfXdcTMx3ki', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-18 19:05:54'),
(26, 'Zaid', 'Ali', 'smzali1@gmail.com', '$2b$10$r7aIE0SKS1VtbWOoduqAF.7uO77ZSSbs7XFncCh93BmiBya8caRea', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-19 03:43:09'),
(27, 'Zaid', 'Ali', '2@mail.com', '$2b$10$Oq3.QMEgDcCgOyK.1TNe4eDE/0DTVQLA5rTQrn1NcpuoMrgg1cbPW', NULL, NULL, NULL, NULL, 'business', 1, '2025-03-19 03:44:46'),
(28, 'Zaid', 'Ali', '2@12.com', '$2b$10$uB7Kg/KrzfnC9qac9Y.NOehAJOwFPQZFkIHCAJ1JnRrFJl/WE4A.m', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-19 03:57:26'),
(29, 'Zaid', 'Ali', 'u@mail.com', '$2b$10$FaBOAeNCF/6GNfRo2aKmzeltqgIuoDlf3ib4vd6b.IuAiKB/XPTre', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-19 04:25:59'),
(30, 'Tom', 'Hat', 'tom@mail.com', '$2b$10$Kjk.JR1amaAg8Mv53Ww5BO7bWnVKpCdAxVjCCkJJFyLTnbx5hdQdK', NULL, NULL, NULL, NULL, 'customer', 1, '2025-03-20 12:52:27');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `businesses`
--
ALTER TABLE `businesses`
  ADD PRIMARY KEY (`business_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `business_reviews`
--
ALTER TABLE `business_reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `business_id` (`business_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `otp_tokens`
--
ALTER TABLE `otp_tokens`
  ADD PRIMARY KEY (`otp_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`payment_methods_id`),
  ADD KEY `business_id` (`business_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `business_id` (`business_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`token_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`subscription_id`),
  ADD KEY `business_id` (`business_id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`plan_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `businesses`
--
ALTER TABLE `businesses`
  MODIFY `business_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `business_reviews`
--
ALTER TABLE `business_reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `otp_tokens`
--
ALTER TABLE `otp_tokens`
  MODIFY `otp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `payment_methods_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `token_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `subscription_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `plan_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `businesses`
--
ALTER TABLE `businesses`
  ADD CONSTRAINT `businesses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `business_reviews`
--
ALTER TABLE `business_reviews`
  ADD CONSTRAINT `business_reviews_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `business_reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `otp_tokens`
--
ALTER TABLE `otp_tokens`
  ADD CONSTRAINT `otp_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Constraints for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD CONSTRAINT `payment_methods_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `product_reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `subscriptions_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subscriptions_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`plan_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
