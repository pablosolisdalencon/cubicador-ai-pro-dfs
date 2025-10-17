import React, { useState } from 'react';
import axios from 'axios';

const PlanUploader = ({ projectId }) => {
  const [file, setFile] = useState(null);
  const [uploadedFile, setUploadedFile] = useState(null);

  const onFileChange = e => {
    setFile(e.target.files[0]);
  };

  const onSubmit = async e => {
    e.preventDefault();
    const formData = new FormData();
    formData.append('plan', file);

    try {
      const res = await axios.post('/api/uploads/plan', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      setUploadedFile(res.data);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div>
      <h3>Upload a Plan</h3>
      <form onSubmit={onSubmit}>
        <input type="file" onChange={onFileChange} />
        <button type="submit">Upload</button>
      </form>
      {uploadedFile && (
        <div>
          <h4>File Uploaded Successfully</h4>
          <img src={uploadedFile.filePath} alt="Uploaded Plan" width="300" />
        </div>
      )}
    </div>
  );
};

export default PlanUploader;
