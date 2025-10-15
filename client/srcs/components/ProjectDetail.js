import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';

const ProjectDetail = () => {
  const [project, setProject] = useState(null);
  const { id } = useParams();

  useEffect(() => {
    // Aquí se haría la llamada al API para obtener los detalles de un proyecto
    // fetch(`/api/projects/${id}`)
    //   .then(res => res.json())
    //   .then(data => setProject(data));
  }, [id]);

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
