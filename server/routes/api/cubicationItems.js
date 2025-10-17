const express = require('express');
const router = express.Router();

const passport = require('passport');
const CubicationItem = require('../../models/CubicationItem');
const Project = require('../../models/Project');

// @route   POST api/cubicationItems
// @desc    Create a cubication item for a project
// @access  Private
router.post(
  '/',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    Project.findById(req.body.project).then(project => {
      if (!project) {
        return res.status(404).json({ projectnotfound: 'No project found' });
      }

      const { length, width, height } = req.body.dimensions;
      const volume = length * width * height; // Simple calculation

      const newCubicationItem = new CubicationItem({
        project: req.body.project,
        description: req.body.description,
        unit: req.body.unit,
        formula: req.body.formula || 'L x W x H',
        dimensions: req.body.dimensions,
        wasteFactor: req.body.wasteFactor,
        laborEfficiency: req.body.laborEfficiency,
        // supplies will be added separately
      });

      // Here you could add more complex logic based on the formula
      // For now, we just save the item with the simple volume calculation implicitly done.

      newCubicationItem.save().then(item => res.json(item));
    });
  }
);

// @route   GET api/cubicationItems/project/:projectId
// @desc    Get all cubication items for a project
// @access  Private
router.get(
  '/project/:projectId',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    CubicationItem.find({ project: req.params.projectId })
      .then(items => {
        res.json(items);
      })
      .catch(err =>
        res.status(404).json({ noitemsfound: 'No cubication items found for this project' })
      );
  }
);

// @route   GET api/cubicationItems/:id
// @desc    Get a single cubication item by id
// @access  Private
router.get(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    CubicationItem.findById(req.params.id)
      .then(item => res.json(item))
      .catch(err =>
        res.status(404).json({ noitemfound: 'No cubication item found with that ID' })
      );
  }
);

// @route   PUT api/cubicationItems/:id
// @desc    Update a cubication item
// @access  Private
router.put(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    CubicationItem.findByIdAndUpdate(req.params.id, req.body, { new: true })
      .then(item => res.json(item))
      .catch(err =>
        res.status(400).json({ error: 'Unable to update the cubication item' })
      );
  }
);

// @route   DELETE api/cubicationItems/:id
// @desc    Delete a cubication item
// @access  Private
router.delete(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    CubicationItem.findByIdAndDelete(req.params.id)
      .then(() => res.json({ success: true }))
      .catch(err =>
        res.status(404).json({ noitemfound: 'No cubication item found with that ID' })
      );
  }
);

module.exports = router;
