import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { db } from '../firebase';
import { doc, getDoc } from 'firebase/firestore';

const Project = () => {
  const { id } = useParams();
  const [project, setProject] = useState(null);
  const [length, setLength] = useState('');
  const [width, setWidth] = useState('');
  const [height, setHeight] = useState('');
  const [units, setUnits] = useState(1);
  const [material, setMaterial] = useState('concrete');
  const [volume, setVolume] = useState(0);

  useEffect(() => {
    const getProject = async () => {
      const docRef = doc(db, 'projects', id);
      const docSnap = await getDoc(docRef);
      if (docSnap.exists()) {
        setProject(docSnap.data());
      } else {
        console.log('No such document!');
      }
    };
    getProject();
  }, [id]);

  useEffect(() => {
    const l = parseFloat(length) || 0;
    const w = parseFloat(width) || 0;
    const h = parseFloat(height) || 0;
    const u = parseInt(units) || 0;
    setVolume(l * w * h * u);
  }, [length, width, height, units]);

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
