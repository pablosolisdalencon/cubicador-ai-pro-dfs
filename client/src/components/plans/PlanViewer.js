import React from 'react';

const PlanViewer = ({ imageUrl }) => {
  return (
    <div>
      <h3>Plan Viewer</h3>
      {imageUrl ? (
        <img src={imageUrl} alt="Plan" style={{ maxWidth: '100%' }} />
      ) : (
        <p>No plan uploaded yet.</p>
      )}
    </div>
  );
};

export default PlanViewer;
