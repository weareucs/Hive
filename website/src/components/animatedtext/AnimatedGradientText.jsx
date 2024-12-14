import React, { useEffect, useState } from "react";
import "@fontsource/epilogue"; // Import the Epilogue font
import "../../index.css";

const AnimatedGradientText = () => {
  const [rotation, setRotation] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setRotation((prev) => (prev + 0.01) % 1); // Update rotation value
    }, 16); // ~60FPS

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="gradient-text-container">
      <h1
        className="gradient-text"
        style={{
          background: `linear-gradient(
            ${rotation * 360}deg,
            #ff5722,    
            #ffc107,
            #fefdb3
          )`,
        }}
      >
        Hive.
      </h1>
    </div>
  );
};

export default AnimatedGradientText;
