import React, { useState, useEffect } from 'react';

const ProjectDetail = ({ match }) => {
  const [project, setProject] = useState(null);

  useEffect(() => {
    // Aquí se haría la llamada al API para obtener los detalles de un proyecto
    // fetch(`/api/projects/${match.params.id}`)
    //   .then(res => res.json())
    //   .then(data => setProject(data));
  }, [match.params.id]);

  if (!project) {
    return <div>Cargando...</div>;
  }

  return (
    <div>
      <h2>{project.name}</h2>
      <p><strong>Responsable Técnico:</strong> {project.technicalManager}</p>
      <p><strong>Normativa de Diseño:</strong> {project.designStandard}</p>
    </div>
  );
};

export default ProjectDetail;
