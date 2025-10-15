const mongoose = require('mongoose');

const wbsSchema = new mongoose.Schema({
  name: { type: String, required: true },
  items: [{ type: mongoose.Schema.Types.ObjectId, ref: 'WbsItem' }]
});

const projectSchema = new mongoose.Schema({
  name: { type: String, required: true },
  location: {
    address: { type: String },
    gps: {
      lat: { type: Number },
      lng: { type: Number }
    }
  },
  technicalManager: { type: String, required: true },
  designStandard: { type: String, required: true },
  versionHistory: [{
    date: { type: Date, default: Date.now },
    description: { type: String }
  }],
  wbs: [wbsSchema]
});

const Project = mongoose.model('Project', projectSchema);

module.exports = Project;
