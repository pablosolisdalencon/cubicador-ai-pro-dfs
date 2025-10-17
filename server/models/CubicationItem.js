const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const CubicationItemSchema = new Schema({
  project: {
    type: Schema.Types.ObjectId,
    ref: 'project',
    required: true
  },
  description: {
    type: String,
    required: true
  },
  unit: {
    type: String,
    required: true
  },
  formula: {
    type: String
  },
  dimensions: {
    length: { type: Number, default: 0 },
    width: { type: Number, default: 0 },
    height: { type: Number, default: 0 }
  },
  wasteFactor: {
    type: Number,
    default: 0
  },
  laborEfficiency: {
    type: Number,
    default: 0
  },
  supplies: [{
    supply: {
      type: Schema.Types.ObjectId,
      ref: 'supply'
    },
    quantity: {
      type: Number,
      required: true
    }
  }]
});

module.exports = CubicationItem = mongoose.model('cubicationItem', CubicationItemSchema);
