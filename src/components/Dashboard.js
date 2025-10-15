import React, { useState, useEffect } from 'react';
import { useAuth } from '../AuthContext';
import { Link } from 'react-router-dom';

const Dashboard = () => {
  const { currentUser, token } = useAuth();
  const [projects, setProjects] = useState([]);
  const [projectName, setProjectName] = useState('');
  const [projectLocation, setProjectLocation] = useState('');
  const [projectLead, setProjectLead] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchProjects = async () => {
      if (currentUser && token) {
        try {
          const res = await fetch('http://localhost:5001/api/projects', {
            headers: {
              'Authorization': `Bearer ${token}`,
            },
          });
          if (!res.ok) {
            throw new Error('Failed to fetch projects');
          }
          const data = await res.json();
          setProjects(data);
        } catch (err) {
          setError(err.message);
        }
      }
    };
    fetchProjects();
  }, [currentUser, token]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (!projectName || !projectLocation || !projectLead) {
      setError('Please fill out all fields.');
      return;
    }
    try {
      const res = await fetch('http://localhost:5001/api/projects', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify({
          name: projectName,
          location: projectLocation,
          lead: projectLead,
        }),
      });

      if (!res.ok) {
        throw new Error('Failed to create project');
      }

      const newProject = await res.json();
      setProjects([...projects, newProject]);
      setProjectName('');
      setProjectLocation('');
      setProjectLead('');
    } catch (err) {
      setError('Failed to create project. ' + err.message);
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
              <li key={project._id}>
                <Link to={`/project/${project._id}`}>
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
