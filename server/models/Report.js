const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const ReportSchema = new Schema({
  project: {
    type: Schema.Types.ObjectId,
    ref: 'project',
    required: true
  },
  title: {
    type: String,
    required: true
  },
  generatedDate: {
    type: Date,
    default: Date.now
  },
  data: {
    type: Object
  },
  executiveSummary: {
    type: String
  }
});

module.exports = Report = mongoose.model('report', ReportSchema);
