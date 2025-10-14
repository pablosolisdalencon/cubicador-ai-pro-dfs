import React, { useState, useEffect } from 'react';
import { db } from '../firebase';
import { collection, addDoc, query, where, onSnapshot } from 'firebase/firestore';
import { useAuth } from '../AuthContext';
import { Link } from 'react-router-dom';

const Dashboard = () => {
  const { currentUser } = useAuth();
  const [projects, setProjects] = useState([]);
  const [projectName, setProjectName] = useState('');
  const [projectLocation, setProjectLocation] = useState('');
  const [projectLead, setProjectLead] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    if (currentUser) {
      const q = query(collection(db, 'projects'), where('uid', '==', currentUser.uid));
      const unsubscribe = onSnapshot(q, (querySnapshot) => {
        const projectsData = [];
        querySnapshot.forEach((doc) => {
          projectsData.push({ ...doc.data(), id: doc.id });
        });
        setProjects(projectsData);
      });
      return unsubscribe;
    }
  }, [currentUser]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (!projectName || !projectLocation || !projectLead) {
      setError('Please fill out all fields.');
      return;
    }
    try {
      await addDoc(collection(db, 'projects'), {
        name: projectName,
        location: projectLocation,
        lead: projectLead,
        uid: currentUser.uid,
        createdAt: new Date(),
      });
      setProjectName('');
      setProjectLocation('');
      setProjectLead('');
    } catch (error) {
      setError('Failed to create project. ' + error.message);
    }
  };

  return (
    <div>
      <h2>Dashboard</h2>

      <div className="create-project-form">
        <h3>Create New Project</h3>
        {error && <p style={{ color: 'red' }}>{error}</p>}
        <form onSubmit={handleSubmit}>
          <div>
            <label>Project Name:</label>
            <input
              type="text"
              value={projectName}
              onChange={(e) => setProjectName(e.target.value)}
              required
            />
          </div>
          <div>
            <label>Location:</label>
            <input
              type="text"
              value={projectLocation}
              onChange={(e) => setProjectLocation(e.target.value)}
              required
            />
          </div>
          <div>
            <label>Technical Lead:</label>
            <input
              type="text"
              value={projectLead}
              onChange={(e) => setProjectLead(e.target.value)}
              required
            />
          </div>
          <button type="submit">Create Project</button>
        </form>
      </div>

      <hr />

      <div className="project-list">
        <h3>Your Projects</h3>
        {projects.length > 0 ? (
          <ul>
            {projects.map((project) => (
              <li key={project.id}>
                <Link to={`/project/${project.id}`}>
                  <strong>{project.name}</strong> - {project.location} (Lead: {project.lead})
                </Link>
              </li>
            ))}
          </ul>
        ) : (
          <p>You don't have any projects yet. Create one above!</p>
        )}
      </div>
    </div>
  );
};

export default Dashboard;
