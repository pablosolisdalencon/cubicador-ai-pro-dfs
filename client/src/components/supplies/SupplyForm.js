import React, { useState } from 'react';
import axios from 'axios';

const SupplyForm = () => {
  const [formData, setFormData] = useState({
    name: '',
    type: 'Material',
    unitPrice: '',
    measurementUnit: ''
  });

  const { name, type, unitPrice, measurementUnit } = formData;

  const onChange = e =>
    setFormData({ ...formData, [e.target.name]: e.target.value });

  const onSubmit = e => {
    e.preventDefault();
    axios
      .post('/api/supplies', formData)
      .then(res => {
        console.log(res.data);
      })
      .catch(err => {
        console.error(err);
      });
  };

  return (
    <div>
      <h1>Add or Edit Supply</h1>
      <form onSubmit={onSubmit}>
        <input
          type="text"
          placeholder="Supply Name"
          name="name"
          value={name}
          onChange={onChange}
          required
        />
        <select name="type" value={type} onChange={onChange}>
          <option value="Material">Material</option>
          <option value="Labor">Labor</option>
          <option value="Equipment">Equipment</option>
        </select>
        <input
          type="number"
          placeholder="Unit Price"
          name="unitPrice"
          value={unitPrice}
          onChange={onChange}
          required
        />
        <input
          type="text"
          placeholder="Measurement Unit"
          name="measurementUnit"
          value={measurementUnit}
          onChange={onChange}
          required
        />
        <input type="submit" value="Submit" />
      </form>
    </div>
  );
};

export default SupplyForm;
