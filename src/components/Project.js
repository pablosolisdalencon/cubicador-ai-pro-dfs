import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { useAuth } from '../AuthContext';

const Project = () => {
  const { id } = useParams();
  const { token } = useAuth();
  const [project, setProject] = useState(null);
  const [length, setLength] = useState('');
  const [width, setWidth] = useState('');
  const [height, setHeight] = useState('');
  const [units, setUnits] = useState(1);
  const [material, setMaterial] = useState('concrete');
  const [volume, setVolume] = useState(0);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchProject = async () => {
      if (token) {
        try {
          const res = await fetch(`http://localhost:5001/api/projects/${id}`, {
            headers: {
              'Authorization': `Bearer ${token}`,
            },
          });
          if (!res.ok) {
            throw new Error('Failed to fetch project');
          }
          const data = await res.json();
          setProject(data);
        } catch (err) {
          setError(err.message);
        }
      }
    };
    fetchProject();
  }, [id, token]);

  useEffect(() => {
    const l = parseFloat(length) || 0;
    const w = parseFloat(width) || 0;
    const h = parseFloat(height) || 0;
    const u = parseInt(units) || 0;
    setVolume(l * w * h * u);
  }, [length, width, height, units]);

  if (error) {
    return <div>Error: {error}</div>;
  }

  if (!project) {
    return <div>Loading project...</div>;
  }

  return (
    <div>
      <h2>{project.name} - Cubication</h2>
      <p><strong>Location:</strong> {project.location}</p>
      <p><strong>Technical Lead:</strong> {project.lead}</p>

      <div className="cubication-form">
        <h3>Add New Item</h3>
        <form>
          <div>
            <label>Length (m):</label>
            <input
              type="number"
              value={length}
              onChange={(e) => setLength(e.target.value)}
            />
          </div>
          <div>
            <label>Width (m):</label>
            <input
              type="number"
              value={width}
              onChange={(e) => setWidth(e.target.value)}
            />
          </div>
          <div>
            <label>Height (m):</label>
            <input
              type="number"
              value={height}
              onChange={(e) => setHeight(e.target.value)}
            />
          </div>
          <div>
            <label>Number of Units:</label>
            <input
              type="number"
              value={units}
              onChange={(e) => setUnits(e.target.value)}
            />
          </div>
          <div>
            <label>Material:</label>
            <select value={material} onChange={(e) => setMaterial(e.target.value)}>
              <option value="concrete">Concrete</option>
              <option value="brick">Brick</option>
              <option value="steel">Steel</option>
              <option value="earth">Earth</option>
            </select>
          </div>
        </form>

        <div className="results">
          <h3>Calculated Volume:</h3>
          <p><strong>{volume.toFixed(2)} m³</strong></p>
        </div>
      </div>
    </div>
  );
};

export default Project;
