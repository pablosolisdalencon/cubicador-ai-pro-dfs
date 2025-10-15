import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import ProjectList from './components/ProjectList';
import ProjectForm from './components/ProjectForm';
import ProjectDetail from './components/ProjectDetail';

const App = () => {
  return (
    <Router>
      <div>
        <h1>Cubicador AI Pro</h1>
        <Routes>
          <Route exact path="/" element={<ProjectList />} />
          <Route exact path="/projects/new" element={<ProjectForm />} />
          <Route exact path="/projects/:id" element={<ProjectDetail />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
