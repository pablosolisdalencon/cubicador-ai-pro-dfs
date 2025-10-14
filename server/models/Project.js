const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Create Schema
const ProjectSchema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'users'
  },
  name: {
    type: String,
    required: true
  },
  description: {
    type: String
  },
  client: {
    type: String
  },
  date: {
    type: Date,
    default: Date.now
  }
});

module.exports = Project = mongoose.model('project', ProjectSchema);
