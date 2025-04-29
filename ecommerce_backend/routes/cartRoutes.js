const express = require("express");
const { auth } = require("../middleware/auth");
const {
  getCart,
  addToCart,
  removeFromCart,
  clearCart,
} = require("../controllers/cartController");
const cartRoutes = express.Router();

cartRoutes.get("/", auth, getCart);
cartRoutes.post("/add", auth, addToCart);
cartRoutes.post("/remove", auth, removeFromCart);
cartRoutes.post("/clear", auth, clearCart);

module.exports = cartRoutes;
