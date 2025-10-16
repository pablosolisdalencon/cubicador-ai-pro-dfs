import React from 'react';
import axios from 'axios';
import { saveAs } from 'file-saver';

const ReportGenerator = ({ projectId, projectName }) => {
  const generateReport = (format) => {
    axios({
      url: `/api/reports/${projectId}`,
      method: 'POST',
      responseType: 'blob', // Important
      data: { format }
    }).then((response) => {
      const extension = format === 'pdf' ? 'pdf' : 'xlsx';
      const blob = new Blob([response.data], { type: response.headers['content-type'] });
      saveAs(blob, `${projectName}-report.${extension}`);
    });
  };

  return (
    <div>
      <h3>Generate Reports</h3>
      <button onClick={() => generateReport('pdf')}>Export as PDF</button>
      <button onClick={() => generateReport('excel')}>Export as Excel</button>
    </div>
  );
};

export default ReportGenerator;
