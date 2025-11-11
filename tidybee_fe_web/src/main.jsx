import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.jsx";
import { Toaster } from "react-hot-toast";

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <App />
    <Toaster
      position="top-center"
      toastOptions={{
        duration: 2500,
        style: {
          background: "#333",
          color: "#fff",
          borderRadius: "12px",
          padding: "12px 18px",
        },
      }}
    />
  </StrictMode>
);
