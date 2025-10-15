const express = require('express');
const router = express.Router();
const projectController = require('../controllers/project.controller');

// @route   GET api/projects
// @desc    Get all projects
// @access  Public
router.get('/', projectController.getProjects);

// @route   POST api/projects
// @desc    Create a project
// @access  Public
router.post('/', projectController.createProject);

// @route   GET api/projects/:id
// @desc    Get a single project by ID
// @access  Public
router.get('/:id', projectController.getProjectById);

// @route   PUT api/projects/:id
// @desc    Update a project
// @access  Public
router.put('/:id', projectController.updateProject);

// @route   DELETE api/projects/:id
// @desc    Delete a project
// @access  Public
router.delete('/:id', projectController.deleteProject);

module.exports = router;
