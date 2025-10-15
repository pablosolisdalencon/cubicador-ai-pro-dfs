import React, { useContext, useState, useEffect } from 'react';
import { jwtDecode } from "jwt-decode";


const AuthContext = React.createContext();

export function useAuth() {
  return useContext(AuthContext);
}

export function AuthProvider({ children }) {
  const [currentUser, setCurrentUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem('token'));
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (token) {
      // In a real app, you'd verify the token with the backend here.
      // For this prototype, we'll just decode it and assume it's valid if it exists.
      try {
        const decoded = jwtDecode(token);
        // We don't have the full user object here, just the ID.
        // A real app would have a /api/users/me endpoint to get the user data.
        // For now, we'll store a simplified user object.
        setCurrentUser({ _id: decoded.userId });
      } catch (error) {
        // If token is invalid, remove it
        localStorage.removeItem('token');
        setToken(null);
      }
    }
    setLoading(false);
  }, [token]);

  const login = (userData, jwtToken) => {
    localStorage.setItem('token', jwtToken);
    setToken(jwtToken);
    setCurrentUser(userData);
  };

  const logout = () => {
    localStorage.removeItem('token');
    setToken(null);
    setCurrentUser(null);
  };

  const value = {
    currentUser,
    token,
    login,
    logout,
  };

  return (
    <AuthContext.Provider value={value}>
      {!loading && children}
    </AuthContext.Provider>
  );
}
