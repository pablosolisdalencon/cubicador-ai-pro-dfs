import React from 'react';

const NotasDeVersion = () => {
  const features = [
    { name: 'Frontend: React (Web)', status: '✅', category: 'Arquitectura' },
    { name: 'Backend: Node.js/Express.js', status: '✅', category: 'Arquitectura' },
    { name: 'Base de Datos: MongoDB', status: '✅', category: 'Arquitectura' },
    { name: 'Autenticación: Google Auth (OAuth 2.0)', status: '✅', category: 'Arquitectura' },
    { name: 'Restricción: No Firebase/Firestore', status: '✅', category: 'Arquitectura' },
    { name: 'Gestión de Proyectos Estructurada', status: '✅', category: 'Cubicación Avanzada' },
    { name: 'Módulo de Cubicacion Parametrizable', status: '✅', category: 'Cubicación Avanzada' },
    { name: 'Herramienta de Medición Visual', status: '⚠️', category: 'Cubicación Avanzada', notes: 'Solo carga de archivos, sin trazado.' },
    { name: 'Catálogo de Insumos Dinámico', status: '✅', category: 'Cubicación Avanzada' },
    { name: 'Análisis Predictivo de Rendimiento', status: ' simulating ', category: 'IA', notes: 'Endpoint simulado en backend.' },
    { name: 'Asistente Inteligente de Catálogo', status: ' simulating ', category: 'IA', notes: 'Endpoint simulado en backend.' },
    { name: 'Monitoreo de Desviación Presupuestaria', status: ' simulating ', category: 'IA', notes: 'Endpoint simulado en backend.' },
    { name: 'Generación de Reportes (PDF/Excel)', status: '✅', category: 'Reportes' },
    { name: 'Resumen Ejecutivo (IA-Generado)', status: '⚠️', category: 'Reportes', notes: 'Placeholder en el reporte.' },
  ];

  const categories = [...new Set(features.map(f => f.category))];

  return (
    <div style={{ padding: '20px' }}>
      <h1>Notas de Versión - AI-Cubicador Pro v2.0</h1>
      {categories.map(category => (
        <div key={category}>
          <h2>{category}</h2>
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ borderBottom: '1.3px solid black' }}>
                <th style={{ textAlign: 'left' }}>Funcionalidad</th>
                <th style={{ textAlign: 'left' }}>Estado</th>
                <th style={{ textAlign: 'left' }}>Observaciones</th>
              </tr>
            </thead>
            <tbody>
              {features.filter(f => f.category === category).map(feature => (
                <tr key={feature.name} style={{ borderBottom: '1px solid #eee' }}>
                  <td>{feature.name}</td>
                  <td>{feature.status}</td>
                  <td>{feature.notes || ''}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ))}
    </div>
  );
};

export default NotasDeVersion;
