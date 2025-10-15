import React from 'react';
import { useNavigate } from 'react-router-dom';
import { GoogleLogin } from '@react-oauth/google';
import { useAuth } from '../AuthContext';

const Login = () => {
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSuccess = async (credentialResponse) => {
    try {
      const res = await fetch('http://localhost:5001/api/auth/google', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ token: credentialResponse.credential }),
      });

      if (!res.ok) {
        throw new Error('Backend authentication failed');
      }

      const { token, user } = await res.json();

      // Update the auth state with both user and token
      login(user, token);

      navigate('/dashboard');
    } catch (error) {
      console.error('Login Error:', error);
      alert('Login Failed. Please try again.');
    }
  };

  const handleError = () => {
    console.log('Login Failed');
    alert('Login Failed. Please try again.');
  };

  return (
    <div>
      <h2>Login</h2>
      <p>Please log in with your Google account to continue.</p>
      <GoogleLogin
        onSuccess={handleSuccess}
        onError={handleError}
      />
    </div>
  );
};

export default Login;
