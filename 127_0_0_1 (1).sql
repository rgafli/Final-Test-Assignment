-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2023 at 03:45 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterit`
--
CREATE DATABASE IF NOT EXISTS `barterit` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `barterit`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `item_name` varchar(55) NOT NULL,
  `item_qty` int(5) NOT NULL,
  `item_desc` varchar(255) NOT NULL,
  `item_lat` varchar(55) NOT NULL,
  `item_long` varchar(55) NOT NULL,
  `item_state` varchar(55) NOT NULL,
  `item_locality` varchar(55) NOT NULL,
  `item_date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `item_name`, `item_qty`, `item_desc`, `item_lat`, `item_long`, `item_state`, `item_locality`, `item_date`) VALUES
(11, 8, 'Mouse', 4, 'Lightning fast mouse', '6.4632435', '100.498525', 'Kedah', 'Changlun', '2023-07-19'),
(12, 8, 'Bottle Polar', 4, 'Insulated Bottle', '6.4632357', '100.4985283', 'Kedah', 'Changlun', '2023-07-19'),
(13, 8, 'Adapter', 5, 'Adapter', '6.4632448', '100.4985109', 'Kedah', 'Changlun', '2023-07-19'),
(14, 9, 'Powerbank', 3, 'Fast-charging', '6.4632418', '100.4985262', 'Kedah', 'Changlun', '2023-07-19'),
(15, 8, 'Vinarmin', 2, 'Drink', '6.4632423', '100.4985166', 'Kedah', 'Changlun', '2023-07-19'),
(16, 8, 'Plastic', 5, 'Bottle', '6.4632382', '100.4985254', 'Kedah', 'Changlun', '2023-07-20'),
(17, 8, 'Laptop', 3, 'HP', '6.4632467', '100.4985478', 'Kedah', 'Changlun', '2023-07-20');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_order`
--

CREATE TABLE `tbl_order` (
  `order_id` int(5) NOT NULL,
  `buyer_id` int(5) NOT NULL,
  `buyer_name` varchar(255) NOT NULL,
  `seller_id` int(5) NOT NULL,
  `seller_name` varchar(255) NOT NULL,
  `buyer_item_id` int(5) NOT NULL,
  `seller_item_id` int(5) NOT NULL,
  `order_status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_order`
--

INSERT INTO `tbl_order` (`order_id`, `buyer_id`, `buyer_name`, `seller_id`, `seller_name`, `buyer_item_id`, `seller_item_id`, `order_status`) VALUES
(5, 9, 'mama', 8, 'rashal', 14, 11, 'Success'),
(6, 8, 'rashal', 9, 'mama', 12, 14, 'Success'),
(7, 8, 'rashal', 9, 'mama', 11, 14, 'Rejected');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_password` varchar(50) NOT NULL,
  `user_otp` int(5) NOT NULL,
  `user_datareg` date NOT NULL DEFAULT current_timestamp(),
  `user_coin` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_name`, `user_email`, `user_password`, `user_otp`, `user_datareg`, `user_coin`) VALUES
(8, 'rashal', 'rgafli@gmail.com', '7aca1cc7fb120da1873443af37f7b02e8ca9ef4c', 86543, '2023-07-15', 10),
(9, 'mama', 'mamagafli@gmail.com', '7aca1cc7fb120da1873443af37f7b02e8ca9ef4c', 20751, '2023-07-15', 40);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `tbl_order`
--
ALTER TABLE `tbl_order`
  MODIFY `order_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
