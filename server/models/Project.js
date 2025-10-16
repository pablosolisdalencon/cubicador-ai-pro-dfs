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
  location: {
    type: String,
  },
  responsibleTechnician: {
    type: Schema.Types.ObjectId,
    ref: 'users'
  },
  designStandard: {
    type: String,
  },
  versionHistory: [{
    date: {
      type: Date,
      default: Date.now
    },
    description: {
      type: String
    }
  }],
  wbs: [{
    type: String
  }],
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
