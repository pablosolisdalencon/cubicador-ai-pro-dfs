const express = require('express');
const router = express.Router();
const passport = require('passport');

// @route   POST api/ai/suggest-waste-factor
// @desc    Suggest a waste factor based on historical data
// @access  Private
router.post(
  '/suggest-waste-factor',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    // AI simulation: In a real implementation, this would query a model.
    // For now, we'll return a static suggestion.
    const { cubicationItemDescription } = req.body;
    console.log(`AI: Analyzing waste factor for "${cubicationItemDescription}"`);
    res.json({ suggestedWasteFactor: 0.05 }); // 5% waste
  }
);

// @route   POST api/ai/suggest-supplies
// @desc    Suggest supplies for a cubication item
// @access  Private
router.post(
  '/suggest-supplies',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    // AI simulation
    const { cubicationItemDescription } = req.body;
    console.log(`AI: Suggesting supplies for "${cubicationItemDescription}"`);
    // Mock response
    res.json([
      { supplyId: 'mockId1', name: 'Cement', quantity: 10 },
      { supplyId: 'mockId2', name: 'Sand', quantity: 20 },
    ]);
  }
);

// @route   GET api/ai/budget-deviation/:projectId
// @desc    Analyze budget deviation for a project
// @access  Private
router.get(
  '/budget-deviation/:projectId',
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    // AI simulation
    console.log(`AI: Analyzing budget deviation for project ${req.params.projectId}`);
    res.json({
      deviation: 0.15, // 15% deviation
      status: 'warning',
      message: 'Project is trending 15% over budget.'
    });
  }
);

module.exports = router;
