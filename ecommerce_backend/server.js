const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");
const productRouter = require("./routes/productRoutes");
const cartRouter = require("./routes/cartRoutes");
const authRouter = require("./routes/authRoutes");
const orderRouter = require("./routes/orderRoutes");
const notificationRouter = require('./routes/notificationRoutes');

require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

mongoose
  .connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));

app.use("/api/products", productRouter);
app.use("/api/cart", cartRouter);
app.use("/api/auth", authRouter);
app.use('/api/orders', orderRouter)
app.use('/api/notifications', notificationRouter);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
