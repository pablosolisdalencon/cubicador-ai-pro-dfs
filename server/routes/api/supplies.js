const express = require('express');
const router = express.Router();

const passport = require('passport');
const Supply = require('../../models/Supply');

// @route   POST api/supplies
// @desc    Create a new supply
// @access  Private
router.post(
  '/',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    const newSupply = new Supply({
      name: req.body.name,
      type: req.body.type,
      unitPrice: req.body.unitPrice,
      measurementUnit: req.body.measurementUnit,
      efficiency: req.body.efficiency
    });

    newSupply.save().then(supply => res.json(supply));
  }
);

// @route   GET api/supplies
// @desc    Get all supplies
// @access  Public
router.get('/', (req, res) => {
  Supply.find()
    .sort({ name: 1 })
    .then(supplies => res.json(supplies))
    .catch(err => res.status(404).json({ nosuppliesfound: 'No supplies found' }));
});

// @route   GET api/supplies/:id
// @desc    Get supply by id
// @access  Public
router.get('/:id', (req, res) => {
  Supply.findById(req.params.id)
    .then(supply => res.json(supply))
    .catch(err =>
      res.status(404).json({ nosupplyfound: 'No supply found with that ID' })
    );
});

// @route   PUT api/supplies/:id
// @desc    Update supply
// @access  Private
router.put(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    Supply.findByIdAndUpdate(req.params.id, req.body, { new: true })
      .then(supply => res.json(supply))
      .catch(err =>
        res.status(400).json({ error: 'Unable to update the Database' })
      );
  }
);

// @route   DELETE api/supplies/:id
// @desc    Delete supply
// @access  Private
router.delete(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    Supply.findByIdAndDelete(req.params.id)
      .then(() => res.json({ success: true }))
      .catch(err => res.status(404).json({ nosupplyfound: 'No supply found with that ID' }));
  }
);

module.exports = router;
