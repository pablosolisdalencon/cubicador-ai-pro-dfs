const express = require('express');
const router = express.Router();
const passport = require('passport');

// Load Project Model
const Project = require('../../models/Project');

// @route   GET api/projects/test
// @desc    Tests post route
// @access  Public
router.get('/test', (req, res) => res.json({ msg: 'Projects Works' }));

// @route   GET api/projects
// @desc    Get projects
// @access  Private
router.get(
  '/',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    Project.find({ user: req.user.id })
      .sort({ date: -1 })
      .then(projects => res.json(projects))
      .catch(err => res.status(404).json({ nopostsfound: 'No projects found' }));
  }
);

// @route   GET api/projects/:id
// @desc    Get project by id
// @access  Private
router.get(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    Project.findById(req.params.id)
      .then(project => res.json(project))
      .catch(err =>
        res.status(404).json({ noprojectfound: 'No project found with that ID' })
      );
  }
);

// @route   POST api/projects
// @desc    Create project
// @access  Private
router.post(
  '/',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    const newProject = new Project({
      name: req.body.name,
      description: req.body.description,
      client: req.body.client,
      user: req.user.id
    });

    newProject.save().then(project => res.json(project));
  }
);

// @route   DELETE api/projects/:id
// @desc    Delete project
// @access  Private
router.delete(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    Project.findOne({ user: req.user.id, _id: req.params.id })
      .then(project => {
        if (!project) {
          return res.status(404).json({ projectnotfound: 'No project found' });
        }
        // Delete
        project.remove().then(() => res.json({ success: true }));
      })
      .catch(err => res.status(404).json({ projectnotfound: 'No project found' }));
  }
);

module.exports = router;
