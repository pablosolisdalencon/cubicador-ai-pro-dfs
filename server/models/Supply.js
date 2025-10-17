const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const SupplySchema = new Schema({
  name: {
    type: String,
    required: true
  },
  type: {
    type: String,
    enum: ['Material', 'Labor', 'Equipment'],
    required: true
  },
  unitPrice: {
    type: Number,
    required: true
  },
  measurementUnit: {
    type: String,
    required: true
  },
  efficiency: {
    type: Number
  }
});

module.exports = Supply = mongoose.model('supply', SupplySchema);
