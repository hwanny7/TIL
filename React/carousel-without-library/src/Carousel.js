import React, { useEffect, useState } from "react";
import "./Carousel.css";

function Carousel(props) {
  const { children } = props;
  console.log(children.length);

  const [currentIndex, setCurrentIndex] = useState(0);
  const [length, setLength] = useState(children.length);

  useEffect(() => {
    console.log("여기");
    setLength(children.length);
  }, [children]);

  const next = () => {
    if (currentIndex < length - 1) {
      setCurrentIndex((prevState) => prevState + 1);
    }
  };

  const prev = () => {
    if (currentIndex > 0) {
      setCurrentIndex((prevState) => prevState - 1);
    }
  };

  return (
    <div className="carousel-container">
      {currentIndex > 0 && (
        <button onClick={prev} className="left-arrow">
          Left
        </button>
      )}
      <div className="carousel-wrapper">
        <div className="carousel-content-wrapper">
          <div
            className="carousel-content"
            style={{ transform: `translateX(-${currentIndex * 100}%)` }}
          >
            {children}
          </div>
        </div>
      </div>
      {currentIndex < length - 1 && (
        <button onClick={next} className="right-arrow">
          Right
        </button>
      )}
    </div>
  );
}

export default Carousel;
