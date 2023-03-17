import React, { useState } from "react";

function Carousel(props) {
  const { children } = props;

  const [currentIndex, setCurrentIndex] = useState(0);
  const [length, setLength] = children.length;

  return (
    <div className="carousel-container">
      <button className="left-arrow">Left</button>
      <div className="carousel-wrapper">
        <div className="carousel-content-wrapper">
          <div className="carousel-content">{children}</div>
        </div>
      </div>
      <button className="right-arrow">right</button>
    </div>
  );
}

export default Carousel;
