import React, { useEffect, useState } from "react";
import "./Carousel.css";

function Carousel(props) {
  const { children } = props;
  console.log(children.length);

  const [currentIndex, setCurrentIndex] = useState(0);
  const [length, setLength] = useState(children.length);
  const [touchPosition, setTouchPosition] = useState(null);
  // to verify either touch or not

  useEffect(() => {
    console.log("여기");
    setLength(children.length);
  }, [children]);

  const next = () => {
    if (currentIndex < length - 3) {
      setCurrentIndex((prevState) => prevState + 1);
    }
  };

  const prev = () => {
    if (currentIndex > 0) {
      setCurrentIndex((prevState) => prevState - 1);
    }
  };

  //   const handleTouchStart = (e) => {
  //     const touchDown = e.touches[0].clientX;
  //     setTouchPosition(touchDown);
  //   };

  //   const handleTouchMove = (e) => {
  //     const touchDown = touchPosition;

  //     if (touchDown === null) {
  //       return;
  //     }

  //     const currentTouch = e.touches[0].clientX;
  //     const diff = touchDown - currentTouch;

  //     if (diff > 5) {
  //       next();
  //     }

  //     if (diff < -5) {
  //       prev();
  //     }

  //     setTouchPosition(null);
  //   };

  return (
    <div className="carousel-container">
      {currentIndex > 0 && (
        <button onClick={prev} className="left-arrow">
          Left
        </button>
      )}
      {/* <div
        className="carousel-wrapper"
        onTouchStart={handleTouchStart}
        onTouchMove={handleTouchMove}
      > */}
      <div className="carousel-content-wrapper">
        <div
          className="carousel-content"
          style={{ transform: `translateX(-${currentIndex * 35}%)` }}
        >
          {children}
        </div>
      </div>
      {/* </div> */}
      {currentIndex < length - 3 && (
        <button onClick={next} className="right-arrow">
          Right
        </button>
      )}
    </div>
  );
}

export default Carousel;
