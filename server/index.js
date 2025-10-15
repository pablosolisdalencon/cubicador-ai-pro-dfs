const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const passport = require('passport');
const users = require('./routes/api/users');
const projects = require('./routes/api/projects');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(passport.initialize());

// Passport Config
require('./config/passport')(passport);

// DB Config
const db = process.env.MONGO_URI;

// Connect to MongoDB
mongoose
  .connect(db)
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log(err));

// Use Routes
app.use('/api/users', users);
app.use('/api/projects', projects);

// Google Auth routes
app.get(
  '/auth/google',
  passport.authenticate('google', { scope: ['profile', 'email'] })
);

app.get(
  '/auth/google/callback',
  passport.authenticate('google', { failureRedirect: '/login', session: false }),
  (req, res) => {
    const payload = { id: req.user.id, name: req.user.name };
    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: 3600 },
      (err, token) => {
        res.redirect(`http://localhost:3000/login?token=${token}`);
      }
    );
  }
);

// Basic route
app.get('/', (req, res) => {
  res.send('API is running...');
});

const PORT = process.env.PORT || 3001;

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
