import React from 'react';

const CubicationItem = ({ item }) => {
  return (
    <div>
      <h4>{item.description}</h4>
      <p>Unit: {item.unit}</p>
      <p>
        Dimensions: {item.dimensions.length} x {item.dimensions.width} x{' '}
        {item.dimensions.height}
      </p>
    </div>
  );
};

export default CubicationItem;
