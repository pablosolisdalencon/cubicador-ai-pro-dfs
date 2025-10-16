import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';
import CubicationItem from '../cubication/CubicationItem';
import CubicationForm from '../cubication/CubicationForm';
import PlanUploader from '../plans/PlanUploader';
import PlanViewer from '../plans/PlanViewer';
import ReportGenerator from '../reports/ReportGenerator';

const Project = () => {
  const { id } = useParams();
  const [project, setProject] = useState(null);
  const [cubicationItems, setCubicationItems] = useState([]);

  useEffect(() => {
    axios.get(`/api/projects/${id}`).then(res => setProject(res.data));

    axios
      .get(`/api/cubicationItems/project/${id}`)
      .then(res => {
        setCubicationItems(res.data);
      })
      .catch(err => console.log(err));
  }, [id]);

  if (!project) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <h1>Project Details</h1>
      <h2>{project.name}</h2>
      <hr />
      <PlanUploader projectId={id} />
      <PlanViewer imageUrl={project.planImageUrl} />
      <hr />
      <h3>Cubication Items</h3>
      {cubicationItems.map(item => (
        <CubicationItem key={item._id} item={item} />
      ))}
      <hr />
      <CubicationForm projectId={id} />
      <hr />
      <ReportGenerator projectId={id} projectName={project.name} />
    </div>
  );
};

export default Project;
