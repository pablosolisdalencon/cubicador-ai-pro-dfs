import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Login from './components/auth/Login';
import Register from './components/auth/Register';
import Dashboard from './components/projects/Dashboard';
import Project from './components/projects/Project';
import ProjectForm from './components/projects/ProjectForm';
import Supplies from './components/supplies/Supplies';
import SupplyForm from './components/supplies/SupplyForm';
import NotasDeVersion from './components/release-notes/NotasDeVersion';

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route exact path="/register" element={<Register />} />
          <Route exact path="/login" element={<Login />} />
          <Route exact path="/dashboard" element={<Dashboard />} />
          <Route exact path="/project/:id" element={<Project />} />
          <Route exact path="/create-project" element={<ProjectForm />} />
          <Route exact path="/edit-project/:id" element={<ProjectForm />} />
          <Route exact path="/supplies" element={<Supplies />} />
          <Route exact path="/add-supply" element={<SupplyForm />} />
          <Route exact path="/edit-supply/:id" element={<SupplyForm />} />
          <Route exact path="/release-notes" element={<NotasDeVersion />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
