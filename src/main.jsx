import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './styles/global.css'

// Safety net: mock mode must never run in a production build. If the
// VITE_MOCK_MODE flag ever leaks into a Vercel deploy, fail loud at
// startup instead of silently signing the user in as mock-admin.
if (import.meta.env.VITE_MOCK_MODE === 'true' && import.meta.env.PROD) {
  throw new Error('MOCK_MODE must not run in production')
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
