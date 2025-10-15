import React, { useState, useEffect } from 'react';

const ProjectList = () => {
  const [projects, setProjects] = useState([]);

  useEffect(() => {
    // Aquí se haría la llamada al API para obtener los proyectos
    // fetch('/api/projects')
    //   .then(res => res.json())
    //   .then(data => setProjects(data));
  }, []);

  return (
    <div>
      <h2>Proyectos</h2>
      <ul>
        {projects.map(project => (
          <li key={project._id}>{project.name}</li>
        ))}
      </ul>
    </div>
  );
};

export default ProjectList;
