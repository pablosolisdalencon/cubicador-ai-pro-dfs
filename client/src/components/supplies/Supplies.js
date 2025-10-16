import React, { useEffect, useState } from 'react';
import axios from 'axios';

const Supplies = () => {
  const [supplies, setSupplies] = useState([]);

  useEffect(() => {
    axios
      .get('/api/supplies')
      .then(res => {
        setSupplies(res.data);
      })
      .catch(err => {
        console.log(err);
      });
  }, []);

  return (
    <div>
      <h1>Supply Catalog</h1>
      {supplies.map(supply => (
        <div key={supply._id}>
          <h4>{supply.name}</h4>
          <p>Type: {supply.type}</p>
          <p>Price: ${supply.unitPrice}</p>
          <p>Unit: {supply.measurementUnit}</p>
        </div>
      ))}
    </div>
  );
};

export default Supplies;
