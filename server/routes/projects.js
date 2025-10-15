const express = require('express');
const router = express.Router();
const Project = require('../models/Project');
const auth = require('../middleware/auth'); // Import the auth middleware

// Apply the auth middleware to all routes in this file
router.use(auth);

// GET /api/projects
// Get all projects for the logged-in user
router.get('/', async (req, res) => {
  try {
    const projects = await Project.find({ user: req.userId }).populate('user', 'name email');
    res.json(projects);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// GET /api/projects/:id
// Get a single project by its ID
router.get('/:id', async (req, res) => {
  try {
    const project = await Project.findById(req.params.id).populate('user', 'name email');
    // Security check: ensure the project belongs to the logged-in user
    if (!project || project.user._id.toString() !== req.userId) {
      return res.status(404).json({ error: 'Project not found' });
    }
    res.json(project);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// POST /api/projects
// Create a new project for the logged-in user
router.post('/', async (req, res) => {
  try {
    const { name, location, lead } = req.body;
    if (!name || !location || !lead) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const newProject = new Project({
      name,
      location,
      lead,
      user: req.userId, // Use the user ID from the authenticated token
    });

    const savedProject = await newProject.save();
    res.status(201).json(savedProject);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
