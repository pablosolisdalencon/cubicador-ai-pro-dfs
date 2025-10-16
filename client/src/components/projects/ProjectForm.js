import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

const ProjectForm = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    client: ''
  });

  const { name, description, client } = formData;

  const onChange = e =>
    setFormData({ ...formData, [e.target.name]: e.target.value });

  const onSubmit = e => {
    e.preventDefault();
    axios
      .post('/api/projects', formData)
      .then(res => {
        navigate('/dashboard');
      })
      .catch(err => {
        console.error(err);
      });
  };

  return (
    <div>
      <h1>Create or Edit Project</h1>
      <form onSubmit={onSubmit}>
        <div className="form-group">
          <input
            type="text"
            placeholder="Project Name"
            name="name"
            value={name}
            onChange={onChange}
            required
          />
        </div>
        <div className="form-group">
          <textarea
            placeholder="Project Description"
            name="description"
            value={description}
            onChange={onChange}
          />
        </div>
        <div className="form-group">
          <input
            type="text"
            placeholder="Client"
            name="client"
            value={client}
            onChange={onChange}
          />
        </div>
        <input type="submit" className="btn btn-primary" value="Submit" />
      </form>
    </div>
  );
};

export default ProjectForm;
