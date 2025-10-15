import React, { useState } from 'react';

const ProjectForm = () => {
  const [formData, setFormData] = useState({
    name: '',
    technicalManager: '',
    designStandard: '',
  });

  const { name, technicalManager, designStandard } = formData;

  const onChange = e => setFormData({ ...formData, [e.target.name]: e.target.value });

  const onSubmit = e => {
    e.preventDefault();
    // Aquí se haría la llamada al API para crear o actualizar un proyecto
    console.log(formData);
  };

  return (
    <div>
      <h2>Crear/Editar Proyecto</h2>
      <form onSubmit={onSubmit}>
        <div>
          <input
            type="text"
            placeholder="Nombre del Proyecto"
            name="name"
            value={name}
            onChange={onChange}
            required
          />
        </div>
        <div>
          <input
            type="text"
            placeholder="Responsable Técnico"
            name="technicalManager"
            value={technicalManager}
            onChange={onChange}
            required
          />
        </div>
        <div>
          <input
            type="text"
            placeholder="Normativa de Diseño"
            name="designStandard"
            value={designStandard}
            onChange={onChange}
            required
          />
        </div>
        <input type="submit" value="Guardar" />
      </form>
    </div>
  );
};

export default ProjectForm;
