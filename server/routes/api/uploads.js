const express = require('express');
const router = express.Router();
const multer = require('multer');
const passport = require('passport');
const path = require('path');

// Multer storage configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'server/uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`);
  }
});

const upload = multer({ storage: storage });

// @route   POST api/uploads/plan
// @desc    Upload a plan image
// @access  Private
router.post(
  '/plan',
  passport.authenticate('jwt', { session: false }),
  upload.single('plan'),
  (req, res) => {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }
    // For now, just return the path to the uploaded file
    // Later, this will be associated with a project
    res.json({ filePath: `/uploads/${req.file.filename}` });
  }
);

module.exports = router;
