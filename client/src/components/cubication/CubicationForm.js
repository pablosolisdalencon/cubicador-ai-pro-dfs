import React, { useState } from 'react';
import axios from 'axios';

const CubicationForm = ({ projectId }) => {
  const [formData, setFormData] = useState({
    description: '',
    unit: '',
    dimensions: {
      length: '',
      width: '',
      height: ''
    }
  });

  const { description, unit, dimensions } = formData;

  const onChange = e => {
    if (e.target.name in dimensions) {
      setFormData({
        ...formData,
        dimensions: { ...dimensions, [e.target.name]: e.target.value }
      });
    } else {
      setFormData({ ...formData, [e.target.name]: e.target.value });
    }
  };

  const onSubmit = e => {
    e.preventDefault();
    axios
      .post('/api/cubicationItems', { ...formData, project: projectId })
      .then(res => console.log(res.data))
      .catch(err => console.error(err));
  };

  return (
    <div>
      <h3>Add Cubication Item</h3>
      <form onSubmit={onSubmit}>
        <input
          type="text"
          placeholder="Description"
          name="description"
          value={description}
          onChange={onChange}
        />
        <input
          type="text"
          placeholder="Unit"
          name="unit"
          value={unit}
          onChange={onChange}
        />
        <input
          type="number"
          placeholder="Length"
          name="length"
          value={dimensions.length}
          onChange={onChange}
        />
        <input
          type="number"
          placeholder="Width"
          name="width"
          value={dimensions.width}
          onChange={onChange}
        />
        <input
          type="number"
          placeholder="Height"
          name="height"
          value={dimensions.height}
          onChange={onChange}
        />
        <input type="submit" value="Add Item" />
      </form>
    </div>
  );
};

export default CubicationForm;
